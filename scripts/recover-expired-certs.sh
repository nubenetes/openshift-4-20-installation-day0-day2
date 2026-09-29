#!/usr/bin/env bash
# ==============================================================================
# OpenShift 4.20 Emergency Certificate Recovery Orchestrator
# Designed to run from the Helper Node when the API server is unreachable
# due to expired kubelet client/serving certificates after prolonged offline.
# ==============================================================================
set -euo pipefail

SSH_KEY="${SSH_KEY:-}"
if [ -z "$SSH_KEY" ]; then
  for candidate in ~/.ssh/id_rsa ~/.ssh/id_rsa_ocp /root/.ssh/id_rsa /home/core/.ssh/id_rsa; do
    if [ -f "$candidate" ]; then
      SSH_KEY="$candidate"
      break
    fi
  done
fi

MASTERS="${MASTERS:-master-0 master-1 master-2}"
WORKERS="${WORKERS:-}"

log_info() { echo -e "\033[0;34m[INFO]\033[0m $*"; }
log_warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
log_error() { echo -e "\033[0;31m[ERROR]\033[0m $*"; }
log_success() { echo -e "\033[0;32m[PASS]\033[0m $*"; }

if [ -z "$SSH_KEY" ] || [ ! -f "$SSH_KEY" ]; then
  log_error "No valid SSH private key found. Set SSH_KEY=/path/to/key"
  exit 1
fi

SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 -i ${SSH_KEY}"

echo "======================================================================"
echo " OpenShift 4.20 Emergency Expired Certificate Recovery Tool"
echo " Orchestrating directly from Helper Node via SSH"
echo "======================================================================"
log_info "Using SSH Key: ${SSH_KEY}"
log_info "Target Control Plane Nodes: ${MASTERS}"

# Step 1: Clock Verification
log_info "[Step 1/5] Checking and synchronizing system clocks across control plane..."
for node in ${MASTERS}; do
  if ssh ${SSH_OPTS} core@"${node}" "sudo chronyc makestep" >/dev/null 2>&1; then
    log_success "Clock synchronized on ${node}"
  else
    log_warn "Could not step chrony on ${node}; checking basic SSH reachability..."
  fi
done

# Step 2: Seed Master Recovery (master-0)
SEED_MASTER=$(echo "${MASTERS}" | awk '{print $1}')
log_info "[Step 2/5] Purging expired kubelet credentials on seed master (${SEED_MASTER})..."

ssh ${SSH_OPTS} core@"${SEED_MASTER}" bash -s << 'EOF'
set -euo pipefail
echo "Stopping kubelet on seed master..."
sudo systemctl stop kubelet

echo "Removing expired dynamic kubelet client certificates..."
sudo rm -rf /var/lib/kubelet/pki/kubelet-client-current.pem
sudo rm -f /var/lib/kubelet/pki/kubelet-client-*.pem
sudo rm -f /var/lib/kubelet/kubeconfig

echo "Restoring bootstrap kubeconfig..."
if [ -f /etc/kubernetes/kubeconfig ]; then
  sudo cp /etc/kubernetes/kubeconfig /var/lib/kubelet/kubeconfig
elif [ -f /etc/kubernetes/bootstrap-secrets/kubeconfig ]; then
  sudo cp /etc/kubernetes/bootstrap-secrets/kubeconfig /var/lib/kubelet/kubeconfig
else
  echo "FATAL: No bootstrap kubeconfig found in /etc/kubernetes!"
  exit 1
fi
sudo chmod 0600 /var/lib/kubelet/kubeconfig

echo "Starting kubelet with restored bootstrap configuration..."
sudo systemctl start kubelet
EOF
log_success "Kubelet restarted with bootstrap configuration on ${SEED_MASTER}."

# Step 3: Approve Seed Master CSRs
log_info "[Step 3/5] Polling local kube-apiserver on ${SEED_MASTER} to approve pending CSRs..."
ssh ${SSH_OPTS} core@"${SEED_MASTER}" bash -s << 'EOF'
set -euo pipefail
# Locate internal administrative kubeconfig
ADMIN_KUBECONFIG=""
for cfg in   /etc/kubernetes/static-pod-resources/kube-apiserver-certs/secrets/node-kubeconfigs/lb-ext.kubeconfig   /etc/kubernetes/static-pod-resources/kube-apiserver-certs/secrets/node-kubeconfigs/localhost.kubeconfig   /etc/kubernetes/kubeconfig; do
  if [ -f "$cfg" ]; then
    ADMIN_KUBECONFIG="$cfg"
    break
  fi
done

if [ -z "$ADMIN_KUBECONFIG" ]; then
  echo "FATAL: Could not locate admin kubeconfig on seed master!"
  exit 1
fi

export KUBECONFIG="$ADMIN_KUBECONFIG"
echo "Using admin kubeconfig: ${ADMIN_KUBECONFIG}"

# Loop to approve CSRs as kubelet requests them
for i in {1..12}; do
  PENDING_CSRS=$(oc get csr -ojsonpath='{range .items[?(@.status.conditions==[])]}{.metadata.name}{"
"}{end}' 2>/dev/null || true)
  if [ -n "$PENDING_CSRS" ]; then
    for csr in $PENDING_CSRS; do
      echo "Approving CSR: ${csr}"
      oc adm certificate approve "${csr}" 2>/dev/null || true
    done
  fi
  sleep 5
done
EOF
log_success "Seed master CSR approval phase complete."

# Step 4: Cascade to Remaining Control Plane Nodes
log_info "[Step 4/5] Cascading credential renewal to remaining control plane nodes..."
OTHER_MASTERS=$(echo "${MASTERS}" | sed "s/${SEED_MASTER}//")

for node in ${OTHER_MASTERS}; do
  log_info "Renewing kubelet credentials on ${node}..."
  ssh ${SSH_OPTS} core@"${node}" bash -s << 'EOF'
set -euo pipefail
sudo systemctl stop kubelet
sudo rm -rf /var/lib/kubelet/pki/kubelet-client-current.pem
sudo rm -f /var/lib/kubelet/pki/kubelet-client-*.pem
sudo rm -f /var/lib/kubelet/kubeconfig
if [ -f /etc/kubernetes/kubeconfig ]; then
  sudo cp /etc/kubernetes/kubeconfig /var/lib/kubelet/kubeconfig
elif [ -f /etc/kubernetes/bootstrap-secrets/kubeconfig ]; then
  sudo cp /etc/kubernetes/bootstrap-secrets/kubeconfig /var/lib/kubelet/kubeconfig
fi
sudo chmod 0600 /var/lib/kubelet/kubeconfig
sudo systemctl start kubelet
EOF
done

# Approve peer CSRs from seed master
log_info "Approving peer control plane CSRs from ${SEED_MASTER}..."
ssh ${SSH_OPTS} core@"${SEED_MASTER}" bash -s << 'EOF'
export KUBECONFIG=/etc/kubernetes/static-pod-resources/kube-apiserver-certs/secrets/node-kubeconfigs/lb-ext.kubeconfig
for i in {1..15}; do
  oc get csr -ojsonpath='{range .items[?(@.status.conditions==[])]}{.metadata.name}{"
"}{end}' 2>/dev/null | xargs -r oc adm certificate approve 2>/dev/null || true
  sleep 4
done
EOF

# Step 5: Workers if specified
if [ -n "$WORKERS" ]; then
  log_info "[Step 5/5] Cascading credential renewal to data plane workers: ${WORKERS}..."
  for wnode in ${WORKERS}; do
    log_info "Renewing kubelet on worker ${wnode}..."
    ssh ${SSH_OPTS} core@"${wnode}" bash -s << 'EOF'
set -euo pipefail
sudo systemctl stop kubelet
sudo rm -rf /var/lib/kubelet/pki/kubelet-client-current.pem
sudo rm -f /var/lib/kubelet/pki/kubelet-client-*.pem
sudo rm -f /var/lib/kubelet/kubeconfig
if [ -f /etc/kubernetes/kubeconfig ]; then
  sudo cp /etc/kubernetes/kubeconfig /var/lib/kubelet/kubeconfig
fi
sudo chmod 0600 /var/lib/kubelet/kubeconfig
sudo systemctl start kubelet
EOF
  done

  # Final CSR sweep
  ssh ${SSH_OPTS} core@"${SEED_MASTER}" bash -s << 'EOF'
export KUBECONFIG=/etc/kubernetes/static-pod-resources/kube-apiserver-certs/secrets/node-kubeconfigs/lb-ext.kubeconfig
sleep 10
oc get csr -ojsonpath='{range .items[?(@.status.conditions==[])]}{.metadata.name}{"
"}{end}' 2>/dev/null | xargs -r oc adm certificate approve 2>/dev/null || true
EOF
else
  log_info "[Step 5/5] No workers specified for renewal. Control plane nodes recovered."
fi

echo "======================================================================"
log_success "Expired Certificate Recovery Completed!"
echo "Verify cluster status from Helper Node with:"
echo "  ssh core@${SEED_MASTER} 'oc get nodes && oc get co'"
echo "======================================================================"
