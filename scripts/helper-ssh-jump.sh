#!/usr/bin/env bash
# ==============================================================================
# OpenShift 4.20 Helper Node Out-of-Band SSH Jump & Diagnostic Tool
# Connects from the Helper Node to control plane and data plane nodes via SSH
# with automated key detection and IPMI Serial-Over-LAN (SOL) fallback.
# ==============================================================================
set -euo pipefail

TARGET="${1:-}"
shift || true
COMMAND="${*:-}"

if [ -z "$TARGET" ]; then
  echo "Usage: $0 <node-hostname-or-ip> [optional-command-to-run]"
  echo "Example (Interactive Shell):  $0 master-0.corp.local"
  echo "Example (Diagnostics):        $0 master-0 'crictl ps && systemctl status kubelet'"
  echo "Environment Variables:"
  echo "  SSH_USER: Target user (default: core)"
  echo "  SSH_KEY:  Path to SSH private key (auto-detected if unset)"
  echo "  BMC_IP:   BMC IP address for IPMI SOL fallback if SSH fails"
  echo "  BMC_USER: BMC username (default: root)"
  echo "  BMC_PASS: BMC password (default: calvin)"
  exit 1
fi

SSH_USER="${SSH_USER:-core}"
SSH_KEY="${SSH_KEY:-}"

if [ -z "$SSH_KEY" ]; then
  for candidate in ~/.ssh/id_rsa ~/.ssh/id_rsa_ocp /root/.ssh/id_rsa /home/core/.ssh/id_rsa; do
    if [ -f "$candidate" ]; then
      SSH_KEY="$candidate"
      break
    fi
  done
fi

BMC_IP="${BMC_IP:-}"
BMC_USER="${BMC_USER:-root}"
BMC_PASS="${BMC_PASS:-calvin}"

log_info() { echo -e "\033[0;34m[INFO]\033[0m $*"; }
log_warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
log_error() { echo -e "\033[0;31m[ERROR]\033[0m $*"; }
log_success() { echo -e "\033[0;32m[PASS]\033[0m $*"; }

SSH_OPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=4"
if [ -n "$SSH_KEY" ] && [ -f "$SSH_KEY" ]; then
  SSH_OPTS="${SSH_OPTS} -i ${SSH_KEY}"
fi

# Check SSH availability
log_info "Probing SSH reachability on ${TARGET}:22..."
if ssh -q ${SSH_OPTS} -o BatchMode=yes "${SSH_USER}@${TARGET}" exit >/dev/null 2>&1; then
  log_success "SSH connection established to ${TARGET}."
  if [ -n "$COMMAND" ]; then
    log_info "Executing remote command on ${TARGET}: ${COMMAND}"
    ssh ${SSH_OPTS} "${SSH_USER}@${TARGET}" "${COMMAND}"
  else
    log_info "Launching interactive shell on ${TARGET}..."
    ssh ${SSH_OPTS} "${SSH_USER}@${TARGET}"
  fi
  exit 0
fi

# Fallback path if SSH fails
log_warn "Direct SSH to ${TARGET} failed (Node down, network partitioned, or SSH daemon hung)."

if [ -n "$BMC_IP" ]; then
  log_info "Initiating out-of-band Serial-Over-LAN (SOL) session via IPMI (${BMC_IP})..."
  if command -v ipmitool >/dev/null 2>&1; then
    ipmitool -I lanplus -H "${BMC_IP}" -U "${BMC_USER}" -P "${BMC_PASS}" sol deactivate >/dev/null 2>&1 || true
    echo "======================================================================"
    echo " Connecting to Serial-Over-LAN Console. Press '~.' to exit session."
    echo "======================================================================"
    exec ipmitool -I lanplus -H "${BMC_IP}" -U "${BMC_USER}" -P "${BMC_PASS}" sol activate
  else
    log_error "ipmitool utility not installed on Helper Node."
  fi
else
  log_error "No BMC_IP specified for out-of-band IPMI recovery."
  echo "To launch IPMI Serial-Over-LAN manually, run:"
  echo "  ipmitool -I lanplus -H <bmc-ip> -U root -P <password> sol activate"
  echo "Or access via hypervisor console (vSphere VMRC, Hyper-V vmconnect, or virsh console)."
  exit 2
fi
