# 06 - GitOps App-of-Apps: Fleet Orchestration & Drift Elimination

The **App-of-Apps** pattern is the architectural standard for enterprise OpenShift 4.20. Rather than managing disparate YAML files or relying on manual console edits, a single root ArgoCD `Application` declaratively drives the deployment of all child applications, operators, policies, and workloads across clusters.

---

## Architectural Topology: The App-of-Apps Hierarchy

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                        ARGO CD ROOT APP-OF-APPS ARCHITECTURE                           │
└────────────────────────────────────────────────────────────────────────────────────────┘

                       ┌────────────────────────────────────────┐
                       │        Root Cluster Application        │
                       │   (configs/gitops/root-app-of-apps)    │
                       └───────────────────┬────────────────────┘
                                           │
         ┌──────────────────┬──────────────┴─────┬──────────────────┬──────────────────┐
         │                  │                    │                  │                  │
         ▼                  ▼                    ▼                  ▼                  ▼
┌─────────────────┐┌─────────────────┐┌─────────────────┐┌─────────────────┐┌─────────────────┐
│ Sync Wave 0:    ││ Sync Wave 1:    ││ Sync Wave 2:    ││ Sync Wave 3:    ││ Sync Wave 4:    │
│ Platform Core   ││ Operator Catalog││ Security & PKI  ││ Storage & Data  ││ Workloads & AI   │
├─────────────────┤├─────────────────┤├─────────────────┤├─────────────────┤├─────────────────┤
│ • Proxy config  ││ • OADP Operator ││ • cert-manager  ││ • ODF Storage   ││ • KubeVirt VMs  │
│ • Chrony NTP    ││ • GitOps ArgoCD ││ • External Secret││ • Kopia Backup  ││ • RHOAI / vLLM  │
│ • Infra MCPs    ││ • Compliance Op ││ • Keycloak IDP  ││ • StorageClasses││ • Business Apps │
└─────────────────┘└─────────────────┘└─────────────────┘└─────────────────┘└─────────────────┘
```

---

## 1. Day 0 to Day 2 Automated Handshake

The moment the OpenShift installer outputs `Install complete!`, automated Day 2 bootstrapping executes via a single command:

```bash
# 1. Install OpenShift GitOps Operator
oc apply -f configs/gitops/gitops-operator-sub.yaml

# 2. Wait for ArgoCD server readiness
oc wait --for=condition=Available deployment/openshift-gitops-server -n openshift-gitops --timeout=300s

# 3. Apply the Root App-of-Apps
oc apply -f configs/gitops/root-app-of-apps.yaml
```

Once applied, the root application reads the target Git repository and begins deterministic, phased reconciliation using **ArgoCD Sync Waves**.

---

## 2. Phased Orchestration via Sync Waves

To prevent dependency race conditions (e.g., trying to deploy an OADP Custom Resource before the OADP Operator CRD is installed), child applications are annotated with deterministic `argocd.argoproj.io/sync-wave`:

| Sync Wave | Component Category | Resources Reconciled | Failure Domain Isolation |
| :---: | :--- | :--- | :--- |
| **Wave 0** | **Base Infrastructure** | MachineConfigPools, Chrony NTP, Proxy TrustCA | Pre-requisite node configuration |
| **Wave 1** | **Operator Subscriptions** | OADP, cert-manager, ESO, Compliance, KubeVirt | Installs CRDs and controllers |
| **Wave 2** | **Security & Identity** | ClusterSecretStores, ClusterIssuers, Keycloak IDP | Establishes PKI and secrets |
| **Wave 3** | **Data Fabric & Protection**| ODF StorageClusters, OADP Backup Schedules | Persistent storage and DR readiness |
| **Wave 4** | **Platform Extensions** | OpenShift Virtualization VMs, RHOAI DataScienceCluster | User workloads and compute engines |

---

## 3. Production Git Repository Organization

```
fleet-gitops-repo/
├── bootstrap/
│   ├── base/
│   │   ├── kustomization.yaml
│   │   └── root-application.yaml
│   └── overlays/
│       ├── production/
│       │   ├── kustomization.yaml
│       │   └── cluster-values.yaml
│       └── staging/
├── platform/
│   ├── day1-hardening/
│   │   ├── ingress-tls/
│   │   ├── idp-rbac/
│   │   └── machineconfigs/
│   └── day2-operations/
│       ├── oadp-backup/
│       ├── compliance-operator/
│       ├── observability-stack/
│       ├── openshift-virtualization/
│       └── openshift-ai/
└── workloads/
    ├── tenant-a/
    └── tenant-b/
```

---

## 4. Drift Detection & Self-Healing Governance

The root application enforces strict automated drift correction:
```yaml
syncPolicy:
  automated:
    prune: true        # Automatically deletes resources removed from Git
    selfHeal: true     # Automatically overrides unauthorized manual cluster edits
    allowEmpty: false  # Prevents accidental deletion of cluster state if Git repo is empty
  syncOptions:
    - CreateNamespace=true
    - ApplyOutOfSyncOnly=true
    - RespectIgnoreDifferences=true
```

If an administrator manually edits an IngressController, weakens an SCC, or modifies a MachineConfig, ArgoCD detects the divergence within **180 seconds** (or immediately via Webhook) and reverts the live cluster back to the immutable state committed in Git.

---

## Verification & Monitoring Commands

```bash
# Check overall GitOps Application synchronization health
oc get applications -n openshift-gitops

# Inspect detailed status of the root app
argocd app get root-cluster-app-of-apps

# Confirm zero-drift status
oc get applications -n openshift-gitops -o custom-columns='NAME:.metadata.name,SYNC:.status.sync.status,HEALTH:.status.health.status'
```

---
[Back to Day 2 Index](README.md) • [Next: OpenShift AI & GPU Acceleration](07-openshift-ai-gpu.md)
