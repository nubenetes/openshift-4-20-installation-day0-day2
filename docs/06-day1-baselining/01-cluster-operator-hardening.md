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

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Execute Cluster Health Audit Script
1. Run [`scripts/validate-cluster-health.sh`](../../scripts/validate-cluster-health.sh):
   ```bash
   ./scripts/validate-cluster-health.sh
   ```
2. The script audits all 34+ operators, MCPs, nodes, Ingress, and default StorageClasses.

### Step 2: Identify Degraded Operators
1. Filter for operators in an abnormal state:
   ```bash
   oc get co --no-headers | awk '$3 != "True" || $4 != "False" || $5 != "False" {print $1, "Avail:"$3, "Prog:"$4, "Degr:"$5}'
   ```

### Step 3: Deep Condition Inspection
1. Inspect operator status conditions:
   ```bash
   oc describe co <operator-name>
   ```
2. Review the `Status.Conditions` block for error messages, certificate expiration, or connectivity timeouts.

### Step 4: Inspect Underlying Pod Logs
1. Locate the operator's namespace:
   ```bash
   oc get pods -n openshift-<operator-namespace>
   ```
2. Stream controller container logs:
   ```bash
   oc logs -n openshift-<operator-namespace> deployment/<operator-deployment> -c <container> --tail=100
   ```

### Step 5: Force Operator Reconciliation
1. If an operator is stuck in transient deadlock, delete the operator pod to force Kubernetes to restart the controller:
   ```bash
   oc delete pod -n openshift-<operator-namespace> -l app=<operator-name>
   ```

---
[Next: Ingress & Custom Certificates](02-ingress-and-custom-certs.md) • [Back to Day 1 Index](README.md)
