# Cluster Lifecycle & EUS-to-EUS Upgrades

OpenShift 4.20 supports Extended Update Support (EUS), allowing enterprise organizations to transition between even-numbered releases (e.g. 4.18 -> 4.20) with minimal disruption.

---

## Safe Upgrade Methodology: Paused MachineConfigPools

To prevent all worker nodes from restarting simultaneously during a major upgrade, pause the worker pool before initiating the cluster update:

```mermaid
sequenceDiagram
    autonumber
    actor Admin as SRE Operator
    participant Cluster as OpenShift Cluster
    participant MCP as Worker MachineConfigPool

    Admin->>MCP: oc patch mcp worker --type=merge -p '{"spec":{"paused":true}}'
    Admin->>Cluster: oc adm upgrade --to-latest=true
    Note over Cluster: Control Plane nodes upgrade & reboot sequentially
    Note over Cluster: ClusterOperators reach 4.20 state
    Admin->>MCP: oc patch mcp worker --type=merge -p '{"spec":{"paused":false}}'
    Note over MCP: Workers update one-by-one under strict maxUnavailable: 1
```

---
[Back to Day 2 Index](README.md) • [Next Chapter: Backup, DR & Rebuild](../08-backup-dr-and-rebuild/README.md)
