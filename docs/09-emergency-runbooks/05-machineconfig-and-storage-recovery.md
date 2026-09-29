# Unsticking Degraded MachineConfigPools & Recovering from Disk Pressure / OverlayFS Exhaustion

## Overview & Failure Scenarios

In production OpenShift 4.20 clusters, nodes can enter unrecoverable degraded states due to two highly common failure modes:
1. **MachineConfigPool (MCP) Deadlock**: A pool becomes stuck in `Updating=True` or `Degraded=True` because a node cannot complete draining, a custom `MachineConfig` contains an invalid kernel argument/sysctl, or the Machine Config Daemon (MCD) hangs during host pivot.
2. **Container Storage OverlayFS Exhaustion**: The filesystem underlying `/var/lib/containers` reaches 100% capacity due to high image churn, logging spikes, or failed garbage collection. Kubelet enters `DiskPressure=True`, pod sandboxes fail to initialize, and the node becomes `NotReady`.

---

## Part 1: Unsticking Degraded MachineConfigPools

### Step 1: Diagnose the Exact Blocker
Check the overall pool status:
```bash
oc get mcp
```
*Expected Issue*: `UPDATED=False`, `UPDATING=True`, `DEGRADED=True`.

Identify the specific node causing the pool degradation:
```bash
oc get nodes
```
Look for nodes in `Ready,SchedulingDisabled` with annotations indicating an in-progress update:
```bash
oc get nodes -o custom-columns='NAME:.metadata.name,DESIRED_CONFIG:.metadata.annotations.machineconfiguration\.openshift\.io/desiredConfig,CURRENT_CONFIG:.metadata.annotations.machineconfiguration\.openshift\.io/currentConfig,STATE:.metadata.annotations.machineconfiguration\.openshift\.io/state'
```

---

### Step 2: Investigate Machine Config Daemon (MCD) Logs
Stream the logs of the MCD pod running on the stuck node:
```bash
STUCK_NODE="worker-1.corp.local"
MCD_POD=$(oc get pods -n openshift-machine-config-operator -l k8s-app=machine-config-daemon --field-selector spec.nodeName=${STUCK_NODE} -o jsonpath='{.items[0].metadata.name}')

oc logs -n openshift-machine-config-operator ${MCD_POD} -c machine-config-daemon --tail=100
```

---

### Step 3: Resolve Common MCP Deadlocks

#### Scenario A: Node Drain Timeout (Blocked by PDB or DaemonSet)
If logs report: `failed to drain node: cannot evict pod ... PodDisruptionBudget budget: 0 allowed disruptions`:
1. Find the blocking pod:
   ```bash
   oc get pods -A --field-selector spec.nodeName=${STUCK_NODE}
   ```
2. Inspect restrictive PDBs:
   ```bash
   oc get pdb -A
   ```
3. If an unmanaged or deadlocked pod is preventing the drain, delete the pod forcefully to unblock the MCD:
   ```bash
   oc delete pod <pod-name> -n <namespace> --force --grace-period=0
   ```

#### Scenario B: Faulty MachineConfig or Invalid Sysctl
If MCD logs report: `failed to execute systemd-sysctl: invalid argument`:
1. Identify recently applied custom MachineConfigs:
   ```bash
   oc get mc --sort-by=.metadata.creationTimestamp
   ```
2. Inspect the spec of the latest MachineConfig:
   ```bash
   oc get mc <custom-mc-name> -o yaml
   ```
3. Delete or correct the offending `MachineConfig`. The Machine Config Operator will re-render the desired pool configuration without the faulty parameters and re-trigger rollout.

#### Scenario C: Emergency MCD Reset from the Helper Node
If the MCD is hung and unresponsive to Kubernetes commands, SSH directly from the Helper Node:
```bash
ssh -i ~/.ssh/id_rsa core@${STUCK_NODE}
```

Force the daemon to release its lockfile and restart:
```bash
sudo rm -f /run/machine-config-daemon-force
sudo systemctl restart machine-config-daemon
sudo journalctl -u machine-config-daemon -n 50 --no-pager
```

Once updated, uncordon the node:
```bash
oc adm uncordon ${STUCK_NODE}
```

---

## Part 2: Container Storage OverlayFS Exhaustion (`/var/lib/containers` Full)

When `/var/lib/containers` is at 100%, the node stops accepting new pods and existing pods crash because no temporary files can be written to disk.

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                 THE DISK PRESSURE EVACUATION TRAP                                │
├──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 1. /var/lib/containers hits 100% disk usage.                                                     │
│ 2. Kubelet posts NodeCondition: DiskPressure=True.                                              │
│ 3. Kubelet attempts to evict pods, but eviction requires writing eviction status to disk!        │
│ 4. CRI-O cannot write container state -> Kubelet hangs or crashes -> Node transitions NotReady.  │
│ 5. API server cannot schedule or evict anything because the node agent is dead!                  │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```

### Step 1: Access the Node Directly from the Helper Node
Because the node is `NotReady`, `oc debug node` will fail. Connect via SSH:
```bash
ssh -i ~/.ssh/id_rsa core@<node-ip>
```

Verify disk space consumption across mount points:
```bash
df -h /var /sysroot
```

---

### Step 2: Emergency Container Storage Prune
Use `crictl` to purge stopped containers and unreferenced container images:

```bash
# Remove all stopped containers
sudo crictl rm $(sudo crictl ps -a -q --state Exited) 2>/dev/null || true

# Prune unreferenced/dangling container images
sudo crictl rmi --prune
```

Check how much space was reclaimed:
```bash
df -h /var/lib/containers
```

---

### Step 3: Clean Saturated Systemd Journal Logs
If systemd journal logs have consumed gigabytes in `/var/log/journal`:
```bash
# Retain only the last 1 day of logs
sudo journalctl --vacuum-time=1d

# Cap total journal disk footprint to 500MB
sudo journalctl --vacuum-size=500M
```

---

### Step 4: Restart Container Engine and Kubelet
Restart CRI-O to release held file descriptors and unmount orphan overlay filesystems:
```bash
sudo systemctl restart crio
sudo systemctl restart kubelet
```

Verify that both daemons return to `active (running)`:
```bash
sudo systemctl is-active crio kubelet
```

---

### Step 5: Verify Node Health from Cluster
Back on the Helper Node, check that the node has cleared the `DiskPressure` condition:
```bash
oc get node <node-name>
oc describe node <node-name> | grep -E "DiskPressure|Ready"
```
*Expected*: `DiskPressure=False`, `Ready=True`.

---

## Permanent Prevention: Declarative Kubelet Garbage Collection

To prevent `/var/lib/containers` from exhausting disk in the future, enforce automated aggressive image garbage collection thresholds across all worker nodes via a declarative `KubeletConfig`:

```yaml
apiVersion: machineconfiguration.openshift.io/v1
kind: KubeletConfig
metadata:
  name: aggressive-image-gc
spec:
  machineConfigPoolSelector:
    matchLabels:
      pools.operator.machineconfiguration.openshift.io/worker: ""
  kubeletConfig:
    imageGCHighThresholdPercent: 80
    imageGCLowThresholdPercent: 70
    imageMinimumGCAge: 5m
```
*Effect*: When disk utilization hits 80%, kubelet will automatically and continuously delete unused images until disk utilization falls back to 70%.
