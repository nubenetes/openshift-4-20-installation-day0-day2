# Control Plane & Worker Node Replacement and Reinstallation Runbook

## Overview & Operational Objectives

Hardware failures, unrecoverable disk corruption, or hypervisor host terminations require replacing an OpenShift 4.20 node. The procedure differs fundamentally depending on the node's architectural role:

1. **Control Plane Master Node**: Houses the distributed **etcd** key-value store. You **cannot** simply reinstall the node; the failed member must be explicitly evicted from the Raft quorum before a replacement node is provisioned, or the cluster risks split-brain or permanent quorum collapse.
2. **Data Plane Worker / Infra Node**: Stateless from a Kubernetes control plane perspective. Workloads must be safely evicted (cordoned and drained) to prevent service disruption before the node is reprovisioned.

---

## Part 1: Control Plane Master Node Replacement

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                             MASTER NODE REPLACEMENT SEQUENCE                                    │
├──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 1. Identify Failed Master (e.g. master-1) -> Verify etcd cluster has 2 surviving members.        │
│ 2. Exec into healthy master -> Remove master-1 from etcd member list (etcdctl member remove).    │
│ 3. Delete old Node object: oc delete node master-1.                                             │
│ 4. Reprovision host via Agent ISO / Bare Metal BMC / Assisted UI / Cloud MachineSet.             │
│ 5. Approve new node Kubelet Client and Serving CSRs (oc adm certificate approve).               │
│ 6. cluster-etcd-operator detects new node -> Provisions etcd pod -> Rejoins Raft quorum (3/3).  │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```

### Step 1: Pre-Replacement Health Verification
Verify that at least **two** control plane nodes are fully operational and healthy before removing the failed node:

```bash
oc get nodes -l node-role.kubernetes.io/master
```
*Expected State*: Two masters `Ready`, one master `NotReady` or missing.

Verify etcd quorum and determine the Member ID of the failed node:
```bash
# Exec into a healthy etcd pod (e.g. master-0)
oc rsh -n openshift-etcd $(oc get pods -n openshift-etcd -l app=etcd --no-headers | grep master-0 | awk '{print $1}')

# Inside etcd container: List members
etcdctl member list -w table
```
Note the hex **ID** corresponding to the failed node (e.g., `8e9e05c52164694d` for `master-1`).

---

### Step 2: Remove Failed Master from etcd Quorum
Still inside the healthy etcd pod, remove the failed member:
```bash
etcdctl member remove 8e9e05c52164694d
```
*Expected Output*: `Member 8e9e05c52164694d removed from cluster`

Verify the member list now shows only the 2 surviving masters:
```bash
etcdctl member list -w table
exit
```

---

### Step 3: Delete Old Node and Machine Objects
Delete the failed node object from the Kubernetes cluster:
```bash
oc delete node master-1.corp.local
```

If the cluster is deployed on Cloud IPI or VMware IPI with the Machine API:
```bash
# Check Machine state
oc get machines -n openshift-machine-api -l machine.openshift.io/cluster-api-machine-role=master

# Delete failed machine
oc delete machine <failed-master-machine-name> -n openshift-machine-api
```

---

### Step 4: Reinstall the Control Plane Node

#### Method A: Bare Metal / Hypervisor via Agent-Based Installer (ABI)
1. Wipe the target physical or virtual disks to clear old partition tables and Ceph/etcd signatures:
   ```bash
   # Wipe disk via live ISO or rescue environment
   wipefs -af /dev/nvme0n1 /dev/sda
   ```
2. Mount the bootable Agent ISO ([`scripts/generate-agent-iso.sh`](../../scripts/generate-agent-iso.sh)) via BMC Virtual Media (Dell iDRAC, HPE iLO, or Hyper-V PowerShell).
3. Ensure the replacement node boots with the **exact same static IP address, subnet, gateway, and MAC bonding configuration** specified in `agent-config.yaml`.
4. Power on the node and allow it to boot into the RHCOS automated installer.

#### Method B: Assisted Installer Web UI / Red Hat Advanced Cluster Management (ACM)
1. In the OpenShift / ACM Web Console, navigate to **Multicluster > Clusters > [Cluster Name] > Host Inventory**.
2. Locate the failed host; click **Actions > Delete Host** or **Reset Host**.
3. Download the Discovery ISO from the console UI.
4. Mount the Discovery ISO on the replacement hardware and boot.
5. In the console UI, the new host will appear under **Discovered Hosts**.
6. Set the hostname to `master-1.corp.local`, assign the role **Control plane node**, and click **Approve / Install**.

#### Method C: Cloud IPI (AWS, Azure, GCP) via ControlPlaneMachineSet
In public cloud IPI installations, OpenShift manages control plane lifecycle automatically:
```bash
oc get controlplanemachineset cluster -n openshift-machine-api -o yaml
```
Deleting the failed `Machine` resource in Step 3 automatically triggers the `ControlPlaneMachineSet` operator to provision an identical new cloud instance, apply cloud ignition, and boot the replacement instance.

---

### Step 5: Approve Kubelet CSRs
As the replacement master boots and initializes, kubelet requests admission to the cluster:

```bash
# Watch for pending CSRs
oc get csr | grep -i pending
```

Approve the initial node client CSR:
```bash
oc get csr -ojsonpath='{range .items[?(@.status.conditions==[])]}{.metadata.name}{"
"}{end}' | while read csr; do
  oc adm certificate approve "${csr}"
done
```

Wait ~60 seconds for the node serving CSR to appear, and approve it:
```bash
oc get csr -ojsonpath='{range .items[?(@.status.conditions==[])]}{.metadata.name}{"
"}{end}' | while read csr; do
  oc adm certificate approve "${csr}"
done
```

---

### Step 6: Verify Automatic etcd Reintegration
Once the new node transitions to `Ready`:
1. The `cluster-etcd-operator` automatically detects the new control plane node.
2. It generates etcd peer certificates, deploys the `etcd-member` static pod manifest, and joins the new node to the Raft consensus group.
3. Verify that 3 members are reporting healthy:
   ```bash
   oc rsh -n openshift-etcd $(oc get pods -n openshift-etcd -l app=etcd --no-headers | head -n1 | awk '{print $1}') etcdctl endpoint health -w table
   ```

---

## Part 2: Worker & Infra Node Replacement

Worker and infrastructure nodes do not participate in etcd quorum. Replacement focuses on workload evacuation and MachineConfigPool alignment.

### Step 1: Cordon and Drain the Degraded Node
Prevent new workloads from scheduling on the node:
```bash
oc adm cordon worker-2.corp.local
```

Gracefully evict all running pods:
```bash
oc adm drain worker-2.corp.local   --force   --ignore-daemonsets   --delete-emptydir-data   --grace-period=60   --timeout=15m
```

---

### Step 2: Delete Node from Cluster Registry
```bash
oc delete node worker-2.corp.local
```

---

### Step 3: Reprovision the Worker Node
- **Bare Metal / Virtual**: Boot replacement host using the Agent-Based Installer ISO.
- **Web UI / ACM**: Add host via Discovery ISO, assign role **Worker**, and approve.
- **MachineSet Auto-Scaling**:
  ```bash
  # Scale down and scale up to recreate worker instance
  oc scale machineset <worker-machineset-name> -n openshift-machine-api --replicas=<N-1>
  sleep 30
  oc scale machineset <worker-machineset-name> -n openshift-machine-api --replicas=<N>
  ```

---

### Step 4: Approve CSRs and Verify MCP Synchronization
Approve pending kubelet CSRs:
```bash
oc get csr -ojsonpath='{range .items[?(@.status.conditions==[])]}{.metadata.name}{"
"}{end}' | xargs -r oc adm certificate approve
```

Verify the node is adopted into the worker or infra pool:
```bash
oc get nodes
oc get mcp worker
```
*Expected Result*: The node transitions from `NotReady` to `Ready`, and the MachineConfigPool completes configuration sync (`Updated=True`, `Degraded=False`).

---

## Automated Scripts

To streamline these operations, use the repository's dedicated automation scripts:
- **Control Plane Replacement**: [`scripts/replace-control-plane-node.sh <failed-master-name>`](../../scripts/replace-control-plane-node.sh)
- **Worker Node Replacement**: [`scripts/reinstall-worker-node.sh <failed-worker-name>`](../../scripts/reinstall-worker-node.sh)
