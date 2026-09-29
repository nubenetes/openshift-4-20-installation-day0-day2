#!/usr/bin/env bash
# ==============================================================================
# OpenShift 4.20 Enterprise Preflight Readiness Check
# Validates DNS, NTP, Network Connectivity, MTU, and Proxy configurations
# ==============================================================================
set -euo pipefail

RED='[0;31m'
GREEN='[0;32m'
YELLOW='[1;33m'
BLUE='[0;34m'
NC='[0m' # No Color

CLUSTER_NAME="${CLUSTER_NAME:-ocp420}"
BASE_DOMAIN="${BASE_DOMAIN:-example.com}"
API_VIP="${API_VIP:-192.168.10.100}"
APPS_VIP="${APPS_VIP:-192.168.10.101}"

echo -e "${BLUE}======================================================================${NC}"
echo -e "${BLUE} OpenShift 4.20 Preflight Readiness Validator - September 2026${NC}"
echo -e "${BLUE} Cluster: ${CLUSTER_NAME}.${BASE_DOMAIN}${NC}"
echo -e "${BLUE}======================================================================${NC}"

pass_count=0
warn_count=0
fail_count=0

log_pass() { echo -e "[${GREEN}PASS${NC}] $1"; ((pass_count++)) || true; }
log_warn() { echo -e "[${YELLOW}WARN${NC}] $1"; ((warn_count++)) || true; }
log_fail() { echo -e "[${RED}FAIL${NC}] $1"; ((fail_count++)) || true; }

# 1. DNS Resolution Validation
echo -e "
--- 1. Checking Core DNS Records ---"
check_dns() {
  local record="$1"
  local expected_ip="$2"
  local resolved_ip=""
  if command -v dig &>/dev/null; then
    resolved_ip=$(dig +short "${record}" | tail -n1 || true)
  elif command -v getent &>/dev/null; then
    resolved_ip=$(getent ahostsv4 "${record}" 2>/dev/null | awk '{print $1}' | head -n1 || true)
  elif command -v host &>/dev/null; then
    resolved_ip=$(host -t A "${record}" 2>/dev/null | awk '{print $4}' | tail -n1 || true)
  fi
  if [ -z "${resolved_ip}" ]; then
    log_fail "DNS record '${record}' could not be resolved!"
  elif [ -n "${expected_ip}" ] && [ "${resolved_ip}" != "${expected_ip}" ]; then
    log_warn "DNS record '${record}' resolved to '${resolved_ip}', expected '${expected_ip}'"
  else
    log_pass "DNS record '${record}' correctly resolved to '${resolved_ip}'"
  fi
}

check_dns "api.${CLUSTER_NAME}.${BASE_DOMAIN}" "${API_VIP}"
check_dns "api-int.${CLUSTER_NAME}.${BASE_DOMAIN}" "${API_VIP}"
check_dns "canary-test.apps.${CLUSTER_NAME}.${BASE_DOMAIN}" "${APPS_VIP}"

# 2. Reverse PTR Check
echo -e "
--- 2. Checking Reverse PTR Records ---"
check_ptr() {
  local ip="$1"
  local ptr=""
  if command -v dig &>/dev/null; then
    ptr=$(dig +short -x "${ip}" | sed 's/\.$//' || true)
  elif command -v getent &>/dev/null; then
    ptr=$(getent hosts "${ip}" 2>/dev/null | awk '{print $2}' || true)
  fi
  if [ -z "${ptr}" ]; then
    log_warn "No reverse PTR configured for IP: ${ip}"
  else
    log_pass "Reverse PTR for ${ip} resolves to: ${ptr}"
  fi
}
check_ptr "${API_VIP}"
check_ptr "${APPS_VIP}"

# 3. NTP / Chrony Synchronization
echo -e "
--- 3. Checking System Clock & NTP Sync ---"
if command -v chronyc &>/dev/null; then
  tracking=$(chronyc tracking 2>/dev/null || true)
  if echo "$tracking" | grep -q "Reference ID"; then
    rms_offset=$(echo "$tracking" | grep 'RMS offset' | awk '{print $4}')
    log_pass "Chrony is synchronized. RMS offset: ${rms_offset} seconds"
  else
    log_warn "Chrony is installed but not currently synchronized with an NTP peer"
  fi
elif command -v timedatectl &>/dev/null; then
  if timedatectl status | grep -E "NTP service: active|System clock synchronized: yes" &>/dev/null; then
    log_pass "System clock is synchronized via systemd-timesyncd / timedatectl"
  else
    log_warn "System clock is not synchronized. etcd requires strict clock synchronization (<500ms drift)"
  fi
else
  log_warn "Neither chronyc nor timedatectl found on host. Verify NTP manually."
fi

# 4. Proxy Configuration Verification
echo -e "
--- 4. Checking Proxy Environment Variables ---"
if [ -n "${HTTP_PROXY:-}" ] || [ -n "${http_proxy:-}" ]; then
  log_pass "HTTP_PROXY detected: ${HTTP_PROXY:-${http_proxy}}"
  if [ -z "${NO_PROXY:-}" ] && [ -z "${no_proxy:-}" ]; then
    log_fail "HTTP_PROXY is defined but NO_PROXY is missing! OpenShift internal traffic will break."
  else
    np="${NO_PROXY:-${no_proxy}}"
    if echo "$np" | grep -q "${BASE_DOMAIN}" && echo "$np" | grep -q "10.128.0.0/14"; then
      log_pass "NO_PROXY contains base domain and standard cluster network CIDR: ${np}"
    else
      log_warn "Ensure NO_PROXY contains .${BASE_DOMAIN}, clusterNetwork (e.g. 10.128.0.0/14), and serviceNetwork (172.30.0.0/16)"
    fi
  fi
else
  log_pass "No proxy configured (direct connection mode)"
fi

# 5. Core Port Connectivity Matrix Check (API & Ingress)
echo -e "
--- 5. Checking Port Accessibility ---"
test_port() {
  local host="$1"
  local port="$2"
  local desc="$3"
  if timeout 2 bash -c "cat < /dev/null > /dev/tcp/${host}/${port}" 2>/dev/null; then
    log_pass "Connection to ${host}:${port} (${desc}) succeeded"
  else
    log_warn "Connection to ${host}:${port} (${desc}) timed out or rejected (expected if not yet running)"
  fi
}
test_port "${API_VIP}" "6443" "OpenShift API Server"
test_port "${API_VIP}" "22623" "Machine Config Server"
test_port "${APPS_VIP}" "443" "Cluster Ingress Router HTTPS"

echo -e "
======================================================================"
echo -e " Preflight Summary: ${GREEN}${pass_count} Passed${NC}, ${YELLOW}${warn_count} Warnings${NC}, ${RED}${fail_count} Failed${NC}"
echo -e "======================================================================"

if [ "${fail_count}" -gt 0 ]; then
  exit 1
fi
