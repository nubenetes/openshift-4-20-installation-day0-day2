# 07 - Day 2 Operations, Fleet Management & Lifecycle

Day 2 operations define the ongoing maintenance, observability, compliance enforcement, and automated lifecycle of production OpenShift 4.20 clusters.

---

## Day 2 Operational Pillars

```mermaid
flowchart TD
    D2[OpenShift 4.20 Day 2 Operations] --> Obs[1. Observability: Thanos, UWM, LokiStack, OpenTelemetry]
    D2 --> Sec[2. Security & Compliance: Compliance Operator, CIS, FileIntegrity]
    D2 --> GitOps[3. GitOps Foundation: OpenShift GitOps ArgoCD v3+, ESO]
    D2 --> Upgrades[4. Lifecycle & Upgrades: EUS Channels, Paused MCPs, Canaries]
    D2 --> AutoUpgrades[5. Automated Upgrades: Pre-flight Audit, etcd Snapshot, Air-Gap]
```

---

## Section Documents
- [01. Enterprise Observability Stack](01-observability-stack.md)
- [02. Security, Governance & Compliance](02-security-and-compliance.md)
- [03. GitOps Foundation (ArgoCD & ESO)](03-gitops-foundation.md)
- [04. Cluster Lifecycle & EUS Upgrades](04-lifecycle-and-upgrades.md)
- [05. Automated Upgrades & Orchestration](05-automated-upgrades.md)

---
[Back to Global Navigation](../00-navigation.md)
