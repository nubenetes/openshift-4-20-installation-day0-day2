# 06 - Day 1 Post-Installation Hardening & Baselining

Day 1 activities begin the moment `openshift-install wait-for install-complete` succeeds. They transform a raw cluster into a hardened, production-ready enterprise platform.

---

## Day 1 Roadmap & Sequence

```mermaid
sequenceDiagram
    autonumber
    actor Admin as SRE / Platform Engineer
    participant Cluster as OpenShift 4.20 Cluster

    Admin->>Cluster: 1. Validate ClusterOperators stability (oc get co)
    Admin->>Cluster: 2. Replace Ingress wildcard TLS certificate with trusted Enterprise CA
    Admin->>Cluster: 3. Configure Enterprise Identity Provider (Keycloak / Entra ID / LDAP)
    Admin->>Cluster: 4. Lock down RBAC (Disable kubeadmin, revoke self-provisioner)
    Admin->>Cluster: 5. Create MachineConfigPools for Infra & Storage nodes
    Admin->>Cluster: 6. Enforce Node Tuning, NTP/Chrony, and OVN-Kubernetes egress policies
```

---
[Back to Global Navigation](../00-navigation.md)
