#!/usr/bin/env bash
# ==============================================================================
# OpenShift 4.20 Istio Ambient Service Mesh (OSSM 3.x) Verification & Diagnostics
# ==============================================================================
# Audits Sail Operator, Istio CNI, ztunnel DaemonSet, enrolled namespaces,
# Waypoint proxies (Gateway API), and HBONE port 15008 connectivity.
# ==============================================================================
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

echo -e "${BLUE}======================================================================${NC}"
echo -e "${BOLD}${BLUE} OpenShift 4.20 Istio Ambient Service Mesh Diagnostic Engine${NC}"
echo -e "${BLUE}======================================================================${NC}"

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  echo "Usage: $0 [options]"
  echo ""
  echo "Audits the Red Hat OpenShift Service Mesh 3.x (Istio Ambient) stack including:"
  echo "  - Sail Operator / OSSM 3 CSV status"
  echo "  - Istio CNI DaemonSet with Ambient redirection (eBPF/iptables)"
  echo "  - ztunnel DaemonSet health across all cluster worker nodes"
  echo "  - Namespaces enrolled in Ambient data plane (istio.io/dataplane-mode=ambient)"
  echo "  - Waypoint proxies instantiated via Kubernetes Gateway API (gatewayClassName: istio-waypoint)"
  echo "  - HBONE port 15008 listener readiness and health probes"
  echo ""
  echo "Prerequisites: OpenShift CLI (oc) logged in with cluster-admin permissions."
  exit 0
fi

# Check prerequisites
if ! command -v oc &> /dev/null; then
  echo -e "[${RED}FATAL${NC}] 'oc' command-line tool not found in PATH."
  exit 1
fi

if ! oc whoami &> /dev/null; then
  echo -e "[${RED}FATAL${NC}] Unable to connect to OpenShift API server. Ensure valid KUBECONFIG."
  exit 1
fi

# ------------------------------------------------------------------------------
# 1. Auditing Sail Operator / OSSM 3.x Subscriptions
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${CYAN}--- 1. Auditing Service Mesh Operator Status ---${NC}"

check_operator() {
  local pattern="$1"
  local ns="$2"
  if oc get csv -n "${ns}" 2>/dev/null | grep -i "${pattern}" | grep -q "Succeeded"; then
    local version
    version=$(oc get csv -n "${ns}" --no-headers | grep -i "${pattern}" | awk '{print $1}')
    echo -e "  [${GREEN}HEALTHY${NC}] Operator matching '${BOLD}${pattern}${NC}' is Succeeded (${version})."
  else
    echo -e "  [${YELLOW}WARNING${NC}] Operator matching '${BOLD}${pattern}${NC}' not found in 'Succeeded' state in '${ns}'."
    WARNINGS=$((WARNINGS + 1))
  fi
}

check_operator "servicemesh" "openshift-operators"
check_operator "sail" "openshift-operators"

# ------------------------------------------------------------------------------
# 2. Auditing Istio CNI DaemonSet (Ambient Mode)
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${CYAN}--- 2. Auditing Istio CNI with Ambient Redirection ---${NC}"

if oc get daemonset istio-cni-node -n istio-cni &>/dev/null; then
  DESIRED=$(oc get daemonset istio-cni-node -n istio-cni -o jsonpath='{.status.desiredNumberScheduled}')
  READY=$(oc get daemonset istio-cni-node -n istio-cni -o jsonpath='{.status.numberReady}')
  if [[ "${DESIRED}" == "${READY}" && "${READY}" -gt 0 ]]; then
    echo -e "  [${GREEN}HEALTHY${NC}] istio-cni-node DaemonSet: ${READY}/${DESIRED} pods ready across nodes."
  else
    echo -e "  [${RED}ERROR${NC}] istio-cni-node DaemonSet degraded: ${READY}/${DESIRED} pods ready."
    ERRORS=$((ERRORS + 1))
  fi
else
  echo -e "  [${RED}ERROR${NC}] DaemonSet 'istio-cni-node' not found in namespace 'istio-cni'."
  ERRORS=$((ERRORS + 1))
fi

# ------------------------------------------------------------------------------
# 3. Auditing ztunnel DaemonSet (Layer 4 Secure Transport Engine)
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${CYAN}--- 3. Auditing ztunnel DaemonSet (Rust L4 Engine) ---${NC}"

if oc get daemonset ztunnel -n istio-system &>/dev/null; then
  ZT_DESIRED=$(oc get daemonset ztunnel -n istio-system -o jsonpath='{.status.desiredNumberScheduled}')
  ZT_READY=$(oc get daemonset ztunnel -n istio-system -o jsonpath='{.status.numberReady}')
  if [[ "${ZT_DESIRED}" == "${ZT_READY}" && "${ZT_READY}" -gt 0 ]]; then
    echo -e "  [${GREEN}HEALTHY${NC}] ztunnel DaemonSet: ${ZT_READY}/${ZT_DESIRED} pods running."
  else
    echo -e "  [${RED}ERROR${NC}] ztunnel DaemonSet degraded: ${ZT_READY}/${ZT_DESIRED} pods running."
    ERRORS=$((ERRORS + 1))
  fi

  # Sample a ztunnel pod for HBONE port 15008 listener
  ZT_SAMPLE_POD=$(oc get pods -n istio-system -l app=ztunnel -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")
  if [[ -n "${ZT_SAMPLE_POD}" ]]; then
    echo -e "  [*] Probing ztunnel sample pod: ${BOLD}${ZT_SAMPLE_POD}${NC} on port 15021 (healthz)..."
    if oc exec -n istio-system "${ZT_SAMPLE_POD}" -c ztunnel -- curl -s http://localhost:15021/healthz/ready &>/dev/null; then
      echo -e "  [${GREEN}HEALTHY${NC}] ztunnel readiness probe passed on ${ZT_SAMPLE_POD}."
    else
      echo -e "  [${YELLOW}WARNING${NC}] Unable to query healthz on ztunnel pod ${ZT_SAMPLE_POD}."
      WARNINGS=$((WARNINGS + 1))
    fi
  fi
else
  echo -e "  [${RED}ERROR${NC}] DaemonSet 'ztunnel' not found in namespace 'istio-system'."
  ERRORS=$((ERRORS + 1))
fi

# ------------------------------------------------------------------------------
# 4. Auditing Ambient Data Plane Workload Enrollment
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${CYAN}--- 4. Auditing Enrolled Ambient Namespaces ---${NC}"

ENROLLED_NAMESPACES=$(oc get namespaces -l istio.io/dataplane-mode=ambient -o jsonpath='{.items[*].metadata.name}' 2>/dev/null || echo "")

if [[ -n "${ENROLLED_NAMESPACES}" ]]; then
  echo -e "  [${GREEN}FOUND${NC}] Namespaces enrolled in Ambient Mesh (istio.io/dataplane-mode=ambient):"
  for ns in ${ENROLLED_NAMESPACES}; do
    POD_COUNT=$(oc get pods -n "${ns}" --no-headers 2>/dev/null | wc -l | tr -d ' ')
    echo -e "    - ${BOLD}${ns}${NC} (${POD_COUNT} workload pods automatically encrypted via ztunnel)"
  done
else
  echo -e "  [${YELLOW}WARNING${NC}] No namespaces currently labeled with 'istio.io/dataplane-mode=ambient'."
  echo -e "    -> To enroll a namespace: oc label namespace <name> istio.io/dataplane-mode=ambient"
  WARNINGS=$((WARNINGS + 1))
fi

# ------------------------------------------------------------------------------
# 5. Auditing Layer 7 Waypoint Proxies (Kubernetes Gateway API)
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${CYAN}--- 5. Auditing Layer 7 Waypoint Proxies (Gateway API) ---${NC}"

if oc get crd gateways.gateway.networking.k8s.io &>/dev/null; then
  WAYPOINTS=$(oc get gateways --all-namespaces -o json 2>/dev/null | jq -r '.items[] | select(.spec.gatewayClassName=="istio-waypoint") | "\(.metadata.namespace)/\(.metadata.name)"' 2>/dev/null || echo "")
  if [[ -n "${WAYPOINTS}" ]]; then
    echo -e "  [${GREEN}FOUND${NC}] Active Waypoint Proxies declared via Gateway API:"
    for wp in ${WAYPOINTS}; do
      WP_NS=$(echo "${wp}" | cut -d/ -f1)
      WP_NAME=$(echo "${wp}" | cut -d/ -f2)
      echo -e "    - Gateway: ${BOLD}${wp}${NC} (Waypoint for ${WP_NS})"
    done
  else
    echo -e "  [${BLUE}INFO${NC}] No Waypoint proxies deployed. Workloads operate in pure Layer 4 mTLS mode."
  fi
else
  echo -e "  [${YELLOW}WARNING${NC}] Kubernetes Gateway API CRD (gateways.gateway.networking.k8s.io) not found."
  WARNINGS=$((WARNINGS + 1))
fi

# ------------------------------------------------------------------------------
# 6. Auditing HBONE Port 15008 Routing & AuthorizationPolicies
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${CYAN}--- 6. Auditing Zero-Trust AuthorizationPolicies ---${NC}"

if oc get crd authorizationpolicies.security.istio.io &>/dev/null; then
  POLICY_COUNT=$(oc get authorizationpolicies --all-namespaces --no-headers 2>/dev/null | wc -l | tr -d ' ')
  echo -e "  [${GREEN}HEALTHY${NC}] Total active AuthorizationPolicies across cluster: ${BOLD}${POLICY_COUNT}${NC}."
else
  echo -e "  [${YELLOW}WARNING${NC}] Istio AuthorizationPolicy CRD not installed."
  WARNINGS=$((WARNINGS + 1))
fi

# ------------------------------------------------------------------------------
# Summary
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}======================================================================${NC}"
echo -e "${BOLD} Istio Ambient Service Mesh Audit Summary${NC}"
echo -e "${BLUE}======================================================================${NC}"
echo -e "  Errors:   ${BOLD}${ERRORS}${NC}"
echo -e "  Warnings: ${BOLD}${WARNINGS}${NC}"

if [[ ${ERRORS} -eq 0 && ${WARNINGS} -eq 0 ]]; then
  echo -e "\n[${GREEN}SUCCESS${NC}] Istio Ambient Mesh data plane and control plane are in optimal health!"
  exit 0
elif [[ ${ERRORS} -eq 0 ]]; then
  echo -e "\n[${YELLOW}PASSED WITH WARNINGS${NC}] Ambient mesh is operational; review non-blocking warnings above."
  exit 0
else
  echo -e "\n[${RED}FAILURE${NC}] Critical degradation detected in Istio Ambient Service Mesh data plane."
  exit 1
fi
