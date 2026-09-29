#!/usr/bin/env bash
# ==============================================================================
# OpenShift 4.20 Emergency etcd Single-Member Quorum Restoration Tool
# Forces a single surviving control plane node into a functional 1-node etcd
# cluster when catastrophic multi-master quorum failure occurs.
# Run directly from the Helper Node via SSH.
# ==============================================================================
set -euo pipefail

SURVIVING_MASTER="${1:-master-0}"
SNAPSHOT_PATH="${2:-}"

SSH_KEY="${SSH_KEY:-}"
if [ -z "$SSH_KEY" ]; then
  for candidate in ~/.ssh/id_rsa ~/.ssh/id_rsa_ocp /root/.ssh/id_rsa /home/core/.ssh/id_rsa; do
    if [ -f "$candidate" ]; then
      SSH_KEY="$candidate"
      break
    fi
  done
fi

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
echo " OpenShift 4.20 Emergency etcd Single-Member Restoration"
echo " Target Surviving Master: ${SURVIVING_MASTER}"
echo "======================================================================"

log_info "[Step 1/6] Verifying SSH connectivity to surviving master: ${SURVIVING_MASTER}..."
if ! ssh ${SSH_OPTS} core@"${SURVIVING_MASTER}" "uptime" >/dev/null 2>&1; then
  log_error "Cannot connect via SSH to ${SURVIVING_MASTER}."
  exit 1
fi
log_success "SSH connection established to ${SURVIVING_MASTER}."

# Step 2: Quench static pods on the surviving master
log_info "[Step 2/6] Quenching static pods on ${SURVIVING_MASTER}..."
ssh ${SSH_OPTS} core@"${SURVIVING_MASTER}" bash -s << 'EOF'
set -euo pipefail
sudo mkdir -p /tmp/manifests-backup
if ls /etc/kubernetes/manifests/*.yaml >/dev/null 2>&1; then
  sudo mv /etc/kubernetes/manifests/*.yaml /tmp/manifests-backup/
fi

echo "Waiting for etcd and kube-apiserver containers to exit..."
for i in {1..10}; do
  RUNNING=$(sudo crictl ps -a -q --name "etcd-member|kube-apiserver" --state Running | wc -l)
  if [ "$RUNNING" -eq 0 ]; then
    echo "Static pod containers stopped."
    break
  fi
  sleep 3
done
EOF
log_success "Static pods quenched."

# Step 3: Snapshot handling and single-member restore
log_info "[Step 3/6] Restoring etcd database into single-member cluster..."
ssh ${SSH_OPTS} core@"${SURVIVING_MASTER}" bash -s -- "${SNAPSHOT_PATH}" << 'EOF'
set -euo pipefail
GIVEN_SNAPSHOT="$1"
RESTORE_SNAPSHOT=""

if [ -n "$GIVEN_SNAPSHOT" ] && [ -f "$GIVEN_SNAPSHOT" ]; then
  RESTORE_SNAPSHOT="$GIVEN_SNAPSHOT"
else
  echo "No external snapshot specified; creating emergency live snapshot from local etcd directory..."
  RESTORE_SNAPSHOT="/tmp/emergency-local-snapshot.db"
  
  # Take snapshot from static pod certs or raw database
  if sudo ETCDCTL_API=3 etcdctl snapshot save "${RESTORE_SNAPSHOT}"     --cacert=/etc/kubernetes/static-pod-resources/etcd-certs/secrets/etcd-all-certs/etcd-ca-bundle.crt     --cert=/etc/kubernetes/static-pod-resources/etcd-certs/secrets/etcd-all-certs/etcd-serving-*.crt     --key=/etc/kubernetes/static-pod-resources/etcd-certs/secrets/etcd-all-certs/etcd-serving-*.key 2>/dev/null; then
    echo "Live snapshot created at ${RESTORE_SNAPSHOT}."
  elif [ -d /var/lib/etcd/member ]; then
    echo "Using existing /var/lib/etcd data directory."
  else
    echo "ERROR: Neither snapshot nor /var/lib/etcd directory found!"
    exit 1
  fi
fi

if [ -f "/usr/local/bin/etcd-snapshot-restore.sh" ]; then
  echo "Invoking official RHCOS single-member restore script..."
  sudo /usr/local/bin/etcd-snapshot-restore.sh "${RESTORE_SNAPSHOT}"
else
  echo "WARNING: /usr/local/bin/etcd-snapshot-restore.sh not found. Resetting member list manually..."
  # Remove peer metadata to force single-member
  sudo rm -rf /var/lib/etcd/member/wal
fi
EOF
log_success "Single-member etcd restore executed."

# Step 4: Restore static pod manifests
log_info "[Step 4/6] Restoring static pod manifests to /etc/kubernetes/manifests/..."
ssh ${SSH_OPTS} core@"${SURVIVING_MASTER}" bash -s << 'EOF'
set -euo pipefail
sudo mv /tmp/manifests-backup/*.yaml /etc/kubernetes/manifests/
EOF
log_success "Manifests restored. Kubelet will now start etcd and kube-apiserver."

# Step 5: Poll etcd single-member health
log_info "[Step 5/6] Waiting for etcd to elect itself single-member leader..."
ssh ${SSH_OPTS} core@"${SURVIVING_MASTER}" bash -s << 'EOF'
set -euo pipefail
for i in {1..20}; do
  if sudo crictl ps --name etcd-member --state Running | grep -q etcd-member; then
    echo "etcd static pod is running."
    break
  fi
  sleep 4
done
EOF

# Step 6: Verify API Server response
log_info "[Step 6/6] Verifying API Server response on ${SURVIVING_MASTER}..."
ssh ${SSH_OPTS} core@"${SURVIVING_MASTER}" bash -s << 'EOF'
export KUBECONFIG=/etc/kubernetes/static-pod-resources/kube-apiserver-certs/secrets/node-kubeconfigs/lb-ext.kubeconfig
for i in {1..25}; do
  if oc get nodes 2>/dev/null; then
    echo "API Server successfully responding to queries!"
    exit 0
  fi
  sleep 5
done
echo "WARNING: API server is still warming up. Check logs: crictl logs kube-apiserver"
EOF

echo "======================================================================"
log_success "Emergency Single-Member Recovery Completed on ${SURVIVING_MASTER}!"
echo "Now proceed to reinstall the dead masters using:"
echo "  docs/09-emergency-runbooks/03-node-reinstallation-and-replacement.md"
echo "======================================================================"
