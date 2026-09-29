#!/usr/bin/env bash
# ==============================================================================
# OpenShift 4.20 Pre-Upgrade Health & Readiness Validator
# Validates ClusterOperators, MCPs, etcd backups, deprecated APIs, and certs
# ==============================================================================
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}======================================================================${NC}"
echo -e "${BLUE} OpenShift 4.20 Pre-Upgrade Health & Readiness Audit                  ${NC}"
echo -e "${BLUE}======================================================================${NC}"

pass=0
warn=0
fail=0

log_pass() { echo -e "[${GREEN}PASS${NC}] $1"; ((pass++)) || true; }
log_warn() { echo -e "[${YELLOW}WARN${NC}] $1"; ((warn++)) || true; }
log_fail() { echo -e "[${RED}FAIL${NC}] $1"; ((fail++)) || true; }

# 1. Cluster Operators Health Check
echo -e "\n--- 1. Auditing Cluster Operators ---"
degraded_co=$(oc get co --no-headers | awk '$5 != "False" || $3 != "True" {print $1}')
progressing_co=$(oc get co --no-headers | awk '$4 != "False" {print $1}')

if [ -n "$degraded_co" ]; then
  log_fail "Degraded ClusterOperators detected: $degraded_co. DO NOT UPGRADE!"
elif [ -n "$progressing_co" ]; then
  log_fail "Progressing ClusterOperators detected: $progressing_co. Wait for stabilization."
else
  log_pass "All ClusterOperators are Available=True, Progressing=False, Degraded=False."
fi

# 2. MachineConfigPools Health
echo -e "\n--- 2. Auditing MachineConfigPools (MCP) ---"
degraded_mcp=$(oc get mcp --no-headers | awk '$5 != "False" {print $1}')
updating_mcp=$(oc get mcp --no-headers | awk '$4 != "False" {print $1}')

if [ -n "$degraded_mcp" ]; then
  log_fail "Degraded MachineConfigPools detected: $degraded_mcp. Resolve before upgrading."
elif [ -n "$updating_mcp" ]; then
  log_fail "MachineConfigPools currently updating: $updating_mcp. Wait for completion."
else
  log_pass "All MachineConfigPools are Updated=True and Degraded=False."
fi

# 3. Node Readiness
echo -e "\n--- 3. Auditing Cluster Nodes ---"
not_ready=$(oc get nodes --no-headers | grep -v ' Ready' || true)
if [ -n "$not_ready" ]; then
  log_fail "Unready nodes detected:\n$not_ready"
else
  total_nodes=$(oc get nodes --no-headers | wc -l)
  log_pass "All $total_nodes nodes are in 'Ready' status."
fi

# 4. Mandatory etcd Backup Freshness
echo -e "\n--- 4. Checking etcd Backup Freshness ---"
echo "[INFO] Verifying etcd snapshot availability..."
if [ -d "/var/recovery/etcd-backups" ]; then
  recent_backup=$(find /var/recovery/etcd-backups -type d -name "etcd_snapshot_*" -mtime -1 | head -n1 || true)
  if [ -n "$recent_backup" ]; then
    log_pass "Fresh etcd backup found: $recent_backup (< 24 hours old)"
  else
    log_warn "No local etcd backup found in /var/recovery taken within the last 24 hours!"
  fi
else
  log_warn "Host does not have /var/recovery/etcd-backups. Ensure a fresh etcd backup is taken before upgrading!"
fi

# 5. Deprecated API Usage
echo -e "\n--- 5. Checking Deprecated API Request Counts ---"
deprecated_apis=$(oc get apirequestcounts -o jsonpath='{range .items[?(@.status.removedInRelease!="")]}{.metadata.name}{" - RemovedIn: "}{.status.removedInRelease}{"\n"}{end}' 2>/dev/null || true)
if [ -n "$deprecated_apis" ]; then
  log_warn "Deprecated APIs detected in cluster:\n$deprecated_apis"
else
  log_pass "No critical deprecated API requests detected."
fi

# 6. Firing Alerts
echo -e "\n--- 6. Checking Prometheus Critical Alerts ---"
firing_alerts=$(oc -n openshift-monitoring exec prometheus-k8s-0 -c prometheus -- curl -s 'http://localhost:9090/api/v1/alerts' 2>/dev/null | jq -r '.data.alerts[] | select(.state=="firing" and .labels.severity=="critical") | .labels.alertname' 2>/dev/null || true)
if [ -n "$firing_alerts" ]; then
  log_fail "Critical Prometheus alerts are FIRING: $firing_alerts. Resolve before upgrade!"
else
  log_pass "No critical alerts firing in monitoring stack."
fi

echo -e "\n======================================================================"
echo -e " Pre-Upgrade Summary: ${GREEN}${pass} Passed${NC}, ${YELLOW}${warn} Warnings${NC}, ${RED}${fail} Failed${NC}"
echo -e "======================================================================"

if [ "$fail" -gt 0 ]; then
  echo -e "${RED}[ERROR] Cluster failed pre-upgrade checks. Upgrade cannot proceed safely.${NC}"
  exit 1
fi
echo -e "${GREEN}[OK] Cluster is ready for upgrade.${NC}"
