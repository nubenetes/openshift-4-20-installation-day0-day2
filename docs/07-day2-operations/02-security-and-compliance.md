# Security, Governance & Compliance Enforcement

OpenShift 4.20 is designed to satisfy strict NIST SP 800-53, PCI-DSS, and CIS Benchmark requirements out-of-the-box.

---

## 1. Compliance Operator
The Compliance Operator audits and automatically remediates cluster configurations against industry security benchmarks:
- `ocp4-cis`: CIS Red Hat OpenShift Container Platform 4 Benchmark.
- `rhcos4-cis`: CIS Red Hat Enterprise Linux CoreOS Benchmark.
- `ocp4-pci-dss`: Payment Card Industry Data Security Standard.

See [`configs/day2/compliance-suite-cis.yaml`](../../configs/day2/compliance-suite-cis.yaml) to run continuous automated scans.

---

## 2. File Integrity Operator
Monitors file modifications across control plane and worker nodes using AIDE (Advanced Intrusion Detection Environment) to detect unauthorized tampering with system binaries or configurations.

---
[Next: GitOps Foundation](03-gitops-foundation.md) • [Back to Day 2 Index](README.md)
