# 05 - Enterprise Secret Management & Automated PKI Rotation

Manual secret provisioning and static TLS certificate deployments are the leading causes of production outages in enterprise Kubernetes environments. This guide details the production architecture for **zero-touch Ingress certificate auto-rotation** via `cert-manager` and **centralized secret synchronization** via the `External Secrets Operator` (ESO).

---

## Architecture Overview

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                        AUTOMATED SECRET & PKI ARCHITECTURE                             │
└────────────────────────────────────────────────────────────────────────────────────────┘

    ┌───────────────────────────┐                ┌───────────────────────────┐
    │ Enterprise HashiCorp Vault│                │ Corporate Internal CA     │
    │ / AWS Secrets / Azure KV  │                │ / Let's Encrypt (ACME)    │
    └─────────────┬─────────────┘                └─────────────┬─────────────┘
                  │                                            │
                  ▼                                            ▼
    ┌───────────────────────────┐                ┌───────────────────────────┐
    │  External Secrets Operator│                │   cert-manager Operator   │
    │   (ClusterSecretStore)    │                │      (ClusterIssuer)      │
    └─────────────┬─────────────┘                └─────────────┬─────────────┘
                  │ Reconciles every 1h                        │ Renews 30d before expiry
                  ▼                                            ▼
    ┌───────────────────────────┐                ┌───────────────────────────┐
    │ Native Kubernetes Secrets │                │ Wildcard Ingress TLS Cert │
    │ (openshift-config / Apps) │                │ (openshift-ingress secret)│
    └───────────────────────────┘                └─────────────┬─────────────┘
                                                               │ Reloads router pods
                                                               ▼
                                                 ┌───────────────────────────┐
                                                 │ OpenShift Ingress Router  │
                                                 │   (*.apps.<cluster-fqdn>) │
                                                 └───────────────────────────┘
```

---

## 1. Automated PKI & Wildcard Certificate Rotation (`cert-manager`)

### Implementation Procedure

1. **Deploy cert-manager Operator**:
   Subscribe to `openshift-cert-manager-operator` using [`configs/security/cert-manager-clusterissuer.yaml`](../../configs/security/cert-manager-clusterissuer.yaml).

2. **Configure ClusterIssuer**:
   Bind `cert-manager` to your enterprise PKI (HashiCorp Vault PKI engine or corporate Active Directory Certificate Services):
   ```yaml
   apiVersion: cert-manager.io/v1
   kind: ClusterIssuer
   metadata:
     name: enterprise-vault-issuer
   spec:
     vault:
       path: pki/sign/openshift-dot-apps
       server: "https://vault.internal.corp:8200"
       auth:
         kubernetes:
           mountPath: /v1/auth/kubernetes
           role: cert-manager-issuer
           secretRef:
             name: cert-manager-vault-token
             key: token
   ```

3. **Declare Wildcard Ingress Certificate**:
   Define auto-renewal parameters (`renewBefore: 720h` = 30 days before expiration):
   ```yaml
   apiVersion: cert-manager.io/v1
   kind: Certificate
   metadata:
     name: custom-ingress-wildcard-cert
     namespace: openshift-ingress
   spec:
     secretName: custom-ingress-cert-tls
     duration: 2160h # 90 days
     renewBefore: 720h # 30 days
     commonName: "*.apps.ocp-prod.corp.local"
     dnsNames:
       - "*.apps.ocp-prod.corp.local"
     issuerRef:
       name: enterprise-vault-issuer
       kind: ClusterIssuer
   ```

4. **Bind IngressController to Auto-Renewed Secret**:
   Patch OpenShift's default IngressController to track the managed secret:
   ```bash
   oc patch ingresscontroller.operator default \
     --type=merge -p \
     '{"spec":{"defaultCertificate":{"name":"custom-ingress-cert-tls"}}}' \
     -n openshift-ingress-operator
   ```
   *Outcome*: `cert-manager` requests a fresh TLS certificate from Vault every 60 days. OpenShift router pods dynamically reload the secret with **zero dropped client connections**.

---

## 2. Centralized Secret Lifecycle (`External Secrets Operator`)

### The Security Challenge
Storing base64-encoded secrets inside Git repositories (even encrypted via SealedSecrets or SOPS) introduces secret sprawl, key rotation friction, and compliance audit penalties.

### The ESO Solution
The **External Secrets Operator (ESO)** continuously synchronizes secrets from HashiCorp Vault, AWS Secrets Manager, Azure Key Vault, or GCP Secret Manager directly into native Kubernetes secrets in memory.

### Step-by-Step Configuration

1. **Deploy External Secrets Operator**:
   Apply [`configs/security/external-secrets-store.yaml`](../../configs/security/external-secrets-store.yaml).

2. **Establish ClusterSecretStore**:
   Authenticate the cluster to the enterprise Vault cluster using Kubernetes ServiceAccount JWT tokens:
   ```bash
   oc create serviceaccount external-secrets-sa -n openshift-operators
   ```

3. **Synchronize Global OpenShift Pull Secret**:
   Automatically pull and refresh the cluster-wide registry authentication secret from Vault without human credential handling:
   ```yaml
   apiVersion: external-secrets.io/v1beta1
   kind: ExternalSecret
   metadata:
     name: global-pull-secret-sync
     namespace: openshift-config
   spec:
     refreshInterval: "1h"
     secretStoreRef:
       name: vault-cluster-backend
       kind: ClusterSecretStore
     target:
       name: pull-secret
       creationPolicy: Merge
     data:
       - secretKey: .dockerconfigjson
         remoteRef:
           key: production/openshift/registry-auth
           property: .dockerconfigjson
   ```

---

## Verification & Audit Commands

```bash
# Verify cert-manager certificate issuance status
oc get certificate -n openshift-ingress
oc get secret custom-ingress-cert-tls -n openshift-ingress -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -noout -dates -subject

# Verify ExternalSecrets synchronization status
oc get clustersecretstore
oc get externalsecret -A
oc describe externalsecret global-pull-secret-sync -n openshift-config
```

---
[Back to Day 1 Baselining Index](README.md) • [Next: Day 2 Observability Stack](../07-day2-operations/01-observability-stack.md)
