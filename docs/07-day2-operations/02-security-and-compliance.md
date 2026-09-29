# Security, Governance & Compliance Enforcement

OpenShift 4.20 is designed to satisfy strict NIST SP 800-53, PCI-DSS, and CIS Benchmark requirements out-of-the-box.

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Install Compliance Operator
1. Install the **Compliance Operator** in namespace `openshift-compliance` from OperatorHub:
   ```bash
   oc apply -f configs/day2/compliance-operator-sub.yaml
   ```
2. Verify operator pods are `Running`.

### Step 2: Bind CIS & NIST Benchmark Profiles
1. Apply the ScanSettingBinding targeting the CIS OpenShift and RHCOS profiles (see [`configs/day2/compliance-suite-cis.yaml`](../../configs/day2/compliance-suite-cis.yaml)):
   ```bash
   oc apply -f configs/day2/compliance-suite-cis.yaml
   ```

### Step 3: Monitor Compliance Scans
1. Track the running compliance scans:
   ```bash
   oc get compliancescan -n openshift-compliance -w
   ```
2. When status transitions to `DONE`, inspect the scan results:
   ```bash
   oc get compliancecheckresult -n openshift-compliance | grep -E "FAIL|ERROR"
   ```

### Step 4: Auto-Remediate Rule Failures
1. Review generated `ComplianceRemediation` objects:
   ```bash
   oc get complianceremediation -n openshift-compliance
   ```
2. Apply automated remediations to enforce kernel parameters and file permissions:
   ```bash
   oc patch complianceremediation <remediation-name> -n openshift-compliance --type=merge -p '{"spec":{"apply":true}}'
   ```

### Step 5: Deploy File Integrity Operator (FIO)
1. Install **File Integrity Operator** to monitor unauthorized modifications of `/usr`, `/etc`, and `/boot` across all nodes using AIDE.

---
[Next: GitOps Foundation](03-gitops-foundation.md) • [Back to Day 2 Index](README.md)
