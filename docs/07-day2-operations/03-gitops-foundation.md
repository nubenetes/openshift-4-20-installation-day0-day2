# GitOps Foundation: ArgoCD & External Secrets

Declarative management of all Day 1 and Day 2 cluster configurations eliminates configuration drift across multi-cluster fleets.

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Install Red Hat OpenShift GitOps Operator
1. Subscribe to **Red Hat OpenShift GitOps** from OperatorHub:
   ```bash
   oc apply -f configs/day2/gitops-operator-sub.yaml
   ```
2. OpenShift GitOps automatically creates a cluster-wide ArgoCD instance in namespace `openshift-gitops`.

### Step 2: Structure Cluster Fleet Git Repository
1. Organize your declarative Git repository into App-of-Apps hierarchy:
   ```
   fleet-gitops/
   ├── bootstrap/
   │   └── root-application.yaml
   └── clusters/
       └── prod-01/
           ├── day1-certs/
           ├── day1-rbac/
           ├── day2-monitoring/
           └── workloads/
   ```

### Step 3: Install External Secrets Operator (ESO)
1. Install the **External Secrets Operator** from OperatorHub.
2. Create a `ClusterSecretStore` pointing to your enterprise secret engine (HashiCorp Vault / AWS Secrets Manager):
   ```yaml
   apiVersion: external-secrets.io/v1beta1
   kind: ClusterSecretStore
   metadata:
     name: vault-backend
   spec:
     provider:
       vault:
         server: "https://vault.corp.local:8200"
         path: "secret"
         version: "v2"
         auth:
           kubernetes:
             mountPath: "kubernetes"
             role: "openshift-fleet"
   ```

### Step 4: Deploy the Root App-of-Apps
1. Point ArgoCD to the root application:
   ```bash
   oc apply -f bootstrap/root-application.yaml
   ```
2. ArgoCD synchronizes and establishes the desired state across all cluster operators, ingress certs, and applications.

---
[Next: Lifecycle & Upgrades](04-lifecycle-and-upgrades.md) • [Back to Day 2 Index](README.md)
