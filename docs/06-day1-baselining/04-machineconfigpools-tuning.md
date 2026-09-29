# MachineConfigPools (MCP) & Node Tuning

The Machine Config Operator (MCO) ensures that operating system configurations (RHCOS) remain immutable and version-controlled.

---

## Dedicated Infrastructure Nodes
Prevent system routers and logging components from competing with customer workloads by carving out dedicated `infra` nodes:

1. Label nodes:
   ```bash
   oc label node worker-0.corp node-role.kubernetes.io/infra=""
   oc label node worker-0.corp node-role.kubernetes.io/worker-
   ```
2. Apply taint:
   ```bash
   oc adm taint node worker-0.corp node-role.kubernetes.io/infra=reserved:NoSchedule
   ```
3. Create `MachineConfigPool` (see [`configs/day1/mcp-infra-nodes.yaml`](../../configs/day1/mcp-infra-nodes.yaml)).

---

## Performance Profile & Node Tuning Operator
For low-latency, Telco, and AI workloads, tune kernel parameters via Node Tuning Operator:
- Real-time kernel (`kernel-rt`)
- Hugepages (1GB / 2MB pages)
- CPU isolation & pinning (`reservedSystemCPUs: "0,1"`)

---
[Back to Day 1 Index](README.md) • [Next Chapter: Day 2 Operations](../07-day2-operations/README.md)
