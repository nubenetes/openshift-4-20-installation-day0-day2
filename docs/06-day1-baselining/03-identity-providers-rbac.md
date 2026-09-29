# Identity Providers (IDP) & RBAC Hardening

Production clusters must never rely on local static passwords or the temporary `kubeadmin` superuser.

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Configure OpenID Connect (Keycloak / Microsoft Entra ID)
1. Register OpenShift as an OIDC client in your Identity Provider (Keycloak, Okta, or Microsoft Entra ID).
2. Note the Client ID, Client Secret, and OpenID discovery endpoint.
3. Store the client secret in `openshift-config`:
   ```bash
   oc create secret generic keycloak-client-secret      --from-literal=clientSecret="SuperSecureSecret2026!"      -n openshift-config
   ```

### Step 2: Apply OAuth Custom Resource
1. Apply the OAuth configuration (see [`configs/day1/idp-keycloak-oidc.yaml`](../../configs/day1/idp-keycloak-oidc.yaml)):
   ```bash
   oc apply -f configs/day1/idp-keycloak-oidc.yaml
   ```
2. Wait for the `authentication` ClusterOperator to roll out the updated OAuth pods:
   ```bash
   oc rollout status deployment/oauth-openshift -n openshift-authentication
   ```

### Step 3: Grant Administrator Permissions to Enterprise Groups
1. Assign `cluster-admin` to the enterprise platform operations group:
   ```bash
   oc adm policy add-cluster-role-to-group cluster-admin "Platform-Engineers"
   ```

### Step 4: Revoke Default Self-Provisioner Permissions
1. Prevent regular developers from creating arbitrary unmonitored namespaces:
   ```bash
   oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated:oauth
   oc patch clusterrolebinding self-provisioners -p '{"metadata":{"annotations":{"rbac.authorization.kubernetes.io/autoupdate":"false"}}}'
   ```

### Step 5: Disable Temporary `kubeadmin` Account
1. Once enterprise SSO login is confirmed working via the web console:
   ```bash
   oc delete secret kubeadmin -n kube-system
   ```

---
[Next: MachineConfigPools & Node Tuning](04-machineconfigpools-tuning.md) • [Back to Day 1 Index](README.md)
