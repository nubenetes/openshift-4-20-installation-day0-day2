# Identity Providers (IDP) & RBAC Hardening

Production clusters must never rely on local static passwords or the temporary `kubeadmin` superuser.

---

## 1. Enterprise SSO Integration (Keycloak / Entra ID)
Configure OpenID Connect (OIDC) via the cluster OAuth configuration (see [`configs/day1/idp-keycloak-oidc.yaml`](../../configs/day1/idp-keycloak-oidc.yaml)).

---

## 2. Revoking Self-Provisioner Privileges
By default, authenticated users can create arbitrary namespaces. Enterprise governance requires namespace creation to be mediated via GitOps:

```bash
# Remove self-provisioner cluster role binding
oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated:oauth

# Lock the role binding against automatic reconciliation
oc patch clusterrolebinding self-provisioners -p '{"metadata":{"annotations":{"rbac.authorization.kubernetes.io/autoupdate":"false"}}}'
```

---

## 3. Disabling `kubeadmin`
Once enterprise SSO identity federation and administrator RBAC are confirmed working:

```bash
oc delete secret kubeadmin -n kube-system
```

---
[Next: MachineConfigPools & Node Tuning](04-machineconfigpools-tuning.md) • [Back to Day 1 Index](README.md)
