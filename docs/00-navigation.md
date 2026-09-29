# OpenShift 4.20 Architecture & Operations Navigation Index

Welcome to the definitive architectural, installation, and lifecycle engineering repository for **Red Hat OpenShift Container Platform (OCP) 4.20** (current to September 2026).

This documentation suite is organized across 8 core operational domains designed for Enterprise Platform Architects, Site Reliability Engineers, and Infrastructure Specialists.

---

## Master Directory Map

| Domain | Description | Quick Links |
| :--- | :--- | :--- |
| **00. Global Navigation** | Repository taxonomy and index | [Navigation Map](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/00-navigation.md) |
| **01. Architecture & Topologies** | SNO, 3-Node Compact, Standard HA, Remote Workers, HyperShift | [Index](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/01-architecture-topologies/README.md) • [SNO](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/01-architecture-topologies/01-sno-single-node.md) • [Compact](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/01-architecture-topologies/02-compact-3-node-converged.md) • [Standard HA](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/01-architecture-topologies/03-standard-ha-multinode.md) • [Remote Workers](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/01-architecture-topologies/04-remote-workers-wan.md) • [HyperShift](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/01-architecture-topologies/05-hypershift-hosted-cp.md) |
| **02. Provisioning Paradigms** | Agent-Based (ABI), IPI, UPI, and GitOps ZTP | [Index](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/02-provisioning-paradigms/README.md) • [Agent-Based](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/02-provisioning-paradigms/01-agent-based-installer.md) • [IPI](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/02-provisioning-paradigms/02-installer-provisioned-ipi.md) • [UPI](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/02-provisioning-paradigms/03-user-provisioned-upi.md) • [ZTP / ACM](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/02-provisioning-paradigms/04-ztp-acm-gitops.md) |
| **03. Network & Connectivity** | Proxies, Air-Gapped  v2, DNS/NTP/PKI, OVN | [Index](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/03-network-and-connectivity/README.md) • [Connected & Proxies](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/03-network-and-connectivity/01-connected-with-proxies.md) • [Air-Gap oc-mirror v2](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/03-network-and-connectivity/02-air-gapped-oc-mirror-v2.md) • [Air-Gap Core Services](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/03-network-and-connectivity/03-air-gapped-core-services.md) • [OVN-Kubernetes Tuning](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/03-network-and-connectivity/04-ovn-kubernetes-tuning.md) |
| **04. Platform Guides** | Bare Metal, vSphere 8/9, Nutanix, KVM, AWS, Azure, GCP | [Index](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/04-platforms/README.md) • [Bare Metal](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/04-platforms/01-bare-metal-physical.md) • [vSphere](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/04-platforms/02-vmware-vsphere.md) • [Nutanix](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/04-platforms/03-nutanix-ahv.md) • [KVM & OpenStack](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/04-platforms/04-kvm-openstack.md) • [AWS](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/04-platforms/05-aws.md) • [Azure](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/04-platforms/06-azure.md) • [GCP](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/04-platforms/07-gcp.md) |
| **05. Day 0 Readiness** | Sizing, Hardware, DNS & LBs, Storage CSI & ODF | [Index](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/05-day0-readiness/README.md) • [Sizing & Hardware](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/05-day0-readiness/01-hardware-and-sizing.md) • [DNS & Load Balancing](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/05-day0-readiness/02-dns-loadbalancer-matrix.md) • [Storage & ODF](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/05-day0-readiness/03-storage-architecture-odf.md) |
| **06. Day 1 Baselining** | Operator validation, TLS Ingress, IDP & RBAC, MCPs | [Index](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/06-day1-baselining/README.md) • [Operator Hardening](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/06-day1-baselining/01-cluster-operator-hardening.md) • [Ingress & Wildcard TLS](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/06-day1-baselining/02-ingress-and-custom-certs.md) • [IDP & RBAC](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/06-day1-baselining/03-identity-providers-rbac.md) • [MachineConfigPools](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/06-day1-baselining/04-machineconfigpools-tuning.md) |
| **07. Day 2 Operations** | Observability, Compliance, GitOps Foundation, Upgrades | [Index](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/07-day2-operations/README.md) • [Observability Stack](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/07-day2-operations/01-observability-stack.md) • [Security & Compliance](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/07-day2-operations/02-security-and-compliance.md) • [GitOps & ArgoCD](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/07-day2-operations/03-gitops-foundation.md) • [Upgrades & Lifecycle](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/07-day2-operations/04-lifecycle-and-upgrades.md) |
| **08. Backup, DR & Rebuild** | etcd recovery, OADP vs Velero, Metro-DR, GitOps Rebuild | [Index](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/08-backup-dr-and-rebuild/README.md) • [etcd Backup & Restore](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/08-backup-dr-and-rebuild/01-etcd-backup-restore.md) • [OADP vs Velero Analysis](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/08-backup-dr-and-rebuild/02-oadp-vs-velero-deepdive.md) • [Metro-DR & Regional-DR](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/08-backup-dr-and-rebuild/03-metro-dr-and-regional-dr.md) • [Declarative GitOps Rebuild](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/08-backup-dr-and-rebuild/04-declarative-rebuild-gitops.md) |

---

## How to Navigate This Guide
1. **Design & Architect**: Start with [Architecture Topologies](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/01-architecture-topologies/README.md) and [Provisioning Paradigms](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/02-provisioning-paradigms/README.md).
2. **Infrastructure Validation**: Review [Day 0 Readiness](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/05-day0-readiness/README.md) and run [0;34m======================================================================[0m
[0;34m OpenShift 4.20 Preflight Readiness Validator - September 2026[0m
[0;34m Cluster: ocp420.example.com[0m
[0;34m======================================================================[0m

--- 1. Checking Core DNS Records ---
[[0;31mFAIL[0m] DNS record 'api.ocp420.example.com' could not be resolved!
[[0;31mFAIL[0m] DNS record 'api-int.ocp420.example.com' could not be resolved!
[[0;31mFAIL[0m] DNS record 'canary-test.apps.ocp420.example.com' could not be resolved!

--- 2. Checking Reverse PTR Records ---
[[1;33mWARN[0m] No reverse PTR configured for IP: 192.168.10.100
[[1;33mWARN[0m] No reverse PTR configured for IP: 192.168.10.101

--- 3. Checking System Clock & NTP Sync ---
[[0;32mPASS[0m] System clock is synchronized via systemd-timesyncd / timedatectl

--- 4. Checking Proxy Environment Variables ---
[[0;32mPASS[0m] No proxy configured (direct connection mode)

--- 5. Checking Port Accessibility ---
[[1;33mWARN[0m] Connection to 192.168.10.100:6443 (OpenShift API Server) timed out or rejected (expected if not yet running)
[[1;33mWARN[0m] Connection to 192.168.10.100:22623 (Machine Config Server) timed out or rejected (expected if not yet running)
[[1;33mWARN[0m] Connection to 192.168.10.101:443 (Cluster Ingress Router HTTPS) timed out or rejected (expected if not yet running)

======================================================================
 Preflight Summary: [0;32m2 Passed[0m, [1;33m5 Warnings[0m, [0;31m3 Failed[0m
======================================================================.
3. **Platform Deployment**: Select your hypervisor or cloud target in [Platforms](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/04-platforms/README.md).
4. **Hardening**: Execute Day 1 post-installation procedures in [Day 1 Baselining](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/06-day1-baselining/README.md).
5. **Continuous Ops & Disaster Recovery**: Implement [Day 2 Operations](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/07-day2-operations/README.md) and establish your recovery SLA with [Backup, DR & Rebuild](file:///home/inafev/.gemini/antigravity/scratch/openshift-4-20-installation-day0-day2/docs/08-backup-dr-and-rebuild/README.md).
