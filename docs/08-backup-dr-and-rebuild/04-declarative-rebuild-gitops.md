# Declarative Cluster Rebuild from Scratch with GitOps

The most modern disaster recovery pattern for cloud-native platforms is **treating the entire OpenShift cluster as disposable infrastructure**.

Rather than troubleshooting corrupted etcd databases during a catastrophe, platform teams rebuild the entire cluster from scratch in under 45 minutes.

---

## The Rebuild-from-Scratch Workflow

```mermaid
sequenceDiagram
    autonumber
    actor SRE as Platform SRE
    participant Infra as Cloud / Bare-Metal Infrastructure
    participant ABI as Agent-Based Installer / IPI
    participant GitOps as OpenShift GitOps (ArgoCD)
    participant OADP as OADP Storage Restore

    SRE->>Infra: 1. Re-provision raw hardware / VMs
    SRE->>ABI: 2. Boot via Agent-Based ISO (25 mins)
    Note over ABI: Cluster reaches Ready state with default configuration
    SRE->>GitOps: 3. Apply ArgoCD bootstrap manifest (3 mins)
    GitOps->>GitOps: 4. Syncs Root App-of-Apps from Git
    Note over GitOps: Deploys all Operators, Ingress certs, IDP, RBAC, and Workloads
    SRE->>OADP: 5. Trigger OADP restore of Stateful PV data (10 mins)
    Note over OADP: PV volumes snapshot-restored and bound to apps
    SRE-->>SRE: Cluster fully restored in ~40 minutes!
```

---

## Essential Components of Pure GitOps Rebuilds

1. **All Cluster Configurations in Git**:
   - MachineConfigs, IngressControllers, OAuth, StorageClasses, and Operators declared in Kustomize / Helm.
2. **Zero In-Cluster State in Day 0/1**:
   - No manual `oc create` commands executed directly on the cluster.
3. **Decoupled Persistent Data**:
   - Database PVs backed up to external S3 object stores via OADP, ready to be mounted during step 5 of the recovery pipeline.

---
[Back to DR Index](README.md) • [Back to Global Navigation](../00-navigation.md)
