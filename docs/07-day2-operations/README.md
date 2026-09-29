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
```

---
[Back to Global Navigation](../00-navigation.md)
