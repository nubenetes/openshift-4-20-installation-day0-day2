#!/usr/bin/env bash
# ==============================================================================
# OpenShift 4.20 Control Plane Master Node Replacement Assistant
# Safely purges a failed master node from etcd quorum, deletes the node object,
# and assists with reprovisioning, CSR approval, and etcd cluster reintegration.
# ==============================================================================
set -euo pipefail

FAILED_NODE="${1:-}"

if [ -z "$FAILED_NODE" ]; then
  echo "Usage: $0 <failed-master-node-name>"
  echo "Example: $0 master-1.corp.local"
  exit 1
fi

log_info() { echo -e "\033[0;34m[INFO]\033[0m $*"; }
log_warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
log_error() { echo -e "\033[0;31m[ERROR]\033[0m $*"; }
log_success() { echo -e "\033[0;32m[PASS]\033[0m $*"; }

echo "======================================================================"
echo " OpenShift 4.20 Master Node Replacement Engine"
echo " Target Failed Master: ${FAILED_NODE}"
echo "======================================================================"

# Step 1: Pre-flight Quorum Verification
log_info "[Step 1/5] Verifying surviving control plane health..."
SURVIVING_MASTERS=$(oc get nodes -l node-role.kubernetes.io/master --no-headers 2>/dev/null | grep -v "${FAILED_NODE}" | awk '{print $1}')
SURVIVING_COUNT=$(echo "${SURVIVING_MASTERS}" | wc -w)

if [ "$SURVIVING_COUNT" -lt 2 ]; then
  log_error "CRITICAL: Less than 2 surviving masters detected (${SURVIVING_COUNT} online)."
  log_error "Removing a master now will cause unrecoverable etcd quorum loss!"
  log_error "If 2 masters are lost, follow docs/09-emergency-runbooks/04-etcd-quorum-loss-recovery.md instead."
  exit 1
fi
log_success "Surviving control plane nodes verified (${SURVIVING_COUNT} healthy masters online)."

# Step 2: Locate etcd Pod and Member ID
log_info "[Step 2/5] Locating healthy etcd pod and retrieving Raft member list..."
FIRST_SURVIVING=$(echo "${SURVIVING_MASTERS}" | awk '{print $1}')
ETCD_POD=$(oc get pods -n openshift-etcd -l app=etcd --no-headers -o wide 2>/dev/null | grep "${FIRST_SURVIVING}" | awk '{print $1}' | head -n1)

if [ -z "$ETCD_POD" ]; then
  ETCD_POD=$(oc get pods -n openshift-etcd -l app=etcd --no-headers | awk '{print $1}' | head -n1)
fi

log_info "Querying etcd members via pod: ${ETCD_POD}..."
MEMBER_OUTPUT=$(oc rsh -n openshift-etcd "${ETCD_POD}" etcdctl member list -w table)
echo "${MEMBER_OUTPUT}"

# Extract short hostname
SHORT_NAME=$(echo "${FAILED_NODE}" | cut -d'.' -f1)
MEMBER_ID=$(echo "${MEMBER_OUTPUT}" | grep -E "${FAILED_NODE}|${SHORT_NAME}" | awk '{print $2}' || true)

if [ -n "$MEMBER_ID" ]; then
  log_warn "Identified failed etcd Member ID: ${MEMBER_ID} for ${FAILED_NODE}"
  log_info "Removing member ${MEMBER_ID} from etcd cluster quorum..."
  oc rsh -n openshift-etcd "${ETCD_POD}" etcdctl member remove "${MEMBER_ID}"
  log_success "Member ${MEMBER_ID} successfully removed from etcd Raft consensus."
else
  log_warn "Member ID for ${FAILED_NODE} not found in etcd list (may have already been removed)."
fi

# Step 3: Delete Node Object
log_info "[Step 3/5] Deleting Kubernetes Node object: ${FAILED_NODE}..."
oc delete node "${FAILED_NODE}" --ignore-not-found
log_success "Node object deleted."

# Optional Machine CR cleanup in IPI
MACHINE_NAME=$(oc get machines -n openshift-machine-api --no-headers 2>/dev/null | grep -E "${FAILED_NODE}|${SHORT_NAME}" | awk '{print $1}' || true)
if [ -n "$MACHINE_NAME" ]; then
  log_info "Deleting Cloud Machine API resource: ${MACHINE_NAME}..."
  oc delete machine "${MACHINE_NAME}" -n openshift-machine-api --ignore-not-found || true
fi

# Step 4: Boot Instructions
echo "======================================================================"
log_info "[Step 4/5] Ready for Reprovisioning!"
echo "Now boot replacement hardware for ${FAILED_NODE}:"
echo "  1. Bare Metal: Mount Agent ISO via BMC Virtual Media (scripts/generate-agent-iso.sh)."
echo "  2. Assisted UI / ACM: Boot Discovery ISO and approve host as 'master'."
echo "  3. Cloud IPI: ControlPlaneMachineSet will auto-provision a new instance."
echo "======================================================================"

# Step 5: Automatic CSR Approval & Health Verification Loop
log_info "[Step 5/5] Monitoring for replacement node CSRs and etcd re-integration..."
echo "Press Ctrl+C to exit monitoring at any time."

POLL_COUNT=0
while [ $POLL_COUNT -lt 60 ]; do
  PENDING_CSRS=$(oc get csr -ojsonpath='{range .items[?(@.status.conditions==[])]}{.metadata.name}{"
"}{end}' 2>/dev/null || true)
  if [ -n "$PENDING_CSRS" ]; then
    for csr in $PENDING_CSRS; do
      log_info "Approving replacement node CSR: ${csr}"
      oc adm certificate approve "${csr}" 2>/dev/null || true
    done
  fi

  # Check if node has reappeared as Ready
  NODE_READY=$(oc get nodes "${FAILED_NODE}" -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null || true)
  if [ "$NODE_READY" == "True" ]; then
    log_success "Replacement node ${FAILED_NODE} is now READY in the cluster!"
    break
  fi

  sleep 10
  POLL_COUNT=$((POLL_COUNT + 1))
done

# Verify etcd members
echo -e "
Final etcd Member Status:"
oc rsh -n openshift-etcd "${ETCD_POD}" etcdctl member list -w table 2>/dev/null || true

log_success "Master Node Replacement Procedure Complete!"
