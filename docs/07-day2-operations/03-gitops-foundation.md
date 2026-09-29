# GitOps Foundation: ArgoCD & External Secrets

Declarative management of all Day 1 and Day 2 cluster configurations eliminates configuration drift across multi-cluster fleets.

---

## Architecture: App-of-Apps Pattern

```mermaid
flowchart TD
    GitRepo["Git Repository (SSOT)"] --> RootApp["ArgoCD Root Application"]
    RootApp --> App1["Child App: Day 1 Ingress & Certs"]
    RootApp --> App2["Child App: Identity & RBAC"]
    RootApp --> App3["Child App: Monitoring & Logging"]
    RootApp --> App4["Child App: Compliance Operator"]
    RootApp --> App5["Child App: Storage & ODF"]
```

---

## Secret Management via External Secrets Operator (ESO)
Storing raw secrets in Git violates security standards. OpenShift 4.20 pairs GitOps with the **External Secrets Operator (ESO)**:
- Secrets are maintained in HashiCorp Vault, AWS Secrets Manager, or Azure Key Vault.
- The `ExternalSecret` CR pulls secrets into native Kubernetes `Secrets` dynamically.

---
[Next: Lifecycle & Upgrades](04-lifecycle-and-upgrades.md) • [Back to Day 2 Index](README.md)
