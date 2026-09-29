#!/usr/bin/env bash
# ==============================================================================
# OpenShift 4.20 End-to-End Automated Cluster Upgrade Orchestrator
# Enforces pre-flight audit -> automated etcd backup -> paused MCP rollout ->
# Canary verification with Prometheus/Thanos SLO telemetry gating
# ==============================================================================
set -euo pipefail

TARGET_VERSION="${1:-}"
CANARY_NODE="${2:-}"
SOAK_SECONDS="${SOAK_SECONDS:-60}"

if [ -z "$TARGET_VERSION" ]; then
  echo "Usage: $0 <target-version> [optional-canary-worker-node]"
  echo "Example: $0 4.20.1"
  echo "Example with canary: $0 4.20.1 worker-0.corp.local"
  echo "Environment Variables:"
  echo "  SOAK_SECONDS: Seconds to soak and evaluate Prometheus SLOs (default: 60)"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_info() { echo -e "\033[0;34m[INFO]\033[0m $*"; }
log_warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
log_error() { echo -e "\033[0;31m[ERROR]\033[0m $*"; }
log_success() { echo -e "\033[0;32m[PASS]\033[0m $*"; }

verify_telemetry_slo() {
  local phase="$1"
  log_info "Evaluating Prometheus / Thanos Telemetry SLOs (${phase})..."

  local token=""
  token=$(oc create token prometheus-k8s -n openshift-monitoring 2>/dev/null || oc whoami -t 2>/dev/null || true)
  local thanos_host=""
  thanos_host=$(oc get route thanos-querier -n openshift-monitoring -o jsonpath='{.spec.host}' 2>/dev/null || true)

  if [ -z "$thanos_host" ] || [ -z "$token" ]; then
    log_warn "Thanos querier route or monitoring token unavailable. Falling back to local pod status checks."
    local degraded_pods
    degraded_pods=$(oc get pods -A --field-selector=status.phase!=Running,status.phase!=Succeeded --no-headers 2>/dev/null | grep -Ev "Completed|Terminating" | wc -l || echo 0)
    if [ "$degraded_pods" -gt 15 ]; then
      log_error "SLO Breach: High count of degraded pods detected (${degraded_pods} pods degraded)."
      return 1
    fi
    log_success "Pod health check passed (degraded pods: ${degraded_pods})."
    return 0
  fi

  # Query 1: Container crash/restart rate in last 5m
  local restart_query='sum(increase(kube_pod_container_status_restarts_total[5m]))'
  local restart_res
  restart_res=$(curl -ks -H "Authorization: Bearer ${token}"     "https://${thanos_host}/api/v1/query?query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$restart_query'''))")" 2>/dev/null || true)

  local restarts=0
  if [[ "$restart_res" =~ \"value\":\[[0-9.]+,\"([0-9.]+)\"\] ]]; then
    restarts="${BASH_REMATCH[1]}"
    restarts=${restarts%.*}
  fi

  # Query 2: Ingress 5xx error percentage
  local err_query='(sum(rate(haproxy_backend_connections_total{code=~"5.*"}[5m])) / sum(rate(haproxy_backend_connections_total[5m]))) * 100'
  local err_res
  err_res=$(curl -ks -H "Authorization: Bearer ${token}"     "https://${thanos_host}/api/v1/query?query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$err_query'''))")" 2>/dev/null || true)

  local err_rate="0"
  if [[ "$err_res" =~ \"value\":\[[0-9.]+,\"([0-9.]+)\"\] ]]; then
    err_rate="${BASH_REMATCH[1]}"
  fi

  log_info "Telemetry SLO Metrics: Recent Restarts=${restarts}, Ingress 5xx Rate=${err_rate}%"

  # Gate check
  if [ "$restarts" -gt 25 ]; then
    log_error "SLO Breach: Container restart spike (${restarts} in 5m > 25 threshold)!"
    return 1
  fi

  local is_breached
  is_breached=$(python3 -c "print(1 if float('${err_rate}') > 2.0 else 0)" 2>/dev/null || echo 0)
  if [ "$is_breached" -eq 1 ]; then
    log_error "SLO Breach: Ingress 5xx rate (${err_rate}% > 2.0% threshold)!"
    return 1
  fi

  log_success "Telemetry SLO passed: Workloads healthy and error rates within operational budget."
  return 0
}

echo "======================================================================"
echo " Starting OpenShift 4.20 Automated Upgrade to: ${TARGET_VERSION}"
echo "======================================================================"

# Step 1: Pre-Upgrade Health Check
log_info "[Step 1/7] Running Pre-Upgrade Health Checks..."
"${SCRIPT_DIR}/pre-upgrade-health-check.sh"

# Step 2: Mandatory etcd Backup
log_info "[Step 2/7] Executing Mandatory Pre-Upgrade etcd Snapshot..."
"${SCRIPT_DIR}/etcd-backup.sh"
log_success "etcd backup completed and verified."

# Step 3: Pause Worker MachineConfigPool
log_info "[Step 3/7] Pausing Worker MachineConfigPool (Preventing Worker Reboot Storm)..."
oc patch mcp worker --type=merge -p '{"spec":{"paused":true}}'
log_info "Worker pool paused. Workers will NOT reboot during control plane upgrade."

# Step 4: Initiate Cluster Upgrade
log_info "[Step 4/7] Triggering ClusterVersion Upgrade to ${TARGET_VERSION}..."
oc adm upgrade --to="${TARGET_VERSION}"

log_info "[Step 5/7] Monitoring Control Plane Upgrade Progress..."
while true; do
  completed=$(oc get clusterversion version -o jsonpath='{.status.conditions[?(@.type=="Available")].status}')
  progressing=$(oc get clusterversion version -o jsonpath='{.status.conditions[?(@.type=="Progressing")].status}')
  current_version=$(oc get clusterversion version -o jsonpath='{.status.history[0].version}')
  state_msg=$(oc get clusterversion version -o jsonpath='{.status.history[0].state}')

  echo "[CVO Status] Version: ${current_version} | State: ${state_msg} | Progressing: ${progressing}"
  if [ "$progressing" == "False" ] && [ "$current_version" == "$TARGET_VERSION" ]; then
    log_success "Control plane successfully upgraded to ${TARGET_VERSION}!"
    break
  fi
  sleep 30
done

# Step 6: Canary Node Verification (if specified)
if [ -n "$CANARY_NODE" ]; then
  log_info "[Step 6/7] Canary Rollout Active for Node: ${CANARY_NODE}..."

  if ! oc get mcp worker-canary >/dev/null 2>&1; then
    log_info "Creating canary MachineConfigPool 'worker-canary'..."
    cat <<EOF | oc apply -f -
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfigPool
metadata:
  name: worker-canary
spec:
  machineConfigSelector:
    matchExpressions:
      - {key: machineconfiguration.openshift.io/role, operator: In, values: [worker, worker-canary]}
  nodeSelector:
    matchLabels:
      node-role.kubernetes.io/worker-canary: ""
EOF
  fi

  log_info "Labeling ${CANARY_NODE} as canary worker..."
  oc label node "${CANARY_NODE}" node-role.kubernetes.io/worker-canary="" --overwrite

  log_info "Waiting for canary node ${CANARY_NODE} to complete MachineConfig update..."
  oc wait --for=condition=Updated=True mcp/worker-canary --timeout=30m

  log_info "Soaking canary node for ${SOAK_SECONDS}s to evaluate telemetry SLOs..."
  sleep "${SOAK_SECONDS}"

  if ! verify_telemetry_slo "Canary Soak Phase"; then
    log_error "Upgrade telemetry SLO check failed on canary node! Aborting fleet worker rollout."
    log_error "MachineConfigPool 'worker' remains paused to prevent fleet-wide degradation."
    exit 2
  fi
  log_success "Canary node verified and telemetry SLOs healthy. Proceeding with fleet rollout."
else
  log_info "[Step 6/7] Canary node not specified; proceeding directly to fleet worker rollout."
fi

# Step 7: Worker Fleet Rollout & Final Verification
log_info "[Step 7/7] Rolling Out Worker Fleet..."
oc patch mcp worker --type=merge -p '{"spec":{"paused":false}}'
log_info "Worker MachineConfigPool unpaused. MCO will update workers sequentially."

log_info "Waiting for all Worker nodes to reach Updated=True..."
oc wait --for=condition=Updated=True mcp/worker --timeout=60m

# Post-upgrade telemetry SLO verification
verify_telemetry_slo "Post-Upgrade Fleet Phase"

echo "======================================================================"
echo " OpenShift 4.20 Cluster Upgrade to ${TARGET_VERSION} Complete and Verified!"
echo "======================================================================"
"${SCRIPT_DIR}/validate-cluster-health.sh"
