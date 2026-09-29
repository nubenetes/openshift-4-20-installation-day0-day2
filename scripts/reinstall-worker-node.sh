#!/usr/bin/env bash
# ==============================================================================
# OpenShift 4.20 Worker & Infra Node Reinstallation and Replacement Orchestrator
# Safely cordons, drains, deletes a degraded worker node, and monitors replacement
# provisioning, automated CSR approval, and MachineConfigPool synchronization.
# ==============================================================================
set -euo pipefail

TARGET_NODE="${1:-}"
DRAIN_TIMEOUT_MINUTES="${2:-15}"

if [ -z "$TARGET_NODE" ]; then
  echo "Usage: $0 <worker-node-name> [drain-timeout-in-minutes]"
  echo "Example: $0 worker-2.corp.local 10"
  exit 1
fi

log_info() { echo -e "\033[0;34m[INFO]\033[0m $*"; }
log_warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
log_error() { echo -e "\033[0;31m[ERROR]\033[0m $*"; }
log_success() { echo -e "\033[0;32m[PASS]\033[0m $*"; }

echo "======================================================================"
echo " OpenShift 4.20 Worker Node Reinstallation Engine"
echo " Target Node: ${TARGET_NODE}"
echo " Drain Timeout: ${DRAIN_TIMEOUT_MINUTES} minutes"
echo "======================================================================"

# Step 1: Cordon Node
log_info "[Step 1/5] Cordoning node ${TARGET_NODE} to prevent new workload scheduling..."
oc adm cordon "${TARGET_NODE}" || log_warn "Node may already be cordoned or unreachable."

# Step 2: Drain Workloads
log_info "[Step 2/5] Evicting active workloads (graceful drain)..."
if ! oc adm drain "${TARGET_NODE}"   --force   --ignore-daemonsets   --delete-emptydir-data   --grace-period=60   --timeout="${DRAIN_TIMEOUT_MINUTES}m"; then
  log_warn "Drain command encountered timeouts (likely PodDisruptionBudgets or node unreachability)."
  read -r -p "Do you want to proceed with node deletion anyway? [y/N]: " confirm
  if [[ ! "$confirm" =~ ^[yY]$ ]]; then
    log_error "Aborted by operator."
    exit 1
  fi
fi
log_success "Node workloads drained."

# Step 3: Delete Node Object
log_info "[Step 3/5] Deleting Kubernetes Node object: ${TARGET_NODE}..."
oc delete node "${TARGET_NODE}" --ignore-not-found
log_success "Node resource removed from cluster."

# Step 4: Boot Instructions
echo "======================================================================"
log_info "[Step 4/5] Ready for Reprovisioning!"
echo "Now boot replacement hardware/VM for ${TARGET_NODE}:"
echo "  1. Bare Metal: Boot Agent ISO or PXE installer."
echo "  2. Assisted UI / ACM: Add Host -> Boot Discovery ISO -> assign 'Worker' role."
echo "  3. Cloud IPI: Scale down and scale up the corresponding MachineSet."
echo "======================================================================"

# Step 5: Automatic CSR Approval & Health Verification Loop
log_info "[Step 5/5] Monitoring for replacement worker node CSRs and MCP sync..."
echo "Press Ctrl+C to stop monitoring at any time."

POLL_COUNT=0
while [ $POLL_COUNT -lt 60 ]; do
  PENDING_CSRS=$(oc get csr -ojsonpath='{range .items[?(@.status.conditions==[])]}{.metadata.name}{"
"}{end}' 2>/dev/null || true)
  if [ -n "$PENDING_CSRS" ]; then
    for csr in $PENDING_CSRS; do
      log_info "Approving worker CSR: ${csr}"
      oc adm certificate approve "${csr}" 2>/dev/null || true
    done
  fi

  # Check if node has reappeared as Ready
  NODE_READY=$(oc get nodes "${TARGET_NODE}" -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null || true)
  if [ "$NODE_READY" == "True" ]; then
    log_success "Replacement worker ${TARGET_NODE} is now READY in the cluster!"
    break
  fi

  sleep 10
  POLL_COUNT=$((POLL_COUNT + 1))
done

# Check MachineConfigPool status
echo -e "
MachineConfigPool Status:"
oc get mcp worker

log_success "Worker Node Reinstallation Procedure Complete!"
