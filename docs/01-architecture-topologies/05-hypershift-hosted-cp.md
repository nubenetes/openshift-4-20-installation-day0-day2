# Hosted Control Planes (HyperShift) Architecture

Hosted Control Planes (historically known as HyperShift) decouple the OpenShift control plane from the data plane, running the master components as native Kubernetes workloads (deployments, statefulsets, and configmaps) inside a centralized Management (Hosting) Cluster.

---

## Architectural Comparison

```mermaid
flowchart TD
    subgraph Classic["Classic OpenShift Cluster"]
        VM1["Master VM 1 (Dedicated OS)"]
        VM2["Master VM 2 (Dedicated OS)"]
        VM3["Master VM 3 (Dedicated OS)"]
        W1["Worker Node 1"]
        W2["Worker Node 2"]
    end

    subgraph Hosted["Hosted Control Planes Model"]
        subgraph ManagementCluster["Central Management Cluster"]
            HCP1["Namespace: clusters-tenant1<br/>kube-apiserver Pods<br/>etcd StatefulSet<br/>KCM Pods"]
            HCP2["Namespace: clusters-tenant2<br/>kube-apiserver Pods<br/>etcd StatefulSet<br/>KCM Pods"]
        end
        subgraph DataPlane["Tenant Data Plane (Workers Only)"]
            TW1["Tenant 1 - Worker 1"]
            TW2["Tenant 1 - Worker 2"]
            TW3["Tenant 2 - Worker 1"]
        end
    end
```

---

## Advantages of Hosted Control Planes in 2026

1. **Massive Infrastructure Cost Reduction**:
   - Eliminates 3 dedicated master nodes per cluster. A management cluster with 3 physical nodes can host 50+ tenant control planes.
2. **Sub-Minute Cluster Creation**:
   - Spawning a new control plane takes ~45 seconds (standard Pod startup time) compared to 25–45 minutes for full VM provisioning.
3. **Strong Blast Radius Isolation**:
   - Tenants only access worker nodes; tenant administrators have zero SSH or physical access to control plane operating systems.
4. **Automated Centralized Lifecycle**:
   - Upgrading control planes is executed through standard rolling updates of Kubernetes deployments managed by Red Hat Advanced Cluster Management (ACM).

---
[Back to Topologies Index](README.md) • [Next Chapter: Provisioning Paradigms](../02-provisioning-paradigms/README.md)
