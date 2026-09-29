# Cluster Operator Verification & Hardening

OpenShift 4.20 manages all core platform functions through approximately 34 built-in Cluster Operators.

---

## Operator Health Status Interpretation

```bash
oc get clusteroperators
```

A fully healthy cluster must show:
- **`AVAILABLE`**: `True` for all operators.
- **`PROGRESSING`**: `False` for all operators.
- **`DEGRADED`**: `False` for all operators.

---

## Troubleshooting Stalled Operators
If an operator reports `Degraded=True` or `Progressing=True` indefinitely:

```bash
# 1. Inspect specific operator conditions
oc describe co <operator-name>

# 2. Check operator namespace pods and logs
oc get pods -n openshift-<operator-namespace>
oc logs -n openshift-<operator-namespace> deployment/<operator-deployment> -c <container>

# 3. Check co-related events
oc get events -n openshift-<operator-namespace> --sort-by='.metadata.creationTimestamp'
```

---
[Next: Ingress & Custom Certificates](02-ingress-and-custom-certs.md) • [Back to Day 1 Index](README.md)
