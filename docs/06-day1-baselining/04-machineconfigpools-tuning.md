# MachineConfigPools (MCP) & Node Tuning

The Machine Config Operator (MCO) ensures that operating system configurations (RHCOS) remain immutable and version-controlled.

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Define Custom MachineConfigPool (e.g. Infra Pool)
1. Deploy the `infra` MachineConfigPool definition (see [`configs/day1/mcp-infra-nodes.yaml`](../../configs/day1/mcp-infra-nodes.yaml)):
   ```bash
   oc apply -f configs/day1/mcp-infra-nodes.yaml
   ```

### Step 2: Label and Taint Target Infrastructure Nodes
1. Label selected worker nodes to move them into the infra pool:
   ```bash
   oc label node worker-0.corp.local node-role.kubernetes.io/infra=""
   oc label node worker-0.corp.local node-role.kubernetes.io/worker-
   ```
2. Apply taints so general user applications are prevented from scheduling:
   ```bash
   oc adm taint node worker-0.corp.local node-role.kubernetes.io/infra=reserved:NoSchedule
   ```

### Step 3: Configure Node-Level NTP (Chrony)
1. Apply the Chrony MachineConfig pointing to the Helper Node / internal NTP server:
   ```bash
   oc apply -f configs/day1/machineconfig-chrony.yaml
   ```
2. The Machine Config Operator rolls out `/etc/chrony.conf` to all nodes and restarts `chronyd`.

### Step 4: Deploy Node Tuning Operator for Low Latency / Real-Time
1. Apply a `PerformanceProfile` for CPU isolation and real-time kernel (`kernel-rt`):
   ```yaml
   apiVersion: performance.openshift.io/v2
   kind: PerformanceProfile
   metadata:
     name: realtime-telco-profile
   spec:
     cpu:
       isolated: "2-15"
       reserved: "0-1"
     hugepages:
       defaultHugepagesSize: "1G"
       pages:
         - size: "1G"
           count: 8
     realTimeKernel:
       enabled: true
     nodeSelector:
       node-role.kubernetes.io/worker-rt: ""
   ```

### Step 5: Verify MachineConfigPool Health
1. Ensure all MCPs reach `Updated=True` and `Degraded=False`:
   ```bash
   oc get mcp
   ```

---
[Back to Day 1 Index](README.md) • [Next Chapter: Day 2 Operations](../07-day2-operations/README.md)
