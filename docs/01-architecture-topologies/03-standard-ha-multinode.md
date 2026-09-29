# Standard Multi-Node High Availability (HA) Architecture

Standard Multi-Node HA is the gold standard for enterprise production environments, providing strict physical and logical separation between the Kubernetes Control Plane, System Infrastructure services, and Application Workload compute pools.

---

## Enterprise Topology Blueprint

```mermaid
flowchart TD
    subgraph ControlPlane["Dedicated Control Plane (3 Nodes - Non-Schedulable)"]
        M1["master-0<br/>etcd-0"]
        M2["master-1<br/>etcd-1"]
        M3["master-2<br/>etcd-2"]
    end

    subgraph InfraPool["Dedicated Infrastructure Pool (3 Nodes)"]
        I1["infra-0<br/>Ingress Router / Keepalived"]
        I2["infra-1<br/>Prometheus / Thanos / Loki"]
        I3["infra-2<br/>OpenShift Internal Registry"]
    end

    subgraph StoragePool["Dedicated ODF Storage Pool (3+ Nodes)"]
        S1["storage-0 (Ceph OSDs)"]
        S2["storage-1 (Ceph OSDs)"]
        S3["storage-2 (Ceph OSDs)"]
    end

    subgraph WorkerPool["General Application Compute Pool (N Nodes)"]
        W1["worker-01"]
        W2["worker-02"]
        WN["worker-NN"]
    end

    ControlPlane -.->|API & Scheduler| InfraPool
    ControlPlane -.->|API & Scheduler| StoragePool
    ControlPlane -.->|API & Scheduler| WorkerPool
```

---

## Node Roles & MachineConfigPools (MCP)

To maintain stability at scale, the cluster is divided into distinct MachineConfigPools:

1. ** Pool**:
   - Size: Exactly 3 nodes (odd number for Raft quorum).
   - Taint:  (immutable).
   - Dedicated low-latency network interface for etcd replication.
2. ** Pool**:
   - Size: 3 nodes minimum (distributed across distinct failure zones / racks).
   - Taint: .
   - Workload assignment: IngressController, OpenShift Monitoring (Prometheus, Alertmanager), OpenShift Logging (Vector, LokiStack), Quay Registry.
3. ** Pool (Optional if running external SAN/NAS or separate ODF)**:
   - Size: 3 to 12 nodes.
   - Dedicated NVMe disks and 25/100GbE storage fabric.
4. ** Pool**:
   - Size: 3 to 2,000+ nodes.
   - Dynamic scaling via MachineSets or manual expansion.

---
[Next: Remote Worker Nodes over WAN](04-remote-workers-wan.md) • [Back to Topologies Index](README.md)
