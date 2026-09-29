# 08 - Disaster Recovery, Backup & GitOps Rebuild Strategy

A resilient OpenShift architecture requires a defined recovery time objective (RTO) and recovery point objective (RPO) backed by automated snapshotting, data protection, and declarative rebuild pipelines.

---

## Disaster Recovery Matrix by Failure Domain

| Disaster Level | Failure Scope | Recommended Recovery Strategy | Expected RTO | Expected RPO |
| :--- | :--- | :--- | :---: | :---: |
| **Level 1** | Single Master Node failure | Automatic Raft recovery / Replace master | < 15 mins | 0 seconds |
| **Level 2** | Full etcd Quorum Loss (2+ Masters) | Single-Node etcd snapshot restore | 30 - 60 mins | RPO = Last Snapshot (<24h) |
| **Level 3** | Application Pod / PVC Data corruption | OADP (OpenShift API for Data Protection) | 15 - 45 mins | RPO = Last Backup (<1h - 24h) |
| **Level 4** | Complete Datacenter Catastrophe | Metro-DR (ODF Sync) or Pure GitOps Rebuild | < 5 mins (Metro) / 45m (GitOps) | 0s (Metro) / Declarative State |

---
[Back to Global Navigation](../00-navigation.md)
