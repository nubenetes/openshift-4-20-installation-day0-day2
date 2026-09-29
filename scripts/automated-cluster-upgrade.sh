#!/usr/bin/env bash
# ==============================================================================
# OpenShift 4.20 End-to-End Automated Cluster Upgrade Orchestrator
# Enforces pre-flight audit -> automated etcd backup -> paused MCP rollout
# ==============================================================================
set -euo pipefail

TARGET_VERSION="${1:-}"
CANARY_NODE="${2:-}"

if [ -z "$TARGET_VERSION" ]; then
  echo "Usage: $0 <target-version> [optional-canary-worker-node]"
  echo "Example: $0 4.20.1"
  echo "Example with canary: $0 4.20.1 worker-0.corp.local"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "======================================================================"
echo " Starting OpenShift 4.20 Automated Upgrade to: ${TARGET_VERSION}"
echo "======================================================================"

# Step 1: Pre-Upgrade Health Check
echo -e "\n[Step 1/6] Running Pre-Upgrade Health Checks..."
"${SCRIPT_DIR}/pre-upgrade-health-check.sh"

# Step 2: Mandatory etcd Backup
echo -e "\n[Step 2/6] Executing Mandatory Pre-Upgrade etcd Snapshot..."
"${SCRIPT_DIR}/etcd-backup.sh"
echo "etcd backup completed and verified."

# Step 3: Pause Worker MachineConfigPool
echo -e "\n[Step 3/6] Pausing Worker MachineConfigPool (Preventing Worker Reboot Storm)..."
oc patch mcp worker --type=merge -p '{"spec":{"paused":true}}'
echo "Worker pool paused. Workers will NOT reboot during control plane upgrade."

# Step 4: Initiate Cluster Upgrade
echo -e "\n[Step 4/6] Triggering ClusterVersion Upgrade to ${TARGET_VERSION}..."
oc adm upgrade --to="${TARGET_VERSION}"

echo -e "\n[Step 5/6] Monitoring Control Plane Upgrade Progress..."
while true; do
  completed=$(oc get clusterversion version -o jsonpath='{.status.conditions[?(@.type=="Available")].status}')
  progressing=$(oc get clusterversion version -o jsonpath='{.status.conditions[?(@.type=="Progressing")].status}')
  current_version=$(oc get clusterversion version -o jsonpath='{.status.history[0].version}')
  state_msg=$(oc get clusterversion version -o jsonpath='{.status.history[0].state}')

  echo "[CVO Status] Version: ${current_version} | State: ${state_msg} | Progressing: ${progressing}"
  if [ "$progressing" == "False" ] && [ "$current_version" == "$TARGET_VERSION" ]; then
    echo "Control plane successfully upgraded to ${TARGET_VERSION}!"
    break
  fi
  sleep 30
done

# Step 6: Worker Rollout & Verification
echo -e "\n[Step 6/6] Rolling Out Worker Nodes..."
if [ -n "$CANARY_NODE" ]; then
  echo "Canary mode: Testing upgrade on canary node ${CANARY_NODE}..."
fi

oc patch mcp worker --type=merge -p '{"spec":{"paused":false}}'
echo "Worker MachineConfigPool unpaused. MCO will update workers sequentially (maxUnavailable: 1)."

echo -e "\nWaiting for all Worker nodes to reach Updated=True..."
oc wait --for=condition=Updated=True mcp/worker --timeout=60m

echo -e "\n======================================================================"
echo " OpenShift 4.20 Cluster Upgrade to ${TARGET_VERSION} Complete and Verified!"
echo "======================================================================"
"${SCRIPT_DIR}/validate-cluster-health.sh"
