# Enterprise Red Hat OpenShift 4.20 Architecture, Installation & Lifecycle Matrix (Day 0, Day 1, Day 2)

[![OpenShift](https://img.shields.io/badge/OpenShift-4.20-EE0000.svg?logo=redhat&logoColor=white)](https://docs.openshift.com)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.31--1.33-326CE5.svg?logo=kubernetes&logoColor=white)](https://kubernetes.io)
[![RHCOS](https://img.shields.io/badge/RHCOS-9.6+-CC0000.svg?logo=redhat&logoColor=white)](https://docs.openshift.com)
[![Status](https://img.shields.io/badge/Status-Production--Ready-brightgreen.svg)]()
[![Release State](https://img.shields.io/badge/Release%20State-September%202026-8A2BE2.svg)]()
[![License](https://img.shields.io/badge/License-Apache%202.0-F9A825.svg)](LICENSE)
[![AI-Generated](https://img.shields.io/badge/Generated%20by-Gemini%203.8%20Flash-4285F4.svg?logo=google&logoColor=white)]()
<br/>
[![Gateway API](https://img.shields.io/badge/Gateway%20API-v1%20GA-4285F4.svg?logo=kubernetes&logoColor=white)](docs/03-network-and-connectivity/05-gateway-api-architecture.md)
[![Service Mesh](https://img.shields.io/badge/Service%20Mesh-3.x%20Ambient-466BB0.svg?logo=istio&logoColor=white)](docs/03-network-and-connectivity/05-gateway-api-architecture.md)
[![CNI OVN](https://img.shields.io/badge/CNI-OVN--Kubernetes-1F618D.svg)](docs/03-network-and-connectivity/04-ovn-kubernetes-tuning.md)
[![Air-Gap Standard](https://img.shields.io/badge/Air--Gap-oc--mirror%20v2-critical.svg)](docs/03-network-and-connectivity/02-air-gapped-oc-mirror-v2.md)
[![Storage Ceph](https://img.shields.io/badge/Storage-ODF%20Ceph%204.16+-E03C11.svg?logo=ceph&logoColor=white)](docs/05-day0-readiness/03-storage-architecture-odf.md)
[![GitOps](https://img.shields.io/badge/GitOps-Argo%20CD%203.5+-EF6C00.svg?logo=argo&logoColor=white)](docs/07-day2-operations/06-gitops-app-of-apps.md)
<br/>
[![Backup OADP](https://img.shields.io/badge/Backup-OADP%201.4+%20(Kopia)-2E7D32.svg)](docs/08-backup-dr-and-rebuild/02-oadp-backup-restore.md)
[![Lifecycle Upgrades](https://img.shields.io/badge/Lifecycle-Canary%20Upgrades-00897B.svg)](docs/07-day2-operations/05-automated-upgrades.md)
[![Virtualization](https://img.shields.io/badge/Virtualization-KubeVirt%204.16+-6A1B9A.svg)](docs/04-platforms/09-openshift-virtualization.md)
[![OpenShift AI](https://img.shields.io/badge/AI%20%2F%20ML-RHOAI%202.16+-00ACC1.svg?logo=redhat&logoColor=white)](docs/07-day2-operations/07-openshift-ai-gpu.md)
[![LLM Serving](https://img.shields.io/badge/LLM%20Serving-vLLM%20gRPC-0288D1.svg)](docs/07-day2-operations/07-openshift-ai-gpu.md)
[![Emergency Runbooks](https://img.shields.io/badge/Emergency-Runbooks%20&%20Scripts-D32F2F.svg)](docs/09-emergency-runbooks/README.md)
[![Security CIS](https://img.shields.io/badge/Security-CIS%20&%20NIST%20800--53-37474F.svg)](docs/07-day2-operations/03-compliance-cis-benchmark.md)
[![Observability](https://img.shields.io/badge/Observability-Full%20Stack%20(COO%2C%20Loki%2C%20Tempo%2C%20UWM)-007ACC.svg?logo=opentelemetry&logoColor=white)](docs/07-day2-operations/01-observability-stack.md)

An exhaustive, enterprise-grade reference architecture, installation engineering handbook, declarative automation toolkit, and Day 0/1/2 operational field manual for **Red Hat OpenShift Container Platform (OCP) 4.20** (Kubernetes 1.31–1.33, updated through **September/October 2026**).

Designed for Enterprise Platform Architects, Principal Site Reliability Engineers (SREs), and Hybrid Cloud Infrastructure Specialists, this repository bridges the complete operational continuum: from **Day 0** hardware/network capacity planning and preflight validation, to **Bootstrap-in-Place** media engineering, **Day 1** zero-trust security baselining, **Day 2** autonomous GitOps drift self-healing, **Modern Virtualization (KubeVirt/MTV)**, **Enterprise AI/GPU compute (RHOAI/vLLM)**, **Disaster Recovery (OADP/Metro-DR)**, and **Out-of-Band Emergency Runbooks** to resurrect dead clusters when the API server is unreachable.

### Key Repository Assets at a Glance:
- 📚 **51 Exhaustive Engineering Modules (`docs/`)**: Organized across 9 operational domains covering every topology, hypervisor, public cloud, Gateway API, and incident scenario.
- ⚙️ **44 Production Declarative Manifests (`configs/`)**: Validated Custom Resources for Agent-Based Installer, Keyless Cloud IPI, oc-mirror v2, Gateway API, Ingress PKI, Native Observability (UWM, LokiStack 3.x, Vector, TempoStack, OpenTelemetry, COO/Korrel8r, eBPF FlowCollector), GitOps root App-of-Apps, External Secrets Operator, cert-manager, OpenShift Virtualization, RHOAI, and vLLM ServingRuntime.
- 🛠️ **16 Production Automation Scripts ([`scripts/`](scripts/README.md))**: Complete shell and PowerShell operational tools covering preflight validation, air-gap mirroring, automated etcd backups, canary cluster upgrades with Prometheus SLO gating, automated OADP restore drills, expired certificate recovery from the Helper Node, single-member quorum restoration, and end-to-end native observability stack verification (documented in the [Scripts Manual](scripts/README.md)).
- 🎯 **10-Step Deterministic Implementation Workflow**: A unified sequence linking Day 0 readiness through to autonomous lifecycle operations across all infrastructure targets.

### Core Architecture & Technical Taxonomy Tags:

| Domain | Topic Tags & Architectural Components | Primary Reference Modules |
| :--- | :--- | :--- |
| **Ingress & Networking** | `gateway-api` `httproute` `grpcroute` `tlsroute` `service-mesh-3` `ovn-kubernetes` `geneve` `split-dns` `air-gapped` `oc-mirror-v2` | [`docs/03-network-and-connectivity/`](docs/03-network-and-connectivity/) |
| **Topologies & Sizing** | `sno` `compact-3-node` `standard-ha` `remote-workers-wan` `hypershift` `hosted-control-planes` `ztp` `acm-2.12` | [`docs/01-architecture-topologies/`](docs/01-architecture-topologies/) |
| **Datacenter & Cloud** | `bare-metal` `abi-bootstrap` `vsphere-8-9` `nutanix-ahv` `kvm-rhoso` `aws-sts-irsa` `azure-workload-id` `gcp-workload-id` `hyper-v` | [`docs/04-platforms/`](docs/04-platforms/) |
| **Storage & Data Fabric**| `odf-ceph` `rook-ceph` `ceph-rbd` `cephfs` `rgw-s3` `fio-benchmarks` `local-storage-lso` | [`docs/05-day0-readiness/03-storage-architecture-odf.md`](docs/05-day0-readiness/03-storage-architecture-odf.md) |
| **Modern Workloads** | `openshift-virtualization` `kubevirt` `forklift-mtv` `openshift-ai` `rhoai` `vllm-grpc` `kserve-v2` `nvidia-gpu-operator` `mig-slicing` | [`docs/04-platforms/09-openshift-virtualization.md`](docs/04-platforms/09-openshift-virtualization.md) & [`docs/07-day2-operations/07-openshift-ai-gpu.md`](docs/07-day2-operations/07-openshift-ai-gpu.md) |
| **Day 2 Ops & Recovery** | `gitops-argocd` `external-secrets` `cert-manager` `canary-upgrades` `oadp-velero` `kopia` `metro-dr` `regional-dr` `cis-benchmark` | [`docs/07-day2-operations/`](docs/07-day2-operations/) & [`docs/08-backup-dr-and-rebuild/`](docs/08-backup-dr-and-rebuild/) |
| **Emergency Runbooks** | `emergency-runbooks` `expired-certificates` `kubelet-csr-recovery` `etcd-quorum-recovery` `single-member-etcd` `node-replacement` `helper-ssh-jump` | [`docs/09-emergency-runbooks/`](docs/09-emergency-runbooks/) |

> [!IMPORTANT]
> **Architecture Reference & Non-Live Environment Disclaimer**:
> This repository, along with its architecture matrices, configuration manifests, and automation scripts, was generated using **Gemini 3.8 Flash**. It has **not yet been tested in a live cluster environment**; it is designed to serve as a dense, comprehensive **enterprise architecture reference and implementation blueprint** up to date as of September 2026. Always validate and tailor all manifests, network CIDRs, and scripts within a staging environment before executing in production.

---

## Enterprise OpenShift 4.20: The Day 0 to Day 2 Operational Blueprint

![Enterprise OpenShift 4.20: The Day 0 to Day 2 Operational Blueprint](assets/enterprise-openshift-4-20-day0-to-day2-blueprint.jpg)

### Comprehensive Blueprint Breakdown & Architectural Mechanics

This operational blueprint synthesizes the complete architectural lifecycle of an enterprise-grade Red Hat OpenShift Container Platform (OCP) 4.20 deployment, unifying Day 0 planning, Day 1 media installation, Day 2 continuous operations, enterprise AI compute, and out-of-band disaster resilience:

#### 1. Day 0: Architecture & Planning
* **Topology Selection Decision Framework**:
  * **Single Node OpenShift (SNO)**: Tailored for far-edge deployments, remote cell sites, and industrial edge computing. Consolidates both control plane and worker workloads onto a single physical or virtual host, surviving severe WAN disconnection while retaining full local autonomous execution.
  * **3-Node Compact Converged**: Engineered for regional branch offices, retail hubs, and mid-tier datacenters. All three control plane nodes act as schedulable compute workers (`spec.mastersSchedulable: true`), collocated with OpenShift Data Foundation (ODF) Ceph storage to deliver high availability and etcd Raft quorum without the capital footprint of dedicated worker nodes.
  * **Standard Multi-Node HA**: The baseline architectural standard for mission-critical core datacenters. Features 3 dedicated, isolated control plane nodes and an elastic pool of dedicated worker and infrastructure nodes to guarantee strict fault isolation, scale, and zero-downtime rolling upgrades.
* **Infrastructure, Provisioning & Storage Selection Matrix**:
  * **Physical Bare Metal**: Provisioned natively using the **Agent-Based Installer (ABI)** with hardware-level Redfish BMC management; storage backed by **Local NVMe + OpenShift Data Foundation (Ceph)** providing sub-millisecond block and shared file storage.
  * **VMware vSphere (8.x / 9.x)**: Provisioned via automated **vSphere IPI** (or Agent-Based ABI for strict enterprise change-control); integrated with **vSphere CSI / vSAN** for policy-driven virtual machine and persistent volume storage.
  * **Public Clouds (AWS / Azure / GCP)**: Automated **Cloud IPI** utilizing **Keyless Authentication** (AWS STS with IRSA, Azure Workload Identity Federation, GCP Workload Identity); backed by cloud-native managed block storage (AWS gp3 EBS, Azure Managed Disk, GCP Persistent Disk).
  * **Air-Gapped / Dark Site**: Provisioned using modernized **`oc-mirror` v2 + Agent-Based Installer (ABI)**; backing container images and storage via **Local Quay/Harbor registry + converged ODF Ceph**.
* **Preflight Disk IOPS Validation (`fio`)**:
  * Mandatory preflight hardware benchmarking: Control plane disk write latency must rigorously satisfy `<10ms` `fdatasync` latency at the 99th percentile (`fsync` p99 < 10ms) using `fio` benchmark probes. Fulfilling this latency budget is non-negotiable to prevent etcd quorum collapse, heartbeat timeouts, and unrecoverable split-brain API freezes.
* **Networking Paradigms & Disconnected Modernization**:
  * **Fully Connected**: Direct outbound HTTPS access to Red Hat CDN and OpenShift Update Service (OSUS) for immediate updates and remote health reporting.
  * **Air-Gapped / Dark Site (Zero Internet)**: Operates within total perimeter network isolation. Mandates a dedicated Linux **Helper Node** hosting authoritative BIND9 split-horizon DNS, local Chrony NTP clock synchronization (<500ms drift), and staging storage for `oc-mirror` v2.
  * **70% Faster Mirror Syncs via `oc-mirror` v2**: Eliminates legacy `oc-mirror` v1 bottlenecks by adopting declarative `ImageSetConfiguration` v2, local ephemeral caching, and OCI file-based streaming catalogs directly to enterprise Quay or Harbor registries.

#### 2. Day 1: Installation & Hardening
* **Agent-Based Installer (ABI) Standard**:
  * **Modern Replacement for Legacy UPI**: ABI officially replaces manual User-Provisioned Infrastructure on bare metal and VMware, embedding all static network configurations, LACP bonds, VLANs, and disk partitioning layouts into a single bootable Live RHCOS ISO.
  * **Bootstrap-in-Place (BiP)**: Completely eliminates external temporary 4th bootstrap VMs. Installs directly into RHCOS on bare metal via an ephemeral, memory-resident Assisted Service container stack executed in RAM on Node 0 (`rendezvousIP`), which subsequently converts in-place into permanent control plane quorum.
* **Zero-Trust Identity Federation & RBAC Lockdown**:
  * Default `self-provisioner` cluster role binding is immediately revoked to prohibit arbitrary project creation.
  * Temporary bootstrap `kubeadmin` credentials are permanently deleted following deployment verification.
  * Authentication is federated to enterprise Identity Providers (e.g., **Keycloak**, **Okta**, Microsoft Entra ID) using OpenID Connect (OIDC) and mapped to fine-grained Kubernetes RBAC roles.

#### 3. Day 2: Operations & AI Infrastructure
* **Autonomous GitOps Drift Management**:
  * Enterprise **Argo CD 3.5+** manages the entire cluster configuration lifecycle using the declarative **App-of-Apps** pattern.
  * Continuous automated drift detection and self-healing: automatically reconciles and overwrites unauthorized manual runtime modifications (`oc edit`, `kubectl patch`) back to the audited source-of-truth Git repository state.
* **Enterprise AI & GPU Acceleration**:
  * **NVIDIA GPU Operator 24.x**: Deploys dynamic kernel drivers, container runtime toolkits, and enables hardware-level **Multi-Instance GPU (MIG)** slicing to maximize GPU hardware utilization.
  * **vLLM ServingRuntime**: High-throughput private Large Language Model (LLM) serving engine featuring PagedAttention memory optimization, dynamic continuous batching, and native gRPC streaming routes for sub-millisecond AI token delivery.
* **Telemetry-Gated Canary Upgrades**:
  * Automated upgrade orchestration pauses worker MachineConfigPools (`spec.paused: true`) to protect active production workloads from uncontrolled concurrent node reboot storms.
  * Worker node updates roll out in sequential canary waves and are gated against live **Prometheus/Thanos SLO queries**; rollout halts immediately if Ingress HTTP 5xx error rates exceed `2.0%` or pod crash loops are detected.

#### 4. Architectural Guardrails & Emergency Lifelines
* **The Velero Verdict (Red Hat OADP vs. Vanilla Velero)**:
  * > [!CAUTION]
    > **Vanilla upstream Velero is UNSUITABLE for OpenShift**: Fails due to unhandled Security Context Constraints (SCC), lack of OpenShift API group support (Routes, BuildConfigs, DeploymentConfigs), and absence of built-in Kopia backup engine optimization. **Red Hat OADP 1.4+ (OpenShift API for Data Protection)** with the Kopia snapshot engine is the mandatory enterprise data protection standard.
* **Out-of-Band Emergency Runbooks**:
  * Battle-tested operational runbooks and automated shell scripts designed to resurrect clusters when the Kubernetes API server is unreachable.
  * Features out-of-band single-member etcd quorum revival (forcing surviving masters into a 1-node etcd cluster) and automated recovery of expired kubelet TLS certificates via SSH jump tunneling and IPMI Serial-Over-LAN (SOL) directly from the Helper Node.

---

## AI-Generated Multimedia Series (YouTube)

Architectural masterclasses, deep-dive podcasts, and focused technical video shorts for **Red Hat OpenShift 4.20** are hosted on the **[Nubenetes YouTube Channel (@nubenetes)](https://www.youtube.com/@nubenetes)**.

### 🎙️ Masterclasses & Architecture Deep Dives

| # | Masterclass Title | Architectural Scope & Core Modules | Lang | Duration | Action |
|:---:|:---|:---|:---:|:---:|:---:|
| **01** | [OpenShift 4.20 On-Premises Architecture: Bare Metal, VMware, Nutanix and Hyper-V](https://www.youtube.com/watch?v=RQ2AXSzGRzE) | **Platforms & Hypervisors**<br/>Bare metal, vSphere 8/9, Nutanix AHV, Hyper-V & multi-platform decision matrix | 🇺🇸 EN | `8:48` | [▶️ Watch](https://www.youtube.com/watch?v=RQ2AXSzGRzE) |
| **02** | [OpenShift 4.20 Topologies and Provisioning: SNO, Compact, HyperShift and ABI](https://www.youtube.com/watch?v=rSIj_iOT56o) | **Topologies & Provisioning**<br/>Single Node OpenShift (SNO), 3-node compact, HyperShift HCP & Agent-Based Installer | 🇺🇸 EN | `9:31` | [▶️ Watch](https://www.youtube.com/watch?v=rSIj_iOT56o) |
| **03** | [OpenShift 4.20 Disaster Recovery Guide: etcd Quorum Loss, OADP and Emergency Runbooks](https://www.youtube.com/watch?v=IdGKv4tPVH0) | **Disaster Recovery & Runbooks**<br/>etcd quorum loss recovery, OADP/Kopia backup drills & out-of-band cluster resurrection | 🇺🇸 EN | `7:45` | [▶️ Watch](https://www.youtube.com/watch?v=IdGKv4tPVH0) |
| **04** | [OpenShift 4.20 Day 0 Readiness: Air-Gapped Mirroring, DNS, NTP and Preflight Architecture](https://www.youtube.com/watch?v=h13w4e_Qx1U) | **Day 0 Preflight & Network**<br/>oc-mirror v2 OCI streaming, BIND9 DNS split-horizon, Chrony NTP & fio disk benchmarking | 🇺🇸 EN | `7:25` | [▶️ Watch](https://www.youtube.com/watch?v=h13w4e_Qx1U) |
| **05** | [OpenShift 4.20 Gateway API: Modernización de Ingress, HTTPRoute y Tráfico L4-L7](https://www.youtube.com/watch?v=hUSGPVtyidc) | **Modernización Ingress & Gateway API**<br/>Transición desde Ingress/Routes hacia Gateway API, roles desacoplados y Canary rollouts | 🇪🇸 ES | `6:06` | [▶️ Watch](https://www.youtube.com/watch?v=hUSGPVtyidc) |
| **06** | [Kubernetes Gateway API on OpenShift 4.20: Day 0 to Day 2 Ingress and Traffic Engineering](https://www.youtube.com/watch?v=GrCoDGJ8YiQ) | **Traffic Engineering & Routing**<br/>Gateway controller, HTTPRoute, GRPCRoute, TLSRoute, Kuadrant & ReferenceGrant security | 🇺🇸 EN | `9:47` | [▶️ Watch](https://www.youtube.com/watch?v=GrCoDGJ8YiQ) |
| **07** | [OpenShift 4.20 Day 1 Hardening: Custom Ingress PKI, Enterprise IdP, RBAC and MCPs](https://www.youtube.com/watch?v=E9eV9CHYYPE) | **Day 1 Post-Install & Hardening**<br/>ClusterOperators health, custom Ingress certs, OIDC/Keycloak IdP, RBAC lockdown & MCP tuning | 🇺🇸 EN | `6:30` | [▶️ Watch](https://www.youtube.com/watch?v=E9eV9CHYYPE) |
| **08** | [OpenShift 4.20 Day 2 Operations: Observability, GitOps, EUS Upgrades and OpenShift AI](https://www.youtube.com/watch?v=9MHiGiQcqH0) | **Day 2 Ops & Fleet Management**<br/>Thanos/LokiStack observability, GitOps App-of-Apps, EUS upgrades (4.18 to 4.20) & RHOAI GPU | 🇺🇸 EN | `6:44` | [▶️ Watch](https://www.youtube.com/watch?v=9MHiGiQcqH0) |
| **09** | [OpenShift 4.20 Agent-Based Installer: Bootstrap-in-Place, NMState and Rendezvous Node](https://www.youtube.com/watch?v=P1fjbXD2xbQ) | **Agent-Based Installer (ABI)**<br/>Bootstrap-in-Place on Node 0, static NMState networking, LACP bonding & Rendezvous host | 🇺🇸 EN | `6:32` | [▶️ Watch](https://www.youtube.com/watch?v=P1fjbXD2xbQ) |
| **10** | [OpenShift 4.20 Installer Guide: All Provisioning Scenarios, Topologies and Platforms](https://www.youtube.com/watch?v=btCpgLINTZM) | **Installer Scenarios & Platforms**<br/>Comparison of ABI, IPI, UPI & Assisted Installer across SNO, Compact, HA & HyperShift HCP | 🇺🇸 EN | `9:10` | [▶️ Watch](https://www.youtube.com/watch?v=btCpgLINTZM) |
| **11** | [Podcast Arquitectura OpenShift 4.20: Guía Completa Day 0 a Day 2 y Resiliencia](https://www.youtube.com/watch?v=zFRMP6N0-Aw) | **Podcast Arquitectónico (Audio)**<br/>Visión holística Day 0 a Day 2, topologías SNO/HA, ABI, etcd quorum y automatización | 🇪🇸 ES | `16:03` | [▶️ Watch](https://www.youtube.com/watch?v=zFRMP6N0-Aw) |
| **12** | [The OpenShift 4.20 Architecture Podcast: Complete Day 0 to Day 2 Enterprise Masterclass](https://www.youtube.com/watch?v=avJB3NqaEFg) | **Architecture Podcast (Audio)**<br/>Full 55-minute deep dive: platforms, ABI, Gateway API, hardening, DR & fleet ops | 🇺🇸 EN | `55:38` | [▶️ Watch](https://www.youtube.com/watch?v=avJB3NqaEFg) |
| **13** | [OpenShift 4.20 Native Observability: Prometheus, LokiStack, Tempo and Korrel8r](https://www.youtube.com/watch?v=wAcbEyMQ76M) | **Native Observability Stack**<br/>Prometheus/UWM, Vector + LokiStack 3.x, OpenTelemetry, TempoStack & Korrel8r COO | 🇺🇸 EN | `6:46` | [▶️ Watch](https://www.youtube.com/watch?v=wAcbEyMQ76M) |

### 🎬 Video Shorts Matrix

| # | Short Title | Architectural Domain & Focus | Audio | Duration | Action |
|:---:|:---|:---|:---:|:---:|:---:|
| **01** | [How Single-Member etcd Recovery Resurrects Dead OpenShift Clusters](https://www.youtube.com/shorts/_tAdfH_sNio) | **Emergency Recovery**<br/>Forced single-member quorum recovery, dead peer removal & API server restoration | 🇺🇸 EN | `1:15` | [▶️ Watch](https://www.youtube.com/shorts/_tAdfH_sNio) |
| **02** | [How OpenShift Agent-Based Installer Eliminates External Bootstrap VMs](https://www.youtube.com/shorts/qmU1J5WlNis) | **Bootstrap-in-Place ABI**<br/>In-memory temporary bootstrap controller on Node 0 via Discovery ISO | 🇺🇸 EN | `1:12` | [▶️ Watch](https://www.youtube.com/shorts/qmU1J5WlNis) |
| **03** | [Why Vanilla Velero Fails on OpenShift: The OADP Data Protection Architecture](https://www.youtube.com/shorts/Cmhxtb8cmKU) | **Data Protection & OADP**<br/>Security Context Constraints (SCC) awareness, CRD ordering & Kopia engine | 🇺🇸 EN | `1:23` | [▶️ Watch](https://www.youtube.com/shorts/Cmhxtb8cmKU) |
| **04** | [How Gateway API GRPCRoute Streams LLM Tokens Instantly on OpenShift](https://www.youtube.com/shorts/DwPHhPGrOt0) | **AI Inference & Ingress**<br/>HTTP/2 multiplexing, submillisecond token streaming & unbuffered AI inference | 🇺🇸 EN | `1:14` | [▶️ Watch](https://www.youtube.com/shorts/DwPHhPGrOt0) |
| **05** | [How TLSRoute Enables Zero-Trust SNI Passthrough on OpenShift](https://www.youtube.com/shorts/DkJQ4q0cetM) | **Zero-Trust Encryption**<br/>Layer 4 SNI header inspection without edge TLS termination or exposing private keys | 🇺🇸 EN | `1:20` | [▶️ Watch](https://www.youtube.com/shorts/DkJQ4q0cetM) |
| **06** | [How Gateway API HTTPRoute Replaces Fragile Ingress Annotations](https://www.youtube.com/shorts/g2z9-OSA_mU) | **Declarative Routing**<br/>Native percentage traffic splitting, path/header rewrites & granular status conditions | 🇺🇸 EN | `1:14` | [▶️ Watch](https://www.youtube.com/shorts/g2z9-OSA_mU) |
| **07** | [How OpenShift Automated Preflight Scripts Bulletproof Cluster Installations](https://www.youtube.com/shorts/UucLub-i270) | **Preflight & Readiness Automation**<br/>DNS resolution, fio disk latency benchmarks under 10ms & health validation | 🇺🇸 EN | `1:02` | [▶️ Watch](https://www.youtube.com/shorts/UucLub-i270) |
| **08** | [How to Automate OpenShift etcd Snapshots and Retention Policies with Bash](https://www.youtube.com/shorts/o0hq2INBw1E) | **Automated Backup & Retention**<br/>etcd snapshot db dumps, static pod manifest archiving & retention pruning | 🇺🇸 EN | `1:08` | [▶️ Watch](https://www.youtube.com/shorts/o0hq2INBw1E) |
| **09** | [How Emergency Scripts Resurrect Dead OpenShift Clusters After Quorum Failure](https://www.youtube.com/shorts/r2OhAxZU5gs) | **Emergency Quorum Restoration**<br/>Out-of-band single-member recovery, dead peer stripping & API server revival | 🇺🇸 EN | `1:25` | [▶️ Watch](https://www.youtube.com/shorts/r2OhAxZU5gs) |
| **10** | [How to Automate OpenShift Disaster Recovery Drills with OADP and Kopia](https://www.youtube.com/shorts/5Jkl6h7uOgA) | **Automated DR Verification Harness**<br/>Sandbox namespace restores, SCC validation, synthetic probes & RTO/RPO metrics | 🇺🇸 EN | `1:08` | [▶️ Watch](https://www.youtube.com/shorts/5Jkl6h7uOgA) |
| **11** | [How to Automate OpenShift Master Node Replacement Without Downtime](https://www.youtube.com/shorts/XgkB-eDbl_U) | **Node Lifecycle & Assisted Replacement**<br/>etcd member eviction, node cordon/drain/delete & CSR automated approval | 🇺🇸 EN | `0:58` | [▶️ Watch](https://www.youtube.com/shorts/XgkB-eDbl_U) |
| **12** | [How OpenShift Canary Upgrades Protect Workloads with Automated SLO Gates](https://www.youtube.com/shorts/gN_-IyABljE) | **Canary Upgrades & SLO Gating**<br/>Paused MCP rollout waves, pre-flight health checks & Thanos SLO gating | 🇺🇸 EN | `1:27` | [▶️ Watch](https://www.youtube.com/shorts/gN_-IyABljE) |
| **13** | [How to Survive OpenShift Air-Gapped Upgrades and Out-of-Band IPMI Recovery](https://www.youtube.com/shorts/CYX30kt1B_M) | **Air-Gapped & IPMI Hardware Lifeline**<br/>oc-mirror v2 local caching, offline staging & IPMI Serial-over-LAN console | 🇺🇸 EN | `1:04` | [▶️ Watch](https://www.youtube.com/shorts/CYX30kt1B_M) |
| **14** | [How OpenShift Automates 10,000 Edge Deployments with Zero-Touch Provisioning](https://www.youtube.com/shorts/duGGOLqLB-A) | **Zero-Touch Edge Automation**<br/>Declarative SiteConfigs, RHACM fleet orchestration & remote SNO bare metal deployment | 🇺🇸 EN | `1:30` | [▶️ Watch](https://www.youtube.com/shorts/duGGOLqLB-A) |
| **15** | [How OpenShift Agent-Based Installer Automates Bare Metal Installations](https://www.youtube.com/shorts/nhxRJz2dR8o) | **Bare Metal ABI Automation**<br/>Self-contained Discovery ISO, static NMState networking & PXE-free hardware discovery | 🇺🇸 EN | `1:17` | [▶️ Watch](https://www.youtube.com/shorts/nhxRJz2dR8o) |
| **16** | [How OpenShift Eliminates Bootstrap VMs with the Rendezvous Node Pattern](https://www.youtube.com/shorts/1_tlji_6oxk) | **Rendezvous Node Pattern**<br/>Node 0 in-memory live boot, temporary assisted-service & zero-leftover bootstrap pivot | 🇺🇸 EN | `1:14` | [▶️ Watch](https://www.youtube.com/shorts/1_tlji_6oxk) |
| **17** | [How OpenShift Replaced Fluentd with Vector and LokiStack for High-Speed Logging](https://www.youtube.com/shorts/EE_EMARHnb8) | **High-Speed Vector Logging**<br/>Rust-based Vector collector, ClusterLogForwarder pipelines & LokiStack 3.x S3 storage | 🇺🇸 EN | `1:22` | [▶️ Watch](https://www.youtube.com/shorts/EE_EMARHnb8) |
| **18** | [How OpenShift Prevents Metric Explosions in Prometheus and Thanos](https://www.youtube.com/shorts/8832jzvfc_Q) | **Metric Explosion Defense**<br/>User Workload Monitoring (UWM), sample limits & metricRelabelings cardinality control | 🇺🇸 EN | `1:16` | [▶️ Watch](https://www.youtube.com/shorts/8832jzvfc_Q) |
| **19** | [How Korrel8r Correlates Prometheus Metrics to Loki Logs and Tempo Traces](https://www.youtube.com/shorts/bffmO5yGGBA) | **Full-Stack COO Correlation**<br/>Cluster Observability Operator, Korrel8r graph rules & one-click drilldown in Web Console | 🇺🇸 EN | `1:24` | [▶️ Watch](https://www.youtube.com/shorts/bffmO5yGGBA) |
| **20** | [How Tail Based Sampling Filters Trace Data in OpenTelemetry and Tempo](https://www.youtube.com/shorts/28vd1iD0sDI) | **Tail-Based Trace Sampling**<br/>OpenTelemetry Collector in-memory buffering, 100% error capture & TempoStack ingestion | 🇺🇸 EN | `1:25` | [▶️ Watch](https://www.youtube.com/shorts/28vd1iD0sDI) |

*For complete technical breakdowns, copy-paste ready descriptions, and YouTube Studio links, see [Section: Video Walkthroughs & Architecture References](#video-walkthroughs--architecture-references-youtube).*

---

## Table of Contents

- [Enterprise OpenShift 4.20: The Day 0 to Day 2 Operational Blueprint](#enterprise-openshift-420-the-day-0-to-day-2-operational-blueprint)
- [AI-Generated Multimedia Series (YouTube)](#ai-generated-multimedia-series-youtube)
- [Video Walkthroughs & Architecture References (YouTube)](#video-walkthroughs--architecture-references-youtube)
- [Executive Architecture Summary](#executive-architecture-summary)
- [Master Architecture Decision Tree](#master-architecture-decision-tree)
  - [Visual ASCII Decision Routing Tree](#visual-ascii-routing-tree)
  - [Architecture Decision Criteria & Technical Specifications](#architecture-decision-criteria--technical-specifications)
    - [Section 1: Public Cloud Deployments (AWS, Azure, GCP, OCI)](#section-1-public-cloud-deployments-aws-azure-gcp-oci)
      - [1. Cloud IPI (Installer-Provisioned Infrastructure)](#cloud-ipi)
      - [2. Cloud UPI (User-Provisioned Infrastructure)](#cloud-upi)
      - [Public Cloud Provisioning Model Comparison Matrix](#cloud-comparison-matrix)
    - [Section 2: Edge & Distributed Deployment Topologies](#section-2-edge--distributed-deployment-topologies)
      - [1. Single Node OpenShift (SNO)](#sno-single-node)
      - [2. 3-Node Compact Converged](#compact-3-node)
      - [3. Remote Worker Nodes (WAN)](#remote-workers-wan)
      - [4. Zero Touch Provisioning (ZTP) at Scale](#ztp-acm-gitops)
      - [5. Hosted Control Planes / HyperShift (HCP)](#hypershift-hosted-cp)
    - [Section 3: On-Premises Datacenter Platforms](#section-3-on-premises-datacenter-platforms)
      - [1. Physical Bare Metal](#bare-metal-physical)
      - [2. VMware vSphere (8.x / 9.x)](#vmware-vsphere)
      - [3. Nutanix AHV HCI](#nutanix-ahv)
      - [4. KVM & RHOSO (Red Hat OpenStack Services on OpenShift)](#kvm-openstack)
      - [5. Microsoft Hyper-V / Azure Stack HCI](#microsoft-hyper-v)
    - [Section 4: Network Isolation & Connectivity Paradigms](#section-4-network-isolation--connectivity-paradigms)
      - [1. Fully Connected Network](#network-fully-connected)
      - [2. Proxy-Restricted Enterprise Network](#network-proxy-restricted)
      - [3. Air-Gapped / Disconnected Dark Site Network](#network-air-gapped)
  - [Graphical Mermaid Flowchart](#graphical-mermaid-flowchart)
- [Master Deployment & Architecture Matrix](#master-deployment--architecture-matrix)
- [Repository Directory Structure & Architectural File Map](#repository-directory-structure--architectural-file-map)
  - [High-Level Directory Tree](#high-level-directory-tree)
  - [Architectural Component Breakdown](#architectural-component-breakdown)
  - [Lifecycle Alignment Matrix (Day 0, Day 1, Day 2)](#lifecycle-alignment-matrix-day-0-day-1-day-2)
- [Complete End-to-End Master Implementation Workflow (Ordered Step-by-Step)](#complete-end-to-end-master-implementation-workflow-ordered-step-by-step)
  - [Step 1: Preflight Infrastructure & Network Validation](#step-1-preflight-infrastructure--network-validation)
  - [Step 2: Helper Node / Bastion Service Deployment](#step-2-helper-node--bastion-service-deployment)
  - [Step 3: Declarative Configuration Definition](#step-3-declarative-configuration-definition)
  - [Step 4: Installation Media Generation & Boot](#step-4-installation-media-generation--boot)
  - [Step 5: Bootstrap-in-Place & Cluster Convergence](#step-5-bootstrap-in-place--cluster-convergence)
  - [Step 6: Day 1 Ingress TLS & Identity Federation](#step-6-day-1-ingress-tls--identity-federation)
  - [Step 7: MachineConfigPool Hardening & Storage Provisioning](#step-7-machineconfigpool-hardening--storage-provisioning)
  - [Step 8: GitOps Foundation & Secret Management](#step-8-gitops-foundation--secret-management)
  - [Step 9: Observability, Compliance & Backup Encampment](#step-9-observability-compliance--backup-encampment)
  - [Step 10: Automated Lifecycle & Upgrade Orchestration](#step-10-automated-lifecycle--upgrade-orchestration)
- [Complete Documentation Index](#complete-documentation-index)
  - [01. Architecture & Cluster Topologies](#01-architecture--cluster-topologies)
    - [Single Node OpenShift (SNO)](docs/01-architecture-topologies/01-sno-single-node.md)
    - [3-Node Compact Converged](docs/01-architecture-topologies/02-compact-3-node-converged.md)
    - [Standard Multi-Node HA](docs/01-architecture-topologies/03-standard-ha-multinode.md)
    - [Remote Worker Nodes over WAN](docs/01-architecture-topologies/04-remote-workers-wan.md)
    - [Hosted Control Planes (HyperShift)](docs/01-architecture-topologies/05-hypershift-hosted-cp.md)
  - [02. Provisioning Paradigms](#02-provisioning-paradigms)
    - [Agent-Based Installer (ABI)](docs/02-provisioning-paradigms/01-agent-based-installer.md)
    - [Installer Provisioned Infrastructure (IPI)](docs/02-provisioning-paradigms/02-installer-provisioned-ipi.md)
    - [User Provisioned Infrastructure (UPI)](docs/02-provisioning-paradigms/03-user-provisioned-upi.md)
    - [Zero Touch Provisioning (ZTP)](docs/02-provisioning-paradigms/04-ztp-acm-gitops.md)
  - [03. Network Architecture & Connectivity](#03-network-architecture--connectivity)
    - [Connected with Corporate Proxies](docs/03-network-and-connectivity/01-connected-with-proxies.md)
    - [Air-Gapped Disconnected Deployments (`oc-mirror` v2)](docs/03-network-and-connectivity/02-air-gapped-oc-mirror-v2.md)
    - [Air-Gapped Core Services](docs/03-network-and-connectivity/03-air-gapped-core-services.md)
    - [OVN-Kubernetes Tuning](docs/03-network-and-connectivity/04-ovn-kubernetes-tuning.md)
    - [Kubernetes Gateway API Architecture](docs/03-network-and-connectivity/05-gateway-api-architecture.md)
  - [04. Platform Specific Deployment Guides](#04-platform-specific-deployment-guides)
    - [Bare Metal Physical Hardware](docs/04-platforms/01-bare-metal-physical.md)
    - [VMware vSphere 8.x / 9.x](docs/04-platforms/02-vmware-vsphere.md)
    - [Nutanix AHV](docs/04-platforms/03-nutanix-ahv.md)
    - [KVM & OpenStack (RHOSO)](docs/04-platforms/04-kvm-openstack.md)
    - [Amazon Web Services (AWS)](docs/04-platforms/05-aws.md)
    - [Microsoft Azure](docs/04-platforms/06-azure.md)
    - [Google Cloud Platform (GCP)](docs/04-platforms/07-gcp.md)
    - [Microsoft Hyper-V & Azure Stack HCI](docs/04-platforms/08-microsoft-hyper-v.md)
    - [OpenShift Virtualization (KubeVirt & MTV)](docs/04-platforms/09-openshift-virtualization.md)
  - [05. Day 0 Infrastructure Readiness](#05-day-0-infrastructure-readiness)
    - [Hardware & Capacity Sizing](docs/05-day0-readiness/01-hardware-and-sizing.md)
    - [DNS & Load Balancing Matrix](docs/05-day0-readiness/02-dns-loadbalancer-matrix.md)
    - [Storage Architecture & ODF](docs/05-day0-readiness/03-storage-architecture-odf.md)
    - [Helper Node Architecture & Engineering](docs/05-day0-readiness/04-helper-node-architecture.md)
  - [06. Day 1 Post-Install Hardening](#06-day-1-post-install-hardening)
    - [Cluster Operator Verification](docs/06-day1-baselining/01-cluster-operator-hardening.md)
    - [Ingress & Custom Certificates](docs/06-day1-baselining/02-ingress-and-custom-certs.md)
    - [Identity Providers & RBAC Hardening](docs/06-day1-baselining/03-identity-providers-rbac.md)
    - [MachineConfigPools & Node Tuning](docs/06-day1-baselining/04-machineconfigpools-tuning.md)
    - [Secrets & Automated Certificate Rotation](docs/06-day1-baselining/05-secrets-and-cert-rotation.md)
  - [07. Day 2 Operations & Lifecycle](#07-day-2-operations--lifecycle)
    - [Enterprise Observability Stack](docs/07-day2-operations/01-observability-stack.md)
    - [Security & Compliance](docs/07-day2-operations/02-security-and-compliance.md)
    - [GitOps Foundation](docs/07-day2-operations/03-gitops-foundation.md)
    - [Cluster Lifecycle & Upgrades](docs/07-day2-operations/04-lifecycle-and-upgrades.md)
    - [Automated Upgrades & Pre-Upgrade Mandates](docs/07-day2-operations/05-automated-upgrades.md)
    - [GitOps App-of-Apps & Configuration Drift Management](docs/07-day2-operations/06-gitops-app-of-apps.md)
    - [Enterprise AI & GPU Acceleration (RHOAI & vLLM)](docs/07-day2-operations/07-openshift-ai-gpu.md)
  - [08. Disaster Recovery, Backup & GitOps Rebuild](#08-disaster-recovery-backup--gitops-rebuild)
    - [etcd Backup, Recovery & Quorum Loss](docs/08-backup-dr-and-rebuild/01-etcd-backup-restore.md)
    - [OADP vs Vanilla Velero Deep-Dive](docs/08-backup-dr-and-rebuild/02-oadp-vs-velero-deepdive.md)
    - [Metro-DR & Regional-DR Multi-Cluster](docs/08-backup-dr-and-rebuild/03-metro-dr-and-regional-dr.md)
    - [Declarative GitOps Rebuild from Scratch](docs/08-backup-dr-and-rebuild/04-declarative-rebuild-gitops.md)
  - [09. Emergency Runbooks & Disaster Troubleshooting](#09-emergency-runbooks--disaster-troubleshooting)
    - [Expired Certificates Recovery](docs/09-emergency-runbooks/01-expired-certs-recovery.md)
    - [Helper Node Emergency Access & Jumping](docs/09-emergency-runbooks/02-helper-node-access-and-jumping.md)
    - [Node Reinstallation & Replacement](docs/09-emergency-runbooks/03-node-reinstallation-and-replacement.md)
    - [etcd Quorum Loss Recovery](docs/09-emergency-runbooks/04-etcd-quorum-loss-recovery.md)
    - [MachineConfig & Storage Recovery](docs/09-emergency-runbooks/05-machineconfig-and-storage-recovery.md)
- [Production Automation Scripts & Manifests](#production-automation-scripts--manifests)
  - [Shell Scripts (`scripts/`)](#shell-scripts-scripts)
    - [`preflight-check.sh`](scripts/preflight-check.sh) - Preflight DNS, NTP, and Network Connectivity Auditor
    - [`generate-agent-iso.sh`](scripts/generate-agent-iso.sh) - Agent-Based Installer Boot ISO Generator
    - [`mirror-ocp420-airgap.sh`](scripts/mirror-ocp420-airgap.sh) - `oc-mirror` v2 Disconnected Registry Mirroring
    - [`etcd-backup.sh`](scripts/etcd-backup.sh) - Automated Control Plane etcd Snapshot & Retention Engine
    - [`validate-cluster-health.sh`](scripts/validate-cluster-health.sh) - ClusterOperator & Infrastructure Health Auditor
    - [`deploy-hyperv-vms.ps1`](scripts/deploy-hyperv-vms.ps1) - Automated PowerShell Gen 2 Hyper-V VM Deployment
    - [`pre-upgrade-health-check.sh`](scripts/pre-upgrade-health-check.sh) - Pre-Upgrade Health & etcd Freshness Gating
    - [`automated-cluster-upgrade.sh`](scripts/automated-cluster-upgrade.sh) - Canary MCP-Gated Upgrade Orchestrator
    - [`airgap-upgrade.sh`](scripts/airgap-upgrade.sh) - Disconnected oc-mirror v2 Release Upgrade Orchestrator
    - [`test-oadp-restore.sh`](scripts/test-oadp-restore.sh) - Automated DR Verification & Restore Drill Engine
    - [`recover-expired-certs.sh`](scripts/recover-expired-certs.sh) - Helper Node Expired Certificates Recovery Engine
    - [`helper-ssh-jump.sh`](scripts/helper-ssh-jump.sh) - Out-of-Band SSH Jump & IPMI SOL Console Tool
    - [`replace-control-plane-node.sh`](scripts/replace-control-plane-node.sh) - Control Plane Master Node Replacement Assistant
    - [`reinstall-worker-node.sh`](scripts/reinstall-worker-node.sh) - Worker & Infra Node Drain and Reinstallation Engine
    - [`emergency-etcd-single-member.sh`](scripts/emergency-etcd-single-member.sh) - Single-Member etcd Quorum Recovery Tool
  - [Production Manifests (`configs/`)](#production-manifests-configs)
    - [Agent-Based Installer (`configs/agent-based/`)](configs/agent-based/)
    - [Public Cloud IPI (`configs/ipi-cloud/`)](configs/ipi-cloud/)
    - [Virtualization UPI (`configs/upi-vsphere/`)](configs/upi-vsphere/)
    - [Air-Gapped & Registry (`configs/airgap/`)](configs/airgap/)
    - [Kubernetes Gateway API (`configs/gateway-api/`)](configs/gateway-api/)
    - [Day 1 Baselining & Hardening (`configs/day1/`)](configs/day1/)
    - [Day 2 Operations & DR (`configs/day2/`)](configs/day2/)
    - [GitOps App-of-Apps (`configs/gitops/`)](configs/gitops/)
    - [Security & Certificate Management (`configs/security/`)](configs/security/)
    - [OpenShift Virtualization (`configs/virt/`)](configs/virt/)
    - [Enterprise AI & GPU Acceleration (`configs/ai/`)](configs/ai/)
    - [Helper Node Configurations (`configs/helper-node/`)](configs/helper-node/)
- [Technical Deep-Dive: The Velero Question](#technical-deep-dive-the-velero-question)
  - [Why Vanilla Velero Fails on OpenShift:](#why-vanilla-velero-fails-on-openshift)
- [Classified Real References & External Standards (September 2026)](#classified-real-references--external-standards-september-2026)
  - [1. Official Red Hat Product Documentation & Architecture](#1-official-red-hat-product-documentation--architecture)
  - [2. Red Hat Knowledgebase (KCS) & Solution Blueprints](#2-red-hat-knowledgebase-kcs--solution-blueprints)
  - [3. Open Source Upstream & Core Tooling Repositories](#3-open-source-upstream--core-tooling-repositories)
  - [4. Enterprise Security, Benchmarks & Compliance](#4-enterprise-security-benchmarks--compliance)
  - [5. Infrastructure Vendor Reference Guides](#5-infrastructure-vendor-reference-guides)
- [License](#license)
---

## Executive Architecture Summary

By **September/October 2026**, Red Hat OpenShift Container Platform 4.20 establishes the enterprise industry standard for mission-critical hybrid cloud infrastructure, modernized virtualization, and private AI compute.

This repository codifies the modern architectural paradigms, enterprise design decisions, and operational standards that define an enterprise-grade OpenShift 4.20 deployment:

> [!TIP]
> **Visual Blueprint Reference**: For an overarching visual synthesis of all Day 0, Day 1, and Day 2 architectural decisions, see the [Enterprise Operational Blueprint Infographic](#enterprise-openshift-420-the-day-0-to-day-2-operational-blueprint) above.

### 1. Provisioning Modernization & Media Engineering
* **Bootstrap-in-Place Standard**: The **Agent-Based Installer (ABI)** replaces legacy User-Provisioned Infrastructure (UPI) for on-premises bare-metal, VMware vSphere 8/9, and Nutanix AHV. ABI eliminates external temporary bootstrap virtual machines by leveraging an ephemeral Assisted Service on a designated **Rendezvous Node** (`master-0`), booting directly into RHCOS and converting into permanent control plane quorum.
* **Declarative Host Customization**: Static NMState networking, LACP bonding (802.3ad), MTU 9000 jumbo frames, and storage disk partition layouts are embedded directly into discovery media via declarative `agent-config.yaml` manifests.
* **Cloud-Native IPI with Keyless IAM**: Public cloud deployments (AWS, Azure, GCP) standardize on Installer-Provisioned Infrastructure (IPI) with private VPCs/VNets and **Keyless Workload Identity** (AWS STS with IRSA, Azure Workload Identity Federation, GCP Workload Identity), strictly eliminating permanent long-lived IAM access keys.
* **Large-Scale Fleet Zero Touch Provisioning (ZTP)**: Edge and distributed far-edge deployments utilize **Advanced Cluster Management (ACM 2.12+)** and **Topology Aware Lifecycle Manager (TALM)** to provision 10,000+ Single Node OpenShift (SNO) sites via declarative `SiteConfig` CRDs and GitOps.

### 2. Next-Generation Air-Gapped & Disconnected Architecture
* **Standardization on `oc-mirror` v2**: Deprecates legacy `oc-mirror` v1 in favor of the high-performance v2 architecture utilizing declarative `ImageSetConfiguration` v2, OCI file-based streaming catalogs, and ephemeral local caching to slash mirror sync windows by over 70%.
* **Declarative Cluster Mirror Routing**: Disconnected clusters consume local Quay or Harbor registries via Kubernetes-native `ImageDigestMirrorSet` (IDMS) and `ImageTagMirrorSet` (ITMS) Custom Resources, replacing legacy `ImageContentSourcePolicy` (ICSP).
* **Helper Node / Bastion Engineering**: In air-gapped and restricted on-prem environments, a dedicated Linux Helper Node provides essential authoritative split-horizon BIND9 DNS, Keepalived/HAProxy Layer 4 load balancing for API (6443) and Ingress (80/443), and Stratum Chrony NTP clock synchronization (<500ms jitter).

### 3. Software-Defined Storage & Unified Data Fabric
* **OpenShift Data Foundation (ODF 4.16+)**: Multi-tenant, enterprise software-defined Ceph storage natively integrated via the Rook-Ceph operator.
* **Tri-Modal Storage Services**:
  * **Block (Ceph RBD)**: Sub-millisecond `ReadWriteOnce` storage for transactional databases, etcd, and virtual machine disks.
  * **Shared Filesystem (CephFS)**: POSIX-compliant `ReadWriteMany` shared storage for enterprise application pipelines and shared datasets.
  * **Object Storage (Ceph RGW)**: S3-compatible multi-cloud object storage supporting OADP backups, container registries, and AI model checkpoints.
* **Preflight Disk IOPS Validation**: Mandatory automated benchmarking verifying control plane disk write latency (`fdatasync` < 10ms at 99th percentile) via `fio` to prevent etcd quorum collapse.

### 4. Enterprise Identity, PKI & Secrets Governance
* **Zero-Trust Identity Federation**: Default `self-provisioner` role revoked and temporary `kubeadmin` account permanently decommissioned. Authentication federated to enterprise Identity Providers (Keycloak, Microsoft Entra ID, Okta) via OpenID Connect (OIDC) with fine-grained RBAC cluster role bindings.
* **Automated Certificate Lifecycle (cert-manager)**: Red Hat cert-manager deployed to automate the issuance, validation, and renewal of Ingress wildcard TLS certificates, internal routes, and mutual TLS (mTLS) services using HashiCorp Vault PKI or ACME/Let's Encrypt `ClusterIssuers`.
* **External Secrets Operator (ESO)**: Secure secret hydration from centralized enterprise secret stores (HashiCorp Vault, AWS Secrets Manager, Azure Key Vault). Secrets are never committed to Git; instead, `ExternalSecret` custom resources continuously reconcile and inject native Kubernetes `Secrets` dynamically.

### 5. Autonomous GitOps App-of-Apps & Drift Management
* **Declarative Cluster Desired State**: The entire cluster lifecycle—from operators to storage, networking, security policies, and application workloads—is managed declaratively in Git via **Red Hat OpenShift GitOps (Argo CD 3.5+)**.
* **Root App-of-Apps Architecture**: A single root Argo CD Application coordinates all subordinate configuration applications using deterministic **Sync Waves** (Phase 1: Operators -> Phase 2: CRDs -> Phase 3: Storage/Security -> Phase 4: Workloads).
* **Automated Drift Self-Healing**: Continuous drift detection with active remediation (`selfHeal: true`, `prune: true`) guarantees that unauthorized manual out-of-band changes applied via CLI are automatically overwritten back to the audited Git state within seconds.

### 6. Modernized Unified Virtualization (OpenShift Virtualization & MTV)
* **KubeVirt Hypervisor Convergence**: Legacy enterprise virtual machines (RHEL 8/9, Windows Server 2022/2025) run side-by-side with containerized microservices on bare-metal OpenShift, eliminating redundant virtualization infrastructure and hypervisor licensing costs.
* **Enterprise VM Capabilities**: High-performance VM storage via ODF Ceph RBD, automated live migration over dedicated secondary migration networks, Cloud-Init provisioning, and containerdisk containerized OS boot.
* **Automated Migration Engine (MTV 2.8+)**: **Migration Toolkit for Virtualization (Forklift)** automates bulk cold and warm live migrations from VMware vSphere 7/8/9 with automated VM guest OS disk conversion and network mapping.

### 7. Enterprise AI Infrastructure & High-Throughput Model Serving
* **Accelerated GPU Compute**: Automated GPU driver compilation, CUDA runtime injection, and DCGM monitoring via the **NVIDIA GPU Operator 24.x**. Support for both dynamic Time-Slicing (for lightweight dev/test sharing) and hardware-level Multi-Instance GPU (**MIG**) slicing for strict hardware workload isolation.
* **Red Hat OpenShift AI (RHOAI 2.16+)**: Unified MLOps platform orchestrating distributed model training, data science pipelines (Kubeflow Pipelines, Ray, CodeFlare), and advanced workload queue management via Kueue.
* **High-Throughput Private LLM Serving**: Deployment of optimized **vLLM ServingRuntime** supporting PagedAttention, continuous batching, and tensor parallelism for self-hosted, private Large Language Models (Mistral, LLaMA-3, DeepSeek) exposing standard OpenAI-compatible REST APIs.

### 8. Telemetry-Gated Canary Lifecycle & Upgrade Orchestration
* **Non-Negotiable Pre-Upgrade Safeguards**: Mandatory preflight health checks enforcing 100% healthy ClusterOperators, zero active alerts, deprecated API validation (`apirequestcounts`), and verified etcd snapshot freshness (<24 hours) prior to initiating cluster upgrades.
* **Paused MachineConfigPool Canary Rollouts**: Upgrades decouple control plane rollout from worker node updates. The worker pool is paused (`spec.paused: true`) to prevent simultaneous node drain and reboot storms across the cluster.
* **Prometheus / Thanos SLO Telemetry Gating**: Upgrades to worker nodes proceed sequentially through a canary pool. Automated scripts evaluate Thanos Querier telemetry—gating the rollout based on HTTP 5xx ingress error rates (<2.0%) and container crashloop restart rates (<25 in 5m) during soak periods before unpausing the fleet.

### 9. Enterprise Data Protection & Continuous Disaster Recovery
* **The Velero Verdict (Why Vanilla Velero Fails)**: Vanilla upstream Velero critically fails on OpenShift due to Security Context Constraints (SCC) denial on host filesystems, inability to preserve OpenShift-proprietary API groups (`route.openshift.io`, `security.openshift.io`), and static UID/GID corruption.
* **The Supported Standard**: Strict enterprise enforcement of **Red Hat OADP (OpenShift API for Data Protection) 1.4+** with **Kopia** data-movers, native CSI volume snapshotting, and S3-compatible cloud/ODF object storage targets.
* **Continuous Automated DR Verification**: Continuous validation of backup integrity using the automated drill harness (`scripts/test-oadp-restore.sh`), deploying canary stateful workloads, taking on-demand snapshots, simulating catastrophic namespace deletion, executing OADP restore, and auditing data checksum integrity.
* **Multi-Cluster DR Topologies**: Architectural implementation of **Metro-DR** (synchronous Ceph mirroring, RPO=0, RTO<5m over <10ms latency links) and **Regional-DR** (asynchronous replication, RPO<5m over WAN) orchestrated by ACM.

### 10. Out-of-Band Emergency Triage & API-Less Recovery
* **Resurrecting Expired Disconnected Clusters**: Dedicated procedural runbooks and automation scripts to recover clusters where kubelet client certificates expired after prolonged shutdowns (>30 days / 1 year) directly from the **Helper Node** via SSH, bypassing dead API servers to purge lockfiles, restore bootstrap credentials, and approve node CSRs.
* **Catastrophic etcd Quorum Recovery**: Automated recovery procedures to rescue clusters from 2-of-3 master failures by forcing surviving control plane nodes into a single-member etcd cluster leader, restoring API server operations, and sequentially reintegrating new masters.
* **Out-of-Band Bastion Jumping**: Intelligent SSH jump tools with automated SSH key discovery and direct Serial-Over-LAN (SOL) IPMI/Redfish console fallback for headless hardware debugging when Kubernetes networking is inoperative.

### 11. Modern L4/L7 Traffic Management & Kubernetes Gateway API Standard
* **Decoupled Role-Oriented Ingress**: Superseding legacy host-centric OpenShift `Route` resources with the **Kubernetes Gateway API (`gateway.networking.k8s.io`)** to enforce strict separation of duties between Platform Operators (`GatewayClass`), Cluster SREs (`Gateway`), and Application Developers (`HTTPRoute`, `GRPCRoute`, `TLSRoute`).
* **Production Envoy Engine**: Backed by high-performance dynamic Envoy proxy instances managed by the OpenShift Ingress Operator and native **Red Hat OpenShift Service Mesh 3.x (OSSM 3.0 / Istio)**.
* **Native Weighted Canary Traffic Splitting**: Declarative percentage-based traffic shifts (e.g. 90% production / 10% canary) and header-based overrides directly within `HTTPRoute` rules without third-party annotations.
* **gRPC Streaming for AI & SNI Passthrough for VMs**: Native `GRPCRoute` enabling unbuffered token streaming for **vLLM / RHOAI** Large Language Models, and `TLSRoute` delivering zero-overhead L4 SNI passthrough routing directly to **OpenShift Virtualization** guest VMs.

---

## Master Architecture Decision Tree

<a id="visual-ascii-routing-tree"></a>
Use this deterministic ASCII decision tree to determine the optimal installation method, cluster footprint, platform configuration, and networking mode with full text and zero truncation:

```text
========================================================================================================================
                                    OPENSHIFT 4.20 MASTER ARCHITECTURE DECISION TREE                                    
========================================================================================================================

                               [ Target Infrastructure Environment? ]
                                                  │
          ┌───────────────────────────────────────┼───────────────────────────────────────┐
          │                                       │                                       │
          ▼                                       ▼                                       ▼
 ┌──────────────────┐                    ┌──────────────────┐                    ┌──────────────────┐
 │ 1. Public Cloud  │                    │ 2. Edge & Distr. │                    │ 3. On-Premises   │
 │    Deployments   │                    │    Topologies    │                    │    Datacenter    │
 └────────┬─────────┘                    └────────┬─────────┘                    └────────┬─────────┘
          │                                       │                                       │
          ▼                                       ▼                                       ▼
[ Cloud Security & IAM? ]            [ Edge Topology & Scale? ]               [ Datacenter Platform? ]
          │                                       │                                       │
          ├─► Cloud IPI (Automated)               ├─► 1 Node: SNO (Single Node)           ├─► Bare Metal (ABI / Redfish)
          │   (AWS / Azure / GCP / OCI)           ├─► 3 Nodes: Compact Converged HA       ├─► VMware vSphere (8.x / 9.x)
          │                                       ├─► Fleet Scale: ZTP via ACM 2.12+      ├─► Nutanix AHV HCI
          └─► Cloud UPI (Enterprise VPC)          ├─► Central + WAN: Remote Workers       ├─► KVM / OpenStack (RHOSO)
              (Manual Subnets & SecOps)           └─► Multi-Tenant: HyperShift (HCP)      └─► Microsoft Hyper-V / HCI
                                                  │
                                                  ▼
                                   [ Network Connectivity Mode? ]
                                                  │
          ┌───────────────────────────────────────┼───────────────────────────────────────┐
          │                                       │                                       │
          ▼                                       ▼                                       ▼
 ┌──────────────────┐                    ┌──────────────────┐                    ┌──────────────────┐
 │ Fully Connected  │                    │ Proxy-Restricted │                    │ Air-Gapped / Dark│
 │ Direct Internet  │                    │ Corporate Egress │                    │ Disconnected Site│
 │ Red Hat CDN Sync │                    │ Proxy + CA MITM  │                    │ oc-mirror v2 Pull│
 └──────────────────┘                    └──────────────────┘                    └──────────────────┘
```

### Architecture Decision Criteria & Technical Specifications

#### Section 1: Public Cloud Deployments (AWS, Azure, GCP, OCI)

<a id="cloud-ipi"></a>
- **1. Cloud IPI (Installer-Provisioned Infrastructure)**
  - **Mechanism**: Fully automated end-to-end installation and cloud infrastructure lifecycle.
  - **Target Clouds**: AWS, Azure, Google Cloud (GCP), Oracle Cloud Infrastructure (OCI).
  - **Cloud Infrastructure**: Dynamic VPC/VNet, private subnets, NAT gateways, route tables, and internal/external NLB/ALB load balancers.
  - **Authentication & IAM**: Manual STS (AWS), Azure Workload Identity, or GCP Workload Identity Federation (keyless authentication).
  - **Ingress & API**: Public internet-facing or private (`publish: Internal`) for zero-public-IP enterprise topologies.
  - **Compute Scaling**: Automated MachineSets dynamically provision, scale, and heal worker node instances.
  - **Architecture & Guide**: [`docs/02-provisioning-paradigms/02-installer-provisioned-ipi.md`](docs/02-provisioning-paradigms/02-installer-provisioned-ipi.md) • Cloud Guides: [AWS](docs/04-platforms/05-aws.md) | [Azure](docs/04-platforms/06-azure.md) | [GCP](docs/04-platforms/07-gcp.md)

<a id="cloud-upi"></a>
- **2. Cloud UPI (User-Provisioned Infrastructure)**
  - **Mechanism**: User, Security, or Terraform pre-provisioned cloud infrastructure.
  - **Target Clouds**: AWS, Azure, Google Cloud (GCP), Oracle Cloud Infrastructure (OCI).
  - **Cloud Infrastructure**: Cluster deployed into pre-existing enterprise VPC/VNet with strict SecOps firewalls and shared subnets.
  - **Authentication & IAM**: Cloud Credential Operator Manual mode with `ccoctl` pre-generating IAM roles and permissions.
  - **Ingress & API**: Pre-allocated internal load balancers, enterprise transit gateways, and custom DNS zones.
  - **Compute Scaling**: Semi-automated MachineSets or custom enterprise Infrastructure-as-Code (Terraform / Ansible).
  - **Architecture & Guide**: [`docs/02-provisioning-paradigms/03-user-provisioned-upi.md`](docs/02-provisioning-paradigms/03-user-provisioned-upi.md) • Cloud Guides: [AWS](docs/04-platforms/05-aws.md) | [Azure](docs/04-platforms/06-azure.md) | [GCP](docs/04-platforms/07-gcp.md)

<a id="cloud-comparison-matrix"></a>
| Provisioning Model | Key Characteristics & Architecture | Authentication & Governance | Primary Use Case & Documentation |
| :--- | :--- | :--- | :--- |
| **Cloud IPI** *(Installer-Provisioned)* | • **Fully automated** end-to-end cloud infrastructure creation<br/>• Dynamic VPC/VNet, private subnets, route tables, and internal/external LBs<br/>• Automated MachineSets dynamically manage worker compute lifecycle | • **Keyless IAM**: AWS STS with IRSA, Azure Workload Identity, GCP Workload Identity Federation<br/>• Supports `publish: Internal` for zero-public-IP private clusters | **Standard Enterprise Cloud**<br/>👉 [`docs/02-provisioning-paradigms/02-installer-provisioned-ipi.md`](docs/02-provisioning-paradigms/02-installer-provisioned-ipi.md)<br/>• Cloud Guides: [AWS](docs/04-platforms/05-aws.md) \| [Azure](docs/04-platforms/06-azure.md) \| [GCP](docs/04-platforms/07-gcp.md) |
| **Cloud UPI** *(User-Provisioned)* | • Deployed into **existing enterprise VPC / VNet**<br/>• Pre-created subnets, corporate firewalls, custom route tables & NAT gateways<br/>• Semi-automated MachineSets or Terraform/IaC-managed instances | • **Manual IAM**: Cloud Credential Operator in Manual mode with `ccoctl` CLI<br/>• Dedicated enterprise transit gateways, ExpressRoute, and private DNS | **Strict SecOps & Shared VPC**<br/>👉 [`docs/02-provisioning-paradigms/03-user-provisioned-upi.md`](docs/02-provisioning-paradigms/03-user-provisioned-upi.md)<br/>• Cloud Guides: [AWS](docs/04-platforms/05-aws.md) \| [Azure](docs/04-platforms/06-azure.md) \| [GCP](docs/04-platforms/07-gcp.md) |

#### Section 2: Edge & Distributed Deployment Topologies

<a id="sno-single-node"></a>
- **1. Single Node OpenShift (SNO)** `[1 Physical or Virtual Host]`
  - **Footprint**: Collocated master control plane and application workloads on a single node (minimum 8 vCPU, 16–32 GB RAM, 120 GB SSD/NVMe).
  - **Operational Profile**: Zero control plane overhead; autonomous agent ISO boot; continues operation during prolonged upstream WAN loss.
  - **Target Scenarios**: Cell towers, retail branch kiosks, far-edge IoT gateways, remote defense/medical field equipment.
  - **Documentation**: [`docs/01-architecture-topologies/01-sno-single-node.md`](docs/01-architecture-topologies/01-sno-single-node.md)

<a id="compact-3-node"></a>
- **2. 3-Node Compact Converged** `[3 Schedulable Master Nodes]`
  - **Footprint**: Full 3-node etcd Raft quorum; masters run compute workloads without dedicated workers (`mastersSchedulable: true`).
  - **Storage Architecture**: Collocated OpenShift Data Foundation (ODF) 3-node Ceph storage providing HA persistent block and file storage.
  - **Resiliency**: Survives the loss of any single physical node without application or persistent data service interruption.
  - **Target Scenarios**: Medium branch offices, ROBO sites, space/power-constrained server rooms, edge micro-datacenters.
  - **Documentation**: [`docs/01-architecture-topologies/02-compact-3-node-converged.md`](docs/01-architecture-topologies/02-compact-3-node-converged.md)

<a id="remote-workers-wan"></a>
- **3. Remote Worker Nodes** `[Central Core Control Plane + Distributed WAN Edge Workers]`
  - **Footprint**: Central 3-node HA control plane hosted in core datacenter; worker nodes deployed at remote edge sites over WAN.
  - **Tuning**: Tuned Kubelet heartbeats (`node-status-update-frequency: 10s`) and resilient pod eviction tolerances for WAN blips.
  - **Cost Profile**: Eliminates dedicated control plane hardware and licensing costs at distributed edge facilities.
  - **Target Scenarios**: Smart factories, distribution warehouses, connected hospital networks, intelligent retail outlets.
  - **Documentation**: [`docs/01-architecture-topologies/04-remote-workers-wan.md`](docs/01-architecture-topologies/04-remote-workers-wan.md)

<a id="ztp-acm-gitops"></a>
- **4. Zero Touch Provisioning (ZTP) at Scale** `[Fleet Automation via ACM 2.12+ & TALM]`
  - **Footprint**: Central Red Hat ACM Fleet Hub orchestrates declarative GitOps `SiteConfig` and `PolicyGenerator` Custom Resources.
  - **Automation**: Out-of-band Redfish BMC bare-metal hardware discovery, BIOS configuration, and automated ISO streaming.
  - **Scale**: Mass parallel Day 0 boot and Day 1 policy governance across fleets ranging from 10 to 10,000+ edge clusters.
  - **Target Scenarios**: 5G Telco Distributed Units (DU/CU), nationwide retail store chains, smart energy grid substations.
  - **Documentation**: [`docs/02-provisioning-paradigms/04-ztp-acm-gitops.md`](docs/02-provisioning-paradigms/04-ztp-acm-gitops.md)

<a id="hypershift-hosted-cp"></a>
- **5. Hosted Control Planes / HyperShift (HCP)** `[Centralized Containerized Control Plane Pods]`
  - **Footprint**: Control plane components (`etcd`, `kube-apiserver`, CVO) run as containerized pods inside a central hosting cluster.
  - **Efficiency**: Delivers up to 60% compute hardware savings, sub-15 minute cluster provisioning, and strict tenant isolation.
  - **Target Scenarios**: Internal Developer Platforms (IDP), multi-tenant dev/test sandboxes, cloud-native SaaS environments.
  - **Documentation**: [`docs/01-architecture-topologies/05-hypershift-hosted-cp.md`](docs/01-architecture-topologies/05-hypershift-hosted-cp.md)

#### Section 3: On-Premises Datacenter Platforms

<a id="bare-metal-physical"></a>
- **1. Physical Bare Metal** `(Dell PowerEdge / HPE ProLiant / Cisco UCS / Supermicro / Lenovo)`
  - **Provisioning**: Agent-Based Installer (ABI) or Assisted Installer via Redfish BMC Virtual Media (Bootstrap-in-Place).
  - **Networking**: NMState declarative static IP bonding (LACP / 802.3ad) with VLAN tagging and jumbo frames (MTU 9000).
  - **Storage**: OpenShift Data Foundation (ODF) backed by local NVMe SSDs; CSI local storage operator integration.
  - **Best For**: Maximum compute throughput, deterministic low latency, Telco vRAN, and GPU/AI training clusters.
  - **Documentation**: [`docs/04-platforms/01-bare-metal-physical.md`](docs/04-platforms/01-bare-metal-physical.md)

<a id="vmware-vsphere"></a>
- **2. VMware vSphere (8.x / 9.x)**
  - **Provisioning**: vSphere IPI (fully automated vCenter VM lifecycle) or Agent-Based Installer (ABI).
  - **Storage**: VMware vSphere CSI Driver integrated with VMware vSAN, VMFS datastores, or enterprise SAN arrays.
  - **Integration**: Automated DRS anti-affinity rules, multi-vCenter failure zones, and NSX-T / VDS distributed networking.
  - **Best For**: Enterprise private clouds with existing VMware vSphere investments and storage tiering.
  - **Documentation**: [`docs/04-platforms/02-vmware-vsphere.md`](docs/04-platforms/02-vmware-vsphere.md)

<a id="nutanix-ahv"></a>
- **3. Nutanix AHV HCI**
  - **Provisioning**: Nutanix IPI directly integrated with Prism Central (PC) and Prism Element (PE) REST APIs.
  - **Storage**: Nutanix CSI driver supporting Nutanix Volumes (Block) and Nutanix Files (NFS) storage classes.
  - **Integration**: Native Flow Microsegmentation network policies and Prism Disaster Recovery protection domains.
  - **Best For**: Organizations standardizing on Nutanix Hyperconverged Infrastructure for datacenter compute.
  - **Documentation**: [`docs/04-platforms/03-nutanix-ahv.md`](docs/04-platforms/03-nutanix-ahv.md)

<a id="kvm-openstack"></a>
- **4. KVM & RHOSO (Red Hat OpenStack Services on OpenShift)**
  - **Provisioning**: OpenStack IPI (using openstack-installer) or Agent-Based ISO booted on Libvirt / KVM hypervisors.
  - **Storage**: OpenStack Cinder CSI driver for persistent block storage backed by Ceph RBD or NetApp arrays.
  - **Networking**: OVN-Kubernetes with Octavia Load Balancing, SR-IOV Passthrough, and multi-network attachments.
  - **Best For**: Telco Network Function Virtualization (NFV) and enterprise open-source private cloud datacenters.
  - **Documentation**: [`docs/04-platforms/04-kvm-openstack.md`](docs/04-platforms/04-kvm-openstack.md)

<a id="microsoft-hyper-v"></a>
- **5. Microsoft Hyper-V / Azure Stack HCI**
  - **Provisioning**: Agent-Based Installer (ABI) paired with automated PowerShell VM deployment and lifecycle scripts.
  - **Architecture**: Generation 2 (Gen 2) UEFI VMs with `MicrosoftUEFICertificateAuthority` template.
  - **Networking**: Virtual Switch with MAC Address Spoofing enabled for Keepalived VIP high availability failover.
  - **Storage**: OpenShift Data Foundation (ODF) internal cluster or enterprise Windows SMB / CSI storage drivers.
  - **Best For**: Microsoft-centric enterprise datacenters and Azure Stack HCI on-prem hybrid cloud environments.
  - **Documentation**: [`docs/04-platforms/08-microsoft-hyper-v.md`](docs/04-platforms/08-microsoft-hyper-v.md)

#### Section 4: Network Isolation & Connectivity Paradigms

<a id="network-fully-connected"></a>
- **1. Fully Connected Network** `[Direct Internet / Red Hat CDN]`
  - **Egress Connectivity**: Direct outbound HTTPS access to `registry.redhat.io`, `quay.io`, and OpenShift release repositories.
  - **Lifecycle Management**: Automated Cincinnati / OpenShift Update Service (OSUS) channel tracking (`fast-4.20`, `stable-4.20`, `eus-4.20`).
  - **Helper Node**: Optional; cloud-native DHCP, Route53 / Cloud DNS, and native cloud load balancers satisfy all requirements.
  - **Documentation**: [`docs/03-network-and-connectivity/01-connected-with-proxies.md`](docs/03-network-and-connectivity/01-connected-with-proxies.md)

<a id="network-proxy-restricted"></a>
- **2. Proxy-Restricted Enterprise Network** `[Corporate Forward Proxy + TLS Inspection]`
  - **Egress Connectivity**: All outbound traffic routed strictly through enterprise forward proxy (Squid, BlueCoat, Zscaler).
  - **Cluster Configuration**: Global cluster `Proxy` resource defines `httpProxy`, `httpsProxy`, and `noProxy` bypass CIDRs.
  - **Enterprise PKI**: Custom enterprise root/intermediate CA certificates injected into cluster-wide `trustedCA` bundle ConfigMap.
  - **Helper Node**: Recommended on-premises for internal proxy bypass, DNS resolution, and Keepalived VIP load balancing.
  - **Documentation**: [`docs/03-network-and-connectivity/01-connected-with-proxies.md`](docs/03-network-and-connectivity/01-connected-with-proxies.md)

<a id="network-air-gapped"></a>
- **3. Air-Gapped / Disconnected Dark Site Network** `[Zero Internet Connectivity]`
  - **Egress Connectivity**: Strictly zero external internet access; air-gapped datacenter, tactical edge, or isolated enclave.
  - **Enterprise Mirroring**: `oc-mirror` v2 CLI with declarative `ImageSetConfiguration` v2 and local OCI cache streaming.
  - **In-Cluster Mirroring**: `ImageDigestMirrorSet` (IDMS) and `ImageTagMirrorSet` (ITMS) CRDs redirect image pulls to private registry.
  - **Helper Node**: **MANDATORY** on-premises for enterprise Quay / Harbor registry, BIND9 DNS, Stratum NTP, and HAProxy VIP routing.
  - **Documentation**: [`docs/03-network-and-connectivity/02-air-gapped-oc-mirror-v2.md`](docs/03-network-and-connectivity/02-air-gapped-oc-mirror-v2.md) & [`docs/05-day0-readiness/04-helper-node-architecture.md`](docs/05-day0-readiness/04-helper-node-architecture.md)


<a id="graphical-mermaid-flowchart"></a>
<details>
<summary><b>Click to view Graphical Mermaid Flowchart</b></summary>

```mermaid
flowchart LR
    Start(["<div style='width:240px; text-align:center'><b>OpenShift 4.20 Architecture<br/>Master Decision Engine</b></div>"]) --> TargetEnv{{"<div style='width:180px; text-align:center'><b>Target Infrastructure<br/>Environment?</b></div>"}}

    %% Routing to Subgraphs
    TargetEnv -->|"Public Cloud"| CloudSec{{"<div style='width:180px; text-align:center'><b>Cloud IAM &<br/>Security Governance?</b></div>"}}
    TargetEnv -->|"Edge & Remote"| EdgeScale{{"<div style='width:180px; text-align:center'><b>Target Edge Footprint<br/>& Cluster Scale?</b></div>"}}
    TargetEnv -->|"On-Premises"| DCPlatform{{"<div style='width:180px; text-align:center'><b>Datacenter Hypervisor<br/>or Physical Platform?</b></div>"}}
    TargetEnv -->|"Network Layer"| NetMode{{"<div style='width:180px; text-align:center'><b>Network Isolation<br/>& Egress Security?</b></div>"}}

    subgraph CloudFlow [" 1. Public Cloud Deployments "]
        direction TB
        CloudSec -->|"Automated API"| CloudIPI["<div style='width:340px; text-align:left; padding:6px 12px'><b>Cloud IPI (Automated)</b><br/>• AWS / Azure / GCP / OCI<br/>• Keyless STS & Cloud IAM<br/>• Dynamic VPC & Subnets<br/>• Auto-Scaling Compute</div>"]
        CloudSec -->|"Strict Gov"| CloudUPI["<div style='width:340px; text-align:left; padding:6px 12px'><b>Cloud UPI (Custom VPC)</b><br/>• Pre-Created Enterprise VPC<br/>• Manual ccoctl Credentials<br/>• Custom SecOps Firewalls<br/>• Internal Private Gateways</div>"]
    end

    subgraph EdgeFlow [" 2. Edge & Distributed Topologies "]
        direction TB
        EdgeScale -->|"1 Node (Far Edge)"| SNO["<div style='width:340px; text-align:left; padding:6px 12px'><b>Single Node OpenShift (SNO)</b><br/>• Master + Workloads Unified<br/>• Min: 8 vCPU, 16-32GB RAM<br/>• Autonomous Agent ISO Boot<br/>• Survives WAN Isolation</div>"]
        EdgeScale -->|"3 Nodes (Branch)"| Compact["<div style='width:340px; text-align:left; padding:6px 12px'><b>3-Node Compact Converged</b><br/>• Schedulable Master Nodes<br/>• Collocated ODF Ceph HA<br/>• Full 3-Node Raft Quorum<br/>• Zero Dedicated Workers</div>"]
        EdgeScale -->|"Distributed WAN"| RemoteWorkers["<div style='width:340px; text-align:left; padding:6px 12px'><b>Remote Worker Nodes (WAN)</b><br/>• Central 3-Node Control<br/>• Remote Edge Worker Nodes<br/>• Tuned Kubelet (10s Ping)<br/>• Resilient Pod Eviction</div>"]
        EdgeScale -->|"Fleet (10+ Sites)"| ZTP["<div style='width:340px; text-align:left; padding:6px 12px'><b>Zero Touch Provisioning (ZTP)</b><br/>• ACM 2.12+ Fleet Hub<br/>• GitOps SiteConfig CRDs<br/>• Out-of-Band Redfish Boot<br/>• Scalable: 10,000+ Sites</div>"]
        EdgeScale -->|"Multi-Tenant IDP"| HCP["<div style='width:340px; text-align:left; padding:6px 12px'><b>Hosted Control Planes (HCP)</b><br/>• Containerized Control Pods<br/>• 60% Hardware Savings<br/>• Sub-15 Min Cluster Deploy<br/>• Isolated Tenant Domains</div>"]
    end

    subgraph DCFlow [" 3. On-Premises Datacenter Platforms "]
        direction TB
        DCPlatform -->|"Bare Metal"| BM["<div style='width:340px; text-align:left; padding:6px 12px'><b>Physical Bare Metal</b><br/>• Agent-Based Install (ABI)<br/>• Dell / HPE Redfish BMC<br/>• Bonded LACP (MTU 9000)<br/>• NVMe + ODF Ceph Storage</div>"]
        DCPlatform -->|"VMware vSphere"| VMW["<div style='width:340px; text-align:left; padding:6px 12px'><b>VMware vSphere (8.x / 9.x)</b><br/>• Automated vCenter IPI<br/>• VMware CSI & vSAN Storage<br/>• DRS Anti-Affinity Rules<br/>• Multi-vCenter Domains</div>"]
        DCPlatform -->|"Nutanix HCI"| Nutanix["<div style='width:340px; text-align:left; padding:6px 12px'><b>Nutanix AHV HCI</b><br/>• Nutanix IPI Prism API<br/>• CSI Volumes & Files<br/>• Flow Microsegmentation<br/>• Prism Disaster Recovery</div>"]
        DCPlatform -->|"KVM / OpenStack"| OpenStack["<div style='width:340px; text-align:left; padding:6px 12px'><b>KVM & RHOSO OpenStack</b><br/>• OpenStack IPI / Libvirt<br/>• Cinder CSI Block Storage<br/>• Octavia LBs & SR-IOV<br/>• Telco NFV Private Cloud</div>"]
        DCPlatform -->|"Microsoft Hyper-V"| HyperV["<div style='width:340px; text-align:left; padding:6px 12px'><b>Microsoft Hyper-V / HCI</b><br/>• Generation 2 (Gen 2) VMs<br/>• Microsoft UEFICA Cert<br/>• MAC Spoofing for VIPs<br/>• PowerShell Automated Setup</div>"]
    end

    subgraph NetFlow [" 4. Network Isolation & Security "]
        direction TB
        NetMode -->|"Direct CDN"| NetConnected["<div style='width:340px; text-align:left; padding:6px 12px'><b>Fully Connected Network</b><br/>• Direct Red Hat CDN Access<br/>• Cincinnati Updates OSUS<br/>• Quay & Red Hat Registries<br/>• Native Load Balancers</div>"]
        NetMode -->|"Corp Proxy"| NetProxy["<div style='width:340px; text-align:left; padding:6px 12px'><b>Proxy-Restricted Network</b><br/>• Corporate Proxy Egress<br/>• Cluster Proxy Resource<br/>• Enterprise Root CA Trust<br/>• Helper Node VIP Routing</div>"]
        NetMode -->|"Air-Gapped"| NetAirGap["<div style='width:340px; text-align:left; padding:6px 12px'><b>Air-Gapped / Dark Site</b><br/>• Zero Internet (Dark Site)<br/>• oc-mirror v2 OCI Cache<br/>• IDMS / ITMS Image Mirrors<br/>• MANDATORY Helper Node</div>"]
    end

    %% Node Styles for High Readability
    classDef mainNode fill:#0d233a,stroke:#2f7ed8,stroke-width:2px,color:#ffffff,font-size:12px;
    classDef decision fill:#302744,stroke:#8d79b9,stroke-width:2px,color:#ffffff,font-size:12px;
    classDef cloudBox fill:#e8f4fd,stroke:#0288d1,stroke-width:2px,color:#01579b,font-size:12px;
    classDef edgeBox fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px,color:#4a148c,font-size:12px;
    classDef dcBox fill:#e8f5e9,stroke:#388e3c,stroke-width:2px,color:#1b5e20,font-size:12px;
    classDef netBox fill:#fff3e0,stroke:#e65100,stroke-width:2px,color:#e65100,font-size:12px;

    class Start mainNode;
    class TargetEnv,CloudSec,EdgeScale,DCPlatform,NetMode decision;
    class CloudIPI,CloudUPI cloudBox;
    class SNO,Compact,RemoteWorkers,ZTP,HCP edgeBox;
    class BM,VMW,Nutanix,OpenStack,HyperV dcBox;
    class NetConnected,NetProxy,NetAirGap netBox;
```

</details>

---

## Master Deployment & Architecture Matrix

| Platform / Scenario | Primary Provisioning Method | Recommended Topologies | Network Mode | Storage Architecture | Typical Deploy Time | Production Recommendation |
| :--- | :--- | :--- | :--- | :--- | :---: | :--- |
| **Bare Metal (Dell/HPE/Cisco)** | Agent-Based (ABI) / ZTP | SNO, Compact, Standard HA | Air-Gapped or Connected | Local NVMe + ODF (Ceph) | 25 - 35 mins | **Recommended for Maximum Performance & AI/Telco** |
| **VMware vSphere (8.x / 9.x)** | vSphere IPI or ABI | Compact, Standard HA | Connected / Proxy / Air-Gap | vSphere CSI / vSAN / ODF | 30 - 45 mins | **Standard for On-Premises Enterprise IT** |
| **Nutanix AHV** | Nutanix IPI | Compact, Standard HA | Connected / Air-Gapped | Nutanix CSI (Volumes/Files) | 35 - 45 mins | **Recommended for Nutanix HCI Customers** |
| **KVM / OpenStack (RHOSO)** | OpenStack IPI / ABI | Standard HA, Compact | Connected / Air-Gapped | Cinder CSI / ODF | 35 - 50 mins | **Standard for Telco & Open Cloud Stacks** |
| **Amazon Web Services (AWS)**| Cloud IPI (Private VPC) | Standard HA (Multi-AZ) | Connected / Private NAT | AWS EBS (gp3) / EFS CSI | 35 - 45 mins | **Recommended: Manual STS / IRSA Auth Mode** |
| **Microsoft Azure** | Cloud IPI (Private VNet)| Standard HA (Multi-AZ) | Connected / Private VNet | Azure Managed Disk / Azure File | 35 - 45 mins | **Recommended: Azure Workload Identity** |
| **Google Cloud (GCP)** | Cloud IPI (Shared VPC) | Standard HA (Multi-Zone)| Connected / Private PSC | Persistent Disk (pd-balanced/ssd) | 35 - 45 mins | **Recommended: GCP Workload Identity Federation** |
| **Microsoft Hyper-V / Azure Stack HCI** | Agent-Based (ABI) / UPI | Compact, Standard HA | Connected / Air-Gapped | ODF / SMB CSI / Local VHDX | 30 - 40 mins | **Gen 2 UEFI + MicrosoftUEFICACert + MAC Spoofing** |
| **Air-Gapped / Dark Site** | `oc-mirror` v2 + ABI | SNO, Compact, Standard HA | Strictly Disconnected | Local Quay/Harbor + ODF | 45 - 60 mins | **Mandatory: Internal DNS, NTP & Private PKI** |

---

## Repository Directory Structure & Architectural File Map

To navigate and utilize this enterprise repository effectively, the directory structure below maps every documentation guide, declarative configuration manifest, and automation script to its exact role in the OpenShift 4.20 lifecycle:

### High-Level Directory Tree

> [!TIP]
> Click any file or directory below to jump directly to its document, YAML manifest, or automation script on GitHub.

- `├──` 📄 [`.gitignore`](.gitignore) — *Ignored artifacts (ISOs, ignition, local auth tokens, logs)*
- `├──` 📄 [`LICENSE`](LICENSE) — *Apache 2.0 open-source enterprise license*
- `├──` 📄 [`README.md`](README.md) — *Master architecture matrix, decision trees, workflow & TOC*
- `├──` 📁 **[`docs/`](docs/)** — *Exhaustive Technical Documentation & Architecture Modules*
  - `├──` 📄 [`docs/00-navigation.md`](docs/00-navigation.md) — *Comprehensive cross-reference index and document map*
  - `├──` 📁 **[`docs/01-architecture-topologies/`](docs/01-architecture-topologies/)** — *Sizing, quorum, and hardware topologies*
    - `├──` 📄 [`01-sno-single-node.md`](docs/01-architecture-topologies/01-sno-single-node.md) — *Single Node OpenShift (far-edge, autonomous operation)*
    - `├──` 📄 [`02-compact-3-node-converged.md`](docs/01-architecture-topologies/02-compact-3-node-converged.md) — *3-Node Compact Converged (collocated masters + ODF storage)*
    - `├──` 📄 [`03-standard-ha-multinode.md`](docs/01-architecture-topologies/03-standard-ha-multinode.md) — *Standard HA Multi-Node (dedicated masters, infra, workers)*
    - `├──` 📄 [`04-remote-workers-wan.md`](docs/01-architecture-topologies/04-remote-workers-wan.md) — *Distributed Remote Worker Nodes over high-latency WAN links*
    - `├──` 📄 [`05-hypershift-hosted-cp.md`](docs/01-architecture-topologies/05-hypershift-hosted-cp.md) — *Hosted Control Planes (HyperShift centralized pods)*
    - `└──` 📄 [`README.md`](docs/01-architecture-topologies/README.md) — *Architecture module summary & sizing tables*
  - `├──` 📁 **[`docs/02-provisioning-paradigms/`](docs/02-provisioning-paradigms/)** — *Installation mechanisms & bootstrap architectures*
    - `├──` 📄 [`01-agent-based-installer.md`](docs/02-provisioning-paradigms/01-agent-based-installer.md) — *Agent-Based Installer (ABI) & Bootstrap-in-Place deep dive*
    - `├──` 📄 [`02-installer-provisioned-ipi.md`](docs/02-provisioning-paradigms/02-installer-provisioned-ipi.md) — *Installer-Provisioned Infrastructure (IPI) automation*
    - `├──` 📄 [`03-user-provisioned-upi.md`](docs/02-provisioning-paradigms/03-user-provisioned-upi.md) — *User-Provisioned Infrastructure (UPI) legacy / strict SecOps*
    - `├──` 📄 [`04-ztp-acm-gitops.md`](docs/02-provisioning-paradigms/04-ztp-acm-gitops.md) — *Zero Touch Provisioning (ZTP) via ACM 2.12+ & TALM GitOps*
    - `└──` 📄 [`README.md`](docs/02-provisioning-paradigms/README.md) — *Provisioning paradigms evaluation matrix*
  - `├──` 📁 **[`docs/03-network-and-connectivity/`](docs/03-network-and-connectivity/)** — *Enterprise networking, proxy egress, and air-gap mirrors*
    - `├──` 📄 [`01-connected-with-proxies.md`](docs/03-network-and-connectivity/01-connected-with-proxies.md) — *Forward proxy egress, noProxy CIDRs, and custom trustedCA*
    - `├──` 📄 [`02-air-gapped-oc-mirror-v2.md`](docs/03-network-and-connectivity/02-air-gapped-oc-mirror-v2.md) — *Disconnected mirroring standard with oc-mirror v2 & IDMS*
    - `├──` 📄 [`03-air-gapped-core-services.md`](docs/03-network-and-connectivity/03-air-gapped-core-services.md) — *Isolated infrastructure services (split DNS, Chrony, PKI)*
    - `├──` 📄 [`04-ovn-kubernetes-tuning.md`](docs/03-network-and-connectivity/04-ovn-kubernetes-tuning.md) — *OVN-Kubernetes CNI, MTU sizing, EgressIP & EgressFirewall*
    - `├──` 📄 [`05-gateway-api-architecture.md`](docs/03-network-and-connectivity/05-gateway-api-architecture.md) — *Kubernetes Gateway API standard, canary routing & Route migration*
    - `└──` 📄 [`README.md`](docs/03-network-and-connectivity/README.md) — *Network architecture module guide*
  - `├──` 📁 **[`docs/04-platforms/`](docs/04-platforms/)** — *Infrastructure-specific installation blueprints*
    - `├──` 📄 [`01-bare-metal-physical.md`](docs/04-platforms/01-bare-metal-physical.md) — *Physical Bare Metal (Dell, HPE, Cisco UCS, Lenovo) via BMC*
    - `├──` 📄 [`02-vmware-vsphere.md`](docs/04-platforms/02-vmware-vsphere.md) — *VMware vSphere (8.x / 9.x) IPI vs ABI, vSAN, and CSI*
    - `├──` 📄 [`03-nutanix-ahv.md`](docs/04-platforms/03-nutanix-ahv.md) — *Nutanix AHV HCI IPI via Prism Central and Nutanix CSI*
    - `├──` 📄 [`04-kvm-openstack.md`](docs/04-platforms/04-kvm-openstack.md) — *KVM Libvirt & Red Hat OpenStack Services on OpenShift (RHOSO)*
    - `├──` 📄 [`05-aws.md`](docs/04-platforms/05-aws.md) — *Amazon Web Services Private VPC IPI with STS Manual Mode*
    - `├──` 📄 [`06-azure.md`](docs/04-platforms/06-azure.md) — *Microsoft Azure Private VNet IPI with Workload Identity*
    - `├──` 📄 [`07-gcp.md`](docs/04-platforms/07-gcp.md) — *Google Cloud Platform Shared VPC with Workload Identity*
    - `├──` 📄 [`08-microsoft-hyper-v.md`](docs/04-platforms/08-microsoft-hyper-v.md) — *Microsoft Hyper-V / Azure Stack HCI Gen 2 VM deployment*
    - `├──` 📄 [`09-openshift-virtualization.md`](docs/04-platforms/09-openshift-virtualization.md) — *OpenShift Virtualization (KubeVirt) & MTV 2.8 migration*
    - `└──` 📄 [`README.md`](docs/04-platforms/README.md) — *Platform compatibility & deployment matrix*
  - `├──` 📁 **[`docs/05-day0-readiness/`](docs/05-day0-readiness/)** — *Preflight capacity planning & core services deployment*
    - `├──` 📄 [`01-hardware-and-sizing.md`](docs/05-day0-readiness/01-hardware-and-sizing.md) — *Hardware capacity, CPU/RAM quotas, and disk IOPS latency*
    - `├──` 📄 [`02-dns-loadbalancer-matrix.md`](docs/05-day0-readiness/02-dns-loadbalancer-matrix.md) — *DNS records matrix, port routing, and Keepalived VIP specs*
    - `├──` 📄 [`03-storage-architecture-odf.md`](docs/05-day0-readiness/03-storage-architecture-odf.md) — *OpenShift Data Foundation (ODF) Ceph RBD, CephFS & RGW*
    - `├──` 📄 [`04-helper-node-architecture.md`](docs/05-day0-readiness/04-helper-node-architecture.md) — *Helper Node / Bastion engineering (BIND9, HAProxy, Chrony)*
    - `└──` 📄 [`README.md`](docs/05-day0-readiness/README.md) — *Day 0 readiness overview*
  - `├──` 📁 **[`docs/06-day1-baselining/`](docs/06-day1-baselining/)** — *Day 1 post-installation hardening & enterprise baselining*
    - `├──` 📄 [`01-cluster-operator-hardening.md`](docs/06-day1-baselining/01-cluster-operator-hardening.md) — *Verifying 34+ ClusterOperators and resolving degraded states*
    - `├──` 📄 [`02-ingress-and-custom-certs.md`](docs/06-day1-baselining/02-ingress-and-custom-certs.md) — *Replacing ingress router certificates with enterprise PKI*
    - `├──` 📄 [`03-identity-providers-rbac.md`](docs/06-day1-baselining/03-identity-providers-rbac.md) — *Enterprise SSO (Keycloak, Entra ID) and RBAC lockdown*
    - `├──` 📄 [`04-machineconfigpools-tuning.md`](docs/06-day1-baselining/04-machineconfigpools-tuning.md) — *Dedicated infra MCPs, real-time kernel, and node tuning*
    - `├──` 📄 [`05-secrets-and-cert-rotation.md`](docs/06-day1-baselining/05-secrets-and-cert-rotation.md) — *Automated cert rotation (cert-manager) & External Secrets (ESO)*
    - `└──` 📄 [`README.md`](docs/06-day1-baselining/README.md) — *Day 1 baselining overview*
  - `├──` 📁 **[`docs/07-day2-operations/`](docs/07-day2-operations/)** — *Day 2 enterprise operations, observability & lifecycle*
    - `├──` 📄 [`01-observability-stack.md`](docs/07-day2-operations/01-observability-stack.md) — *User Workload Monitoring, LokiStack logging & Tempo tracing*
    - `├──` 📄 [`02-security-and-compliance.md`](docs/07-day2-operations/02-security-and-compliance.md) — *CIS Benchmark & NIST SP 800-53 via Compliance Operator*
    - `├──` 📄 [`03-gitops-foundation.md`](docs/07-day2-operations/03-gitops-foundation.md) — *Red Hat OpenShift GitOps (Argo CD 3.5+) & External Secrets*
    - `├──` 📄 [`04-lifecycle-and-upgrades.md`](docs/07-day2-operations/04-lifecycle-and-upgrades.md) — *Cluster lifecycle, EUS-to-EUS upgrades & MCP canary rollout*
    - `├──` 📄 [`05-automated-upgrades.md`](docs/07-day2-operations/05-automated-upgrades.md) — *Automated upgrade workflows, etcd snapshot preflight gating*
    - `├──` 📄 [`06-gitops-app-of-apps.md`](docs/07-day2-operations/06-gitops-app-of-apps.md) — *GitOps App-of-Apps, drift self-healing & multi-environment promotion*
    - `├──` 📄 [`07-openshift-ai-gpu.md`](docs/07-day2-operations/07-openshift-ai-gpu.md) — *Enterprise AI workloads, GPU Operator & vLLM model serving*
    - `└──` 📄 [`README.md`](docs/07-day2-operations/README.md) — *Day 2 operational runbooks overview*
  - `├──` 📁 **[`docs/08-backup-dr-and-rebuild/`](docs/08-backup-dr-and-rebuild/)** — *Business continuity, disaster recovery & rapid rebuild*
    - `├──` 📄 [`01-etcd-backup-restore.md`](docs/08-backup-dr-and-rebuild/01-etcd-backup-restore.md) — *Control plane etcd snapshot automation & disaster recovery*
    - `├──` 📄 [`02-oadp-vs-velero-deepdive.md`](docs/08-backup-dr-and-rebuild/02-oadp-vs-velero-deepdive.md) — *Technical deep-dive: why vanilla Velero fails vs OADP Kopia*
    - `├──` 📄 [`03-metro-dr-and-regional-dr.md`](docs/08-backup-dr-and-rebuild/03-metro-dr-and-regional-dr.md) — *Metro-DR (RPO=0) vs Regional-DR (RPO<5m) multi-cluster*
    - `├──` 📄 [`04-declarative-rebuild-gitops.md`](docs/08-backup-dr-and-rebuild/04-declarative-rebuild-gitops.md) — *Full cluster rebuild in <45 minutes via GitOps & ACM*
    - `└──` 📄 [`README.md`](docs/08-backup-dr-and-rebuild/README.md) — *Backup & DR module overview*
  - `└──` 📁 **[`docs/09-emergency-runbooks/`](docs/09-emergency-runbooks/)** — *Emergency incident recovery & out-of-band triage*
    - `├──` 📄 [`01-expired-certs-recovery.md`](docs/09-emergency-runbooks/01-expired-certs-recovery.md) — *Reviving clusters with expired certificates after prolonged shutdown*
    - `├──` 📄 [`02-helper-node-access-and-jumping.md`](docs/09-emergency-runbooks/02-helper-node-access-and-jumping.md) — *Helper Node SSH jumping, serial console & IPMI/Redfish SOL*
    - `├──` 📄 [`03-node-reinstallation-and-replacement.md`](docs/09-emergency-runbooks/03-node-reinstallation-and-replacement.md) — *Control plane & worker replacement (CLI, UI, ACM)*
    - `├──` 📄 [`04-etcd-quorum-loss-recovery.md`](docs/09-emergency-runbooks/04-etcd-quorum-loss-recovery.md) — *Emergency etcd single-member restoration & split-brain recovery*
    - `├──` 📄 [`05-machineconfig-and-storage-recovery.md`](docs/09-emergency-runbooks/05-machineconfig-and-storage-recovery.md) — *Unsticking degraded MCPs & container storage overlay exhaustion*
- `├──` 📁 **[`assets/`](assets/)** — *Visual Architecture Blueprints & Infographics*
  - `└──` 🖼️ [`enterprise-openshift-4-20-day0-to-day2-blueprint.jpg`](assets/enterprise-openshift-4-20-day0-to-day2-blueprint.jpg) — *The Day 0 to Day 2 Enterprise Operational Blueprint*
- `├──` 📁 **[`configs/`](configs/)** — *Production Declarative Manifests & Configurations*
  - `├──` 📁 **[`configs/agent-based/`](configs/agent-based/)** — *Declarative Agent-Based Installer (ABI) manifests*
    - `├──` 📄 [`agent-config.yaml`](configs/agent-based/agent-config.yaml) — *Static NMState host IP bonding and Rendezvous node config*
    - `├──` 📄 [`agent-config-lacp-vlan.yaml`](configs/agent-based/agent-config-lacp-vlan.yaml) — *Enterprise LACP 802.3ad bonding, 802.1Q VLANs & WWN root device hints*
    - `├──` 📄 [`install-config-sno.yaml`](configs/agent-based/install-config-sno.yaml) — *SNO single-node cluster install configuration*
    - `├──` 📄 [`install-config-compact.yaml`](configs/agent-based/install-config-compact.yaml) — *3-Node Compact Converged install configuration*
    - `├──` 📄 [`install-config-standard.yaml`](configs/agent-based/install-config-standard.yaml) — *Standard 3-Master + 3-Worker HA install configuration*
    - `├──` 📄 [`install-config-airgap.yaml`](configs/agent-based/install-config-airgap.yaml) — *Air-gapped / disconnected install-config with imageDigestSources & trust bundle*
    - `└──` 📄 [`ipxe-boot.cfg`](configs/agent-based/ipxe-boot.cfg) — *Network PXE / iPXE chainloader booting live ABI kernel and rootfs*
  - `├──` 📁 **[`configs/ipi-cloud/`](configs/ipi-cloud/)** — *Public Cloud Installer-Provisioned (IPI) manifests*
    - `├──` 📄 [`aws-install-config.yaml`](configs/ipi-cloud/aws-install-config.yaml) — *AWS Private VPC install-config with STS keyless IAM*
    - `├──` 📄 [`azure-install-config.yaml`](configs/ipi-cloud/azure-install-config.yaml) — *Azure Private VNet install-config with Workload Identity*
    - `└──` 📄 [`gcp-install-config.yaml`](configs/ipi-cloud/gcp-install-config.yaml) — *GCP Shared VPC install-config with Workload Identity*
  - `├──` 📁 **[`configs/upi-vsphere/`](configs/upi-vsphere/)** — *Virtualization User-Provisioned (UPI) manifests*
    - `└──` 📄 [`vsphere-install-config.yaml`](configs/upi-vsphere/vsphere-install-config.yaml) — *VMware vSphere UPI install configuration*
  - `├──` 📁 **[`configs/airgap/`](configs/airgap/)** — *Disconnected & Air-Gapped cluster manifests*
    - `├──` 📄 [`imageset-config-v2.yaml`](configs/airgap/imageset-config-v2.yaml) — *oc-mirror v2 declarative image set mirroring specification*
    - `└──` 📄 [`local-registry-quay.yaml`](configs/airgap/local-registry-quay.yaml) — *On-prem mirror registry deployment manifest (Quay / Harbor)*
  - `├──` 📁 **[`configs/gateway-api/`](configs/gateway-api/)** — *Kubernetes Gateway API declarative resources*
    - `├──` 📄 [`gatewayclass-openshift.yaml`](configs/gateway-api/gatewayclass-openshift.yaml) — *OpenShift Ingress Operator / Envoy GatewayClass*
    - `├──` 📄 [`enterprise-gateway.yaml`](configs/gateway-api/enterprise-gateway.yaml) — *Multi-tenant L4/L7 Gateway with cert-manager automated TLS*
    - `├──` 📄 [`httproute-canary-split.yaml`](configs/gateway-api/httproute-canary-split.yaml) — *Weighted canary traffic split with header matching and rewrite*
    - `├──` 📄 [`grpcroute-ai-inference.yaml`](configs/gateway-api/grpcroute-ai-inference.yaml) — *Native gRPC streaming route for vLLM AI model serving*
    - `└──` 📄 [`tlsroute-vm-passthrough.yaml`](configs/gateway-api/tlsroute-vm-passthrough.yaml) — *L4 SNI TLS passthrough route for OpenShift Virtualization VMs*
  - `├──` 📁 **[`configs/day1/`](configs/day1/)** — *Day 1 baselining & security configuration manifests*
    - `├──` 📄 [`machineconfig-chrony.yaml`](configs/day1/machineconfig-chrony.yaml) — *Declarative Chrony NTP sync MachineConfig (stratum servers)*
    - `├──` 📄 [`cluster-proxy-trustedca.yaml`](configs/day1/cluster-proxy-trustedca.yaml) — *Cluster-wide corporate forward proxy & trustedCA bundle*
    - `├──` 📄 [`ingresscontroller-custom-tls.yaml`](configs/day1/ingresscontroller-custom-tls.yaml) — *Default IngressController custom wildcard TLS certificate*
    - `├──` 📄 [`idp-keycloak-oidc.yaml`](configs/day1/idp-keycloak-oidc.yaml) — *Enterprise OpenID Connect (OIDC) identity provider*
    - `└──` 📄 [`mcp-infra-nodes.yaml`](configs/day1/mcp-infra-nodes.yaml) — *Dedicated MachineConfigPool for Ingress/Registry/Monitoring*
  - `├──` 📁 **[`configs/day2/`](configs/day2/)** — *Day 2 observability, governance, and backup manifests*
    - `├──` 📄 [`oadp-dpa-cr.yaml`](configs/day2/oadp-dpa-cr.yaml) — *OADP 1.4+ DataProtectionApplication CR (Kopia data-mover)*
    - `├──` 📄 [`etcd-backup-cronjob.yaml`](configs/day2/etcd-backup-cronjob.yaml) — *Scheduled etcd snapshot Kubernetes CronJob*
    - `├──` 📄 [`compliance-suite-cis.yaml`](configs/day2/compliance-suite-cis.yaml) — *Compliance Operator CIS benchmark scanning suite*
    - `└──` 📄 [`cluster-autoscaler.yaml`](configs/day2/cluster-autoscaler.yaml) — *Automated compute scaling threshold specification*
  - `├──` 📁 **[`configs/gitops/`](configs/gitops/)** — *Red Hat OpenShift GitOps & App-of-Apps root manifests*
    - `├──` 📄 [`gitops-operator-sub.yaml`](configs/gitops/gitops-operator-sub.yaml) — *OpenShift GitOps Operator Subscription*
    - `└──` 📄 [`root-app-of-apps.yaml`](configs/gitops/root-app-of-apps.yaml) — *ArgoCD root App-of-Apps orchestrator*
  - `├──` 📁 **[`configs/security/`](configs/security/)** — *Certificate management & External Secrets Operator*
    - `├──` 📄 [`cert-manager-clusterissuer.yaml`](configs/security/cert-manager-clusterissuer.yaml) — *cert-manager ClusterIssuer (Vault / ACME / Private CA)*
    - `└──` 📄 [`external-secrets-store.yaml`](configs/security/external-secrets-store.yaml) — *External Secrets Operator ClusterSecretStore for HashiCorp Vault*
  - `├──` 📁 **[`configs/virt/`](configs/virt/)** — *OpenShift Virtualization & Migration Toolkit (MTV)*
    - `├──` 📄 [`hyperconverged-cr.yaml`](configs/virt/hyperconverged-cr.yaml) — *HyperConverged Operator Custom Resource (KubeVirt)*
    - `├──` 📄 [`mtv-forklift-controller.yaml`](configs/virt/mtv-forklift-controller.yaml) — *Migration Toolkit for Virtualization (ForkliftController)*
    - `└──` 📄 [`vm-rhel9-template.yaml`](configs/virt/vm-rhel9-template.yaml) — *Production Enterprise RHEL 9 VirtualMachine manifest*
  - `├──` 📁 **[`configs/ai/`](configs/ai/)** — *Enterprise AI & GPU Acceleration manifests*
    - `├──` 📄 [`gpu-operator-clusterpolicy.yaml`](configs/ai/gpu-operator-clusterpolicy.yaml) — *NVIDIA GPU Operator ClusterPolicy*
    - `├──` 📄 [`rhoai-datasciencecluster.yaml`](configs/ai/rhoai-datasciencecluster.yaml) — *Red Hat OpenShift AI DataScienceCluster CR*
    - `└──` 📄 [`vllm-serving-runtime.yaml`](configs/ai/vllm-serving-runtime.yaml) — *vLLM high-throughput ServingRuntime for local LLM inference*
  - `├──` 📁 **[`configs/observability/`](configs/observability/)** — *Full-stack native observability manifests*
    - `├──` 📄 [`cluster-monitoring-config.yaml`](configs/observability/cluster-monitoring-config.yaml) — *UWM & OpenMetrics Exemplar storage activation*
    - `├──` 📄 [`lokistack-cr.yaml`](configs/observability/lokistack-cr.yaml) — *Enterprise LokiStack 3.x CR with S3 storage & retention tiers*
    - `├──` 📄 [`clusterlogforwarder-cr.yaml`](configs/observability/clusterlogforwarder-cr.yaml) — *Vector collector pipeline with structured metadata parsing*
    - `├──` 📄 [`tempostack-cr.yaml`](configs/observability/tempostack-cr.yaml) — *TempoStack distributed trace storage & compactor CR*
    - `├──` 📄 [`opentelemetry-collector.yaml`](configs/observability/opentelemetry-collector.yaml) — *OpenTelemetryCollector with tail-based sampling & OTLP gRPC*
    - `├──` 📄 [`coo-ui-correlation.yaml`](configs/observability/coo-ui-correlation.yaml) — *Cluster Observability Operator UI Plugins & Korrel8r rules*
    - `└──` 📄 [`flowcollector-cr.yaml`](configs/observability/flowcollector-cr.yaml) — *Network Observability eBPF FlowCollector CR*
  - `└──` 📁 **[`configs/helper-node/`](configs/helper-node/)** — *On-premises / Air-Gapped Helper Node daemon configurations*
    - `├──` 📄 [`haproxy.cfg`](configs/helper-node/haproxy.cfg) — *HAProxy Layer 4 load balancing for API (6443) & Apps (80/443)*
    - `└──` 📄 [`named.conf`](configs/helper-node/named.conf) — *Authoritative BIND9 DNS split-horizon zone configuration*
- `└──` 📁 **[`scripts/`](scripts/README.md)** — *Production Automation Tooling & Operational Scripts*
  - `├──` 📄 [`README.md`](scripts/README.md) — *Exhaustive operational & architectural manual for all 16 production scripts*
  - `├──` 📄 [`preflight-check.sh`](scripts/preflight-check.sh) — *Day 0 DNS, PTR, NTP, MTU, proxy, and latency preflight audit*
  - `├──` 📄 [`generate-agent-iso.sh`](scripts/generate-agent-iso.sh) — *Agent-Based Installer boot ISO builder (SNO/Compact/Standard)*
  - `├──` 📄 [`mirror-ocp420-airgap.sh`](scripts/mirror-ocp420-airgap.sh) — *oc-mirror v2 automated mirroring to local Quay/Harbor registry*
  - `├──` 📄 [`validate-cluster-health.sh`](scripts/validate-cluster-health.sh) — *Comprehensive health audit: operators, nodes, MCPs, storage*
  - `├──` 📄 [`etcd-backup.sh`](scripts/etcd-backup.sh) — *Non-disruptive master etcd snapshotting & retention pruning*
  - `├──` 📄 [`pre-upgrade-health-check.sh`](scripts/pre-upgrade-health-check.sh) — *Pre-upgrade gatekeeper: verifies etcd backup, MCPs & operators*
  - `├──` 📄 [`automated-cluster-upgrade.sh`](scripts/automated-cluster-upgrade.sh) — *End-to-end upgrade orchestrator with paused worker MCP canary*
  - `├──` 📄 [`airgap-upgrade.sh`](scripts/airgap-upgrade.sh) — *Disconnected upgrade orchestrator: mirrors release & applies IDMS*
  - `├──` 📄 [`deploy-hyperv-vms.ps1`](scripts/deploy-hyperv-vms.ps1) — *Automated PowerShell Gen 2 VM provisioner for Hyper-V / HCI*
  - `├──` 📄 [`test-oadp-restore.sh`](scripts/test-oadp-restore.sh) — *Automated disaster recovery drill & backup restoration auditor*
  - `├──` 📄 [`recover-expired-certs.sh`](scripts/recover-expired-certs.sh) — *Helper Node expired certificates recovery orchestrator*
  - `├──` 📄 [`helper-ssh-jump.sh`](scripts/helper-ssh-jump.sh) — *Out-of-band SSH jump & IPMI SOL console access utility*
  - `├──` 📄 [`replace-control-plane-node.sh`](scripts/replace-control-plane-node.sh) — *Control plane master node replacement assistant*
  - `├──` 📄 [`reinstall-worker-node.sh`](scripts/reinstall-worker-node.sh) — *Worker & infra node drain and reprovisioning orchestrator*
  - `├──` 📄 [`emergency-etcd-single-member.sh`](scripts/emergency-etcd-single-member.sh) — *Emergency single-member etcd quorum restoration engine*
  - `└──` 📄 [`verify-observability-stack.sh`](scripts/verify-observability-stack.sh) — *End-to-end native observability stack diagnostic engine*

<details>
<summary><b>Click to view Raw Plain-Text Monospace Directory Tree</b></summary>

```text
openshift-4-20-installation-day0-day2/
├── .gitignore
├── LICENSE
├── README.md
├── docs/
│   ├── 00-navigation.md
│   ├── 01-architecture-topologies/
│   │   ├── 01-sno-single-node.md
│   │   ├── 02-compact-3-node-converged.md
│   │   ├── 03-standard-ha-multinode.md
│   │   ├── 04-remote-workers-wan.md
│   │   ├── 05-hypershift-hosted-cp.md
│   │   └── README.md
│   ├── 02-provisioning-paradigms/
│   │   ├── 01-agent-based-installer.md
│   │   ├── 02-installer-provisioned-ipi.md
│   │   ├── 03-user-provisioned-upi.md
│   │   ├── 04-ztp-acm-gitops.md
│   │   └── README.md
│   ├── 03-network-and-connectivity/
│   │   ├── 01-connected-with-proxies.md
│   │   ├── 02-air-gapped-oc-mirror-v2.md
│   │   ├── 03-air-gapped-core-services.md
│   │   ├── 04-ovn-kubernetes-tuning.md
│   │   ├── 05-gateway-api-architecture.md
│   │   └── README.md
│   ├── 04-platforms/
│   │   ├── 01-bare-metal-physical.md
│   │   ├── 02-vmware-vsphere.md
│   │   ├── 03-nutanix-ahv.md
│   │   ├── 04-kvm-openstack.md
│   │   ├── 05-aws.md
│   │   ├── 06-azure.md
│   │   ├── 07-gcp.md
│   │   ├── 08-microsoft-hyper-v.md
│   │   ├── 09-openshift-virtualization.md
│   │   └── README.md
│   ├── 05-day0-readiness/
│   │   ├── 01-hardware-and-sizing.md
│   │   ├── 02-dns-loadbalancer-matrix.md
│   │   ├── 03-storage-architecture-odf.md
│   │   ├── 04-helper-node-architecture.md
│   │   └── README.md
│   ├── 06-day1-baselining/
│   │   ├── 01-cluster-operator-hardening.md
│   │   ├── 02-ingress-and-custom-certs.md
│   │   ├── 03-identity-providers-rbac.md
│   │   ├── 04-machineconfigpools-tuning.md
│   │   ├── 05-secrets-and-cert-rotation.md
│   │   └── README.md
│   ├── 07-day2-operations/
│   │   ├── 01-observability-stack.md
│   │   ├── 02-security-and-compliance.md
│   │   ├── 03-gitops-foundation.md
│   │   ├── 04-lifecycle-and-upgrades.md
│   │   ├── 05-automated-upgrades.md
│   │   ├── 06-gitops-app-of-apps.md
│   │   ├── 07-openshift-ai-gpu.md
│   │   └── README.md
│   ├── 08-backup-dr-and-rebuild/
│   │   ├── 01-etcd-backup-restore.md
│   │   ├── 02-oadp-vs-velero-deepdive.md
│   │   ├── 03-metro-dr-and-regional-dr.md
│   │   ├── 04-declarative-rebuild-gitops.md
│   │   └── README.md
│   └── 09-emergency-runbooks/
│       ├── 01-expired-certs-recovery.md
│       ├── 02-helper-node-access-and-jumping.md
│       ├── 03-node-reinstallation-and-replacement.md
│       ├── 04-etcd-quorum-loss-recovery.md
│       ├── 05-machineconfig-and-storage-recovery.md
│       └── README.md
├── assets/
│   └── enterprise-openshift-4-20-day0-to-day2-blueprint.jpg
├── configs/
│   ├── agent-based/
│   │   ├── agent-config.yaml
│   │   ├── agent-config-lacp-vlan.yaml
│   │   ├── install-config-sno.yaml
│   │   ├── install-config-compact.yaml
│   │   ├── install-config-standard.yaml
│   │   ├── install-config-airgap.yaml
│   │   └── ipxe-boot.cfg
│   ├── ipi-cloud/
│   │   ├── aws-install-config.yaml
│   │   ├── azure-install-config.yaml
│   │   └── gcp-install-config.yaml
│   ├── upi-vsphere/
│   │   └── vsphere-install-config.yaml
│   ├── airgap/
│   │   ├── imageset-config-v2.yaml
│   │   └── local-registry-quay.yaml
│   ├── gateway-api/
│   │   ├── gatewayclass-openshift.yaml
│   │   ├── enterprise-gateway.yaml
│   │   ├── httproute-canary-split.yaml
│   │   ├── grpcroute-ai-inference.yaml
│   │   └── tlsroute-vm-passthrough.yaml
│   ├── day1/
│   │   ├── machineconfig-chrony.yaml
│   │   ├── cluster-proxy-trustedca.yaml
│   │   ├── ingresscontroller-custom-tls.yaml
│   │   ├── idp-keycloak-oidc.yaml
│   │   └── mcp-infra-nodes.yaml
│   ├── day2/
│   │   ├── oadp-dpa-cr.yaml
│   │   ├── etcd-backup-cronjob.yaml
│   │   ├── compliance-suite-cis.yaml
│   │   └── cluster-autoscaler.yaml
│   ├── gitops/
│   │   ├── gitops-operator-sub.yaml
│   │   └── root-app-of-apps.yaml
│   ├── security/
│   │   ├── cert-manager-clusterissuer.yaml
│   │   └── external-secrets-store.yaml
│   ├── virt/
│   │   ├── hyperconverged-cr.yaml
│   │   ├── mtv-forklift-controller.yaml
│   │   └── vm-rhel9-template.yaml
│   ├── ai/
│   │   ├── gpu-operator-clusterpolicy.yaml
│   │   ├── rhoai-datasciencecluster.yaml
│   │   └── vllm-serving-runtime.yaml
│   ├── observability/
│   │   ├── cluster-monitoring-config.yaml
│   │   ├── lokistack-cr.yaml
│   │   ├── clusterlogforwarder-cr.yaml
│   │   ├── tempostack-cr.yaml
│   │   ├── opentelemetry-collector.yaml
│   │   ├── coo-ui-correlation.yaml
│   │   └── flowcollector-cr.yaml
│   └── helper-node/
│       ├── haproxy.cfg
│       └── named.conf
└── scripts/
    ├── preflight-check.sh
    ├── generate-agent-iso.sh
    ├── mirror-ocp420-airgap.sh
    ├── validate-cluster-health.sh
    ├── etcd-backup.sh
    ├── pre-upgrade-health-check.sh
    ├── automated-cluster-upgrade.sh
    ├── airgap-upgrade.sh
    ├── deploy-hyperv-vms.ps1
    ├── test-oadp-restore.sh
    ├── recover-expired-certs.sh
    ├── helper-ssh-jump.sh
    ├── replace-control-plane-node.sh
    ├── reinstall-worker-node.sh
    ├── emergency-etcd-single-member.sh
    └── verify-observability-stack.sh
```
</details>

### Architectural Component Breakdown

#### 1. Documentation Modules (`docs/`)
The `docs/` tree contains **51 exhaustive, production-grade architectural blueprints** organized into 9 functional phases, cross-referenced from [`docs/00-navigation.md`](docs/00-navigation.md):
- **Topologies ([`docs/01-architecture-topologies/`](docs/01-architecture-topologies/README.md))**: Footprint requirements, fault domain behavior, and resource overhead from Single Node OpenShift (SNO) up to massive Hosted Control Planes (HyperShift).
- **Provisioning ([`docs/02-provisioning-paradigms/`](docs/02-provisioning-paradigms/README.md))**: Detailed mechanics of modern Agent-Based Installer (Bootstrap-in-Place) vs Cloud IPI vs legacy UPI vs fleet ZTP with ACM.
- **Networking ([`docs/03-network-and-connectivity/`](docs/03-network-and-connectivity/README.md))**: Forward proxy configuration, `oc-mirror` v2 disconnected mirroring, core air-gap services (BIND9/Chrony), OVN-Kubernetes CNI tuning, and the **Kubernetes Gateway API (`gateway.networking.k8s.io`)** standard.
- **Platforms ([`docs/04-platforms/`](docs/04-platforms/README.md))**: Production recipes for Bare Metal, VMware vSphere 8/9, Nutanix AHV, KVM/RHOSO, AWS, Azure, GCP, Microsoft Hyper-V, and OpenShift Virtualization (KubeVirt & MTV).
- **Day 0 Readiness ([`docs/05-day0-readiness/`](docs/05-day0-readiness/README.md))**: Capacity planning, DNS/load balancing matrices, OpenShift Data Foundation (ODF) architecture, and Helper Node engineering.
- **Day 1 Baselining ([`docs/06-day1-baselining/`](docs/06-day1-baselining/README.md))**: ClusterOperator verification, custom Ingress TLS certs, OIDC identity federation, MachineConfigPool node tuning, automated certificate rotation (cert-manager), and External Secrets (ESO).
- **Day 2 Operations ([`docs/07-day2-operations/`](docs/07-day2-operations/README.md))**: Full observability stack (User Workload Monitoring, Loki, Tempo), CIS compliance, ArgoCD GitOps foundation, automated canary upgrade workflows, GitOps App-of-Apps drift self-healing, and Enterprise AI GPU acceleration (RHOAI & vLLM).
- **Disaster Recovery ([`docs/08-backup-dr-and-rebuild/`](docs/08-backup-dr-and-rebuild/README.md))**: etcd snapshot & restoration, OADP vs vanilla Velero analysis, Metro-DR/Regional-DR, and declarative GitOps disaster recovery.
- **Emergency Runbooks ([`docs/09-emergency-runbooks/`](docs/09-emergency-runbooks/README.md))**: Tactical out-of-band triage and recovery runbooks when the cluster API server is down, covering expired certificates recovery, helper node jumping, node replacement, single-member etcd quorum revival, and MCP storage unsticking.

#### 2. Visual Architecture Blueprints (`assets/`)
The `assets/` directory houses visual architecture blueprints and infographic references:
- **`assets/`**: High-resolution operational architecture blueprints and visual synthesis infographics ([`enterprise-openshift-4-20-day0-to-day2-blueprint.jpg`](assets/enterprise-openshift-4-20-day0-to-day2-blueprint.jpg)) detailing topology sizing, provisioning matrices, Day 1 hardening, Day 2 AI/GitOps operations, and emergency resilience.

#### 3. Declarative Configurations (`configs/`)
The `configs/` tree provides validated, production-grade YAML and daemon templates:
- **`configs/agent-based/`**: Declarative configurations (`agent-config.yaml`, `agent-config-lacp-vlan.yaml`, `install-config-*.yaml`, `ipxe-boot.cfg`) defining static networking, LACP/VLAN NMState, Rendezvous nodes, air-gapped mirrors, and iPXE boot.
- **`configs/ipi-cloud/`**: Enterprise-grade cloud installation manifests utilizing keyless authentication (AWS STS, Azure Workload Identity, GCP Workload Identity Federation).
- **`configs/airgap/`**: Modern `oc-mirror` v2 `ImageSetConfiguration` definitions and local Quay/Harbor registry manifests.
- **`configs/gateway-api/`**: Production Kubernetes Gateway API manifests (`GatewayClass`, `Gateway`, `HTTPRoute` canary split, `GRPCRoute` AI streaming, and `TLSRoute` VM passthrough).
- **`configs/day1/`**: Ready-to-apply Custom Resources for Ingress wildcard TLS, enterprise OIDC identity providers, NTP MachineConfigs, and dedicated infrastructure worker pools.
- **`configs/day2/`**: Declarative definitions for OADP 1.4+ Kopia backup storage locations, automated etcd backup CronJobs, CIS Compliance suites, and cluster autoscaling.
- **`configs/gitops/`**: GitOps Operator subscription and root App-of-Apps custom resources orchestrating cluster configuration.
- **`configs/security/`**: cert-manager ClusterIssuers and External Secrets Operator ClusterSecretStore configurations.
- **`configs/virt/`**: OpenShift Virtualization HyperConverged CR, MTV ForkliftController, and enterprise RHEL 9 VM templates.
- **`configs/ai/`**: NVIDIA GPU Operator ClusterPolicy, RHOAI DataScienceCluster, and vLLM ServingRuntime inference manifests.
- **`configs/observability/`**: Full-stack native observability Custom Resources (User Workload Monitoring, LokiStack 3.x with schema v13, Vector `ClusterLogForwarder`, TempoStack S3 trace storage, `OpenTelemetryCollector` with tail-based sampling, Cluster Observability Operator Korrel8r rules, and eBPF `FlowCollector`).
- **`configs/helper-node/`**: Authoritative BIND9 DNS zones and HAProxy Layer 4 load balancer configurations ready to deploy on bastion infrastructure.

#### 4. Automation Tooling & Operational Scripts ([`scripts/`](scripts/README.md))
The [`scripts/`](scripts/README.md) directory houses 16 ready-to-run automation tools covering the complete lifecycle (see comprehensive engineering documentation in the [Operational Tooling Manual](scripts/README.md)):
- **Preflight & Day 0**: [`scripts/preflight-check.sh`](scripts/preflight-check.sh) audits network prerequisites; [`scripts/generate-agent-iso.sh`](scripts/generate-agent-iso.sh) builds bootable media; [`scripts/mirror-ocp420-airgap.sh`](scripts/mirror-ocp420-airgap.sh) mirrors air-gapped images; [`scripts/deploy-hyperv-vms.ps1`](scripts/deploy-hyperv-vms.ps1) provisions Gen 2 Hyper-V VMs.
- **Post-Install & Day 1**: [`scripts/validate-cluster-health.sh`](scripts/validate-cluster-health.sh) performs health auditing across all cluster operators, storage classes, and worker nodes.
- **Day 2, Upgrades & DR**: [`scripts/etcd-backup.sh`](scripts/etcd-backup.sh) automates control plane snapshots; [`scripts/pre-upgrade-health-check.sh`](scripts/pre-upgrade-health-check.sh) enforces safety gating; [`scripts/automated-cluster-upgrade.sh`](scripts/automated-cluster-upgrade.sh) executes canary-controlled upgrades with Prometheus SLO gating; [`scripts/airgap-upgrade.sh`](scripts/airgap-upgrade.sh) manages disconnected release upgrades; [`scripts/test-oadp-restore.sh`](scripts/test-oadp-restore.sh) automates end-to-end disaster recovery drill verification; [`scripts/verify-observability-stack.sh`](scripts/verify-observability-stack.sh) audits the full-stack native observability fabric (UWM, Loki, Tempo, OTel, Korrel8r).
- **Emergency Operations & Triage**: [`scripts/recover-expired-certs.sh`](scripts/recover-expired-certs.sh) restores expired certificates from the Helper Node; [`scripts/helper-ssh-jump.sh`](scripts/helper-ssh-jump.sh) provides out-of-band SSH and IPMI SOL jumping; [`scripts/replace-control-plane-node.sh`](scripts/replace-control-plane-node.sh) manages master node replacement; [`scripts/reinstall-worker-node.sh`](scripts/reinstall-worker-node.sh) drains and reprovisions workers; [`scripts/emergency-etcd-single-member.sh`](scripts/emergency-etcd-single-member.sh) recovers single-member etcd quorum.

### Lifecycle Alignment Matrix (Day 0, Day 1, Day 2)

| Operational Phase | Focus Areas & Objectives | Primary Documentation Modules | Production Manifests (`configs/`) | Operational Scripts (`scripts/`) |
| :--- | :--- | :--- | :--- | :--- |
| **Day 0: Planning & Provisioning** | Sizing, network design, air-gap mirroring, media generation, bootstrap-in-place | `docs/01-architecture-topologies/`<br/>`docs/02-provisioning-paradigms/`<br/>`docs/03-network-and-connectivity/`<br/>`docs/04-platforms/`<br/>`docs/05-day0-readiness/` | `configs/agent-based/`<br/>`configs/ipi-cloud/`<br/>`configs/upi-vsphere/`<br/>`configs/airgap/`<br/>`configs/helper-node/` | `scripts/preflight-check.sh`<br/>`scripts/generate-agent-iso.sh`<br/>`scripts/mirror-ocp420-airgap.sh`<br/>`scripts/deploy-hyperv-vms.ps1` |
| **Day 1: Hardening & Baselining** | Operator validation, custom PKI Ingress TLS, Gateway API listeners, OIDC SSO, dedicated infra MCPs, ODF storage, cert-manager & ESO | `docs/06-day1-baselining/`<br/>`docs/03-network-and-connectivity/` | `configs/day1/`<br/>`configs/security/`<br/>`configs/gateway-api/` | `scripts/validate-cluster-health.sh` |
| **Day 2: Operations, Upgrades & DR** | Observability, CIS compliance, GitOps App-of-Apps, Gateway API traffic splitting, OpenShift Virt, RHOAI & GPU, etcd backups, OADP DR drills, canary upgrades | `docs/07-day2-operations/`<br/>`docs/08-backup-dr-and-rebuild/` | `configs/day2/`<br/>`configs/gitops/`<br/>`configs/virt/`<br/>`configs/ai/`<br/>`configs/gateway-api/` | `scripts/etcd-backup.sh`<br/>`scripts/pre-upgrade-health-check.sh`<br/>`scripts/automated-cluster-upgrade.sh`<br/>`scripts/airgap-upgrade.sh`<br/>`scripts/test-oadp-restore.sh` |
| **Day 2: Emergency Triage & Recovery** | Expired cert recovery, Helper jumping, master/worker node replacement, single-member etcd recovery, MCP deadlocks | `docs/09-emergency-runbooks/` | `configs/helper-node/` | `scripts/recover-expired-certs.sh`<br/>`scripts/helper-ssh-jump.sh`<br/>`scripts/replace-control-plane-node.sh`<br/>`scripts/reinstall-worker-node.sh`<br/>`scripts/emergency-etcd-single-member.sh` |

---

## Complete End-to-End Master Implementation Workflow (Ordered Step-by-Step)

Regardless of the selected infrastructure or cloud platform, every production OpenShift 4.20 deployment follows this deterministic 10-step enterprise implementation lifecycle:

```mermaid
sequenceDiagram
    autonumber
    actor Admin as Enterprise Architect & SRE
    participant Helper as Helper / Bastion Node
    participant Infra as Target Physical / Cloud Infra
    participant OCP as OpenShift 4.20 Cluster
    participant GitOps as OpenShift GitOps (ArgoCD)

    Admin->>Helper: 1. Deploy Helper Node & Validate Pre-reqs (scripts/preflight-check.sh)
    Admin->>Helper: 2. Generate install-config.yaml & agent-config.yaml
    Admin->>Helper: 3. Build bootable Agent ISO (scripts/generate-agent-iso.sh)
    Admin->>Infra: 4. Mount ISO via Redfish / Virtual Media & boot nodes
    Infra->>OCP: 5. Automated Bootstrap-in-Place & Raft quorum formation
    Admin->>OCP: 6. Day 1 Hardening: Replace Ingress TLS, configure IDP & lock down RBAC
    Admin->>OCP: 7. Carve dedicated Infra MachineConfigPools & deploy ODF storage
    Admin->>GitOps: 8. Establish GitOps App-of-Apps & External Secrets Operator (ESO)
    Admin->>OCP: 9. Configure OADP Backup, etcd CronJob & CIS Compliance scanning
    Admin->>OCP: 10. Execute Automated Lifecycle Upgrades (scripts/automated-cluster-upgrade.sh)
```

### Step 1: Preflight Infrastructure & Network Validation
1. Verify machine subnet allocations, forward DNS (`api`, `api-int`, `*.apps`), and reverse PTR records.
2. Ensure low-latency disk IOPS (<10ms `fdatasync`) on control plane storage.
3. Execute [`scripts/preflight-check.sh`](scripts/preflight-check.sh) from the Helper/Bastion host.

### Step 2: Helper Node / Bastion Service Deployment
1. For on-premises, bare-metal, or air-gapped environments, deploy the Helper Node ([`docs/05-day0-readiness/04-helper-node-architecture.md`](docs/05-day0-readiness/04-helper-node-architecture.md)).
2. Configure authoritative BIND9 DNS, HAProxy load balancing, local Stratum Chrony NTP, and local container mirror registry.

### Step 3: Declarative Configuration Definition
1. Formulate `install-config.yaml` with the chosen platform, network CIDRs, and pull secret.
2. For Agent-Based installations, define `agent-config.yaml` specifying static NMState IP addresses and Rendezvous node.

### Step 4: Installation Media Generation & Boot
1. Build the bootable ISO via [`scripts/generate-agent-iso.sh`](scripts/generate-agent-iso.sh) or execute cloud IPI via `openshift-install create cluster`.
2. For bare-metal/hypervisors, mount `agent.x86_64.iso` via BMC Virtual Media (or [`scripts/deploy-hyperv-vms.ps1`](scripts/deploy-hyperv-vms.ps1) on Hyper-V) and power on all nodes.

### Step 5: Bootstrap-in-Place & Cluster Convergence
1. The Rendezvous node initializes the Assisted Service and starts an ephemeral control plane.
2. Peer master nodes discover the Rendezvous host, format target OS disks, and assemble 3-node etcd quorum.
3. The Rendezvous host pivots into permanent `master-0`.

### Step 6: Day 1 Ingress TLS & Identity Federation
1. Replace default self-signed ingress certificates with enterprise wildcard PKI certificates ([`configs/day1/ingresscontroller-custom-tls.yaml`](configs/day1/ingresscontroller-custom-tls.yaml)).
2. Configure enterprise SSO (Keycloak, Microsoft Entra ID, LDAP) via OAuth ([`configs/day1/idp-keycloak-oidc.yaml`](configs/day1/idp-keycloak-oidc.yaml)).
3. Revoke default `self-provisioner` role and decommission the temporary `kubeadmin` account.

### Step 7: MachineConfigPool Hardening & Storage Provisioning
1. Carve out dedicated `infra` nodes for Ingress, Registry, and Monitoring ([`configs/day1/mcp-infra-nodes.yaml`](configs/day1/mcp-infra-nodes.yaml)).
2. Deploy OpenShift Data Foundation (ODF) for multi-tenant Ceph block (RBD) and file (CephFS) storage classes.

### Step 8: GitOps Foundation & Secret Management
1. Deploy Red Hat OpenShift GitOps (Argo CD 3.5+).
2. Connect Git repository containing declarative manifests under the App-of-Apps pattern.
3. Deploy External Secrets Operator (ESO) to sync secrets dynamically from HashiCorp Vault or Cloud KMS.

### Step 9: Observability, Compliance & Backup Encampment
1. Enable User Workload Monitoring (UWM) and deploy LokiStack + Vector logging.
2. Bind CIS OpenShift Benchmark scans via Compliance Operator ([`configs/day2/compliance-suite-cis.yaml`](configs/day2/compliance-suite-cis.yaml)).
3. Schedule automated daily etcd snapshots ([`configs/day2/etcd-backup-cronjob.yaml`](configs/day2/etcd-backup-cronjob.yaml)) and deploy OADP DataProtectionApplication ([`configs/day2/oadp-dpa-cr.yaml`](configs/day2/oadp-dpa-cr.yaml)).

### Step 10: Automated Lifecycle & Upgrade Orchestration
1. Prior to any cluster upgrade, execute [`scripts/pre-upgrade-health-check.sh`](scripts/pre-upgrade-health-check.sh) to verify operator health, API deprecations, and etcd snapshot freshness.
2. Trigger the automated upgrade via [`scripts/automated-cluster-upgrade.sh`](scripts/automated-cluster-upgrade.sh) to pause worker MCPs, upgrade the control plane CVO, and perform sequential worker node rolling updates.

---

## Complete Documentation Index

The complete documentation suite is divided into 8 focused engineering sections with bidirectional navigation:

### [01. Architecture & Cluster Topologies](docs/01-architecture-topologies/README.md)
Detailed hardware specifications, failure domain behavior, and resource overhead across all topologies:
- [Single Node OpenShift (SNO)](docs/01-architecture-topologies/01-sno-single-node.md): Minimal footprint, far-edge, non-quorum etcd operations.
- [3-Node Compact Converged](docs/01-architecture-topologies/02-compact-3-node-converged.md): Schedulable masters, local ODF Ceph co-location, 1-node failure quorum.
- [Standard Multi-Node HA](docs/01-architecture-topologies/03-standard-ha-multinode.md): Dedicated masters, worker pools, and dedicated 3-node infra pools.
- [Remote Worker Nodes over WAN](docs/01-architecture-topologies/04-remote-workers-wan.md): Latency tolerance (<100ms RTT), heartbeat tuning, edge disconnection resilience.
- [Hosted Control Planes (HyperShift)](docs/01-architecture-topologies/05-hypershift-hosted-cp.md): Running control planes as pods on a central management cluster.

### [02. Provisioning Paradigms](docs/02-provisioning-paradigms/README.md)
Comparison and execution mechanics of modern and legacy installation tools:
- [Agent-Based Installer (ABI)](docs/02-provisioning-paradigms/01-agent-based-installer.md): Bootstrap-in-Place, Rendezvous node, discovery ISO generation.
- [Installer Provisioned Infrastructure (IPI)](docs/02-provisioning-paradigms/02-installer-provisioned-ipi.md): Automated cloud & hypervisor API orchestration.
- [User Provisioned Infrastructure (UPI)](docs/02-provisioning-paradigms/03-user-provisioned-upi.md): Manual VM provisioning and Ignition injection for strict change-control IT.
- [Zero Touch Provisioning (ZTP)](docs/02-provisioning-paradigms/04-ztp-acm-gitops.md): Declarative fleet provisioning via ACM, TALM, and SiteConfig CRDs.

### [03. Network Architecture & Connectivity](docs/03-network-and-connectivity/README.md)
Enterprise network design, proxy bypasses, air-gap mirroring, and CNI performance:
- [Connected with Corporate Proxies](docs/03-network-and-connectivity/01-connected-with-proxies.md): Forward proxy configuration, `noProxy` rules, and custom CA trust injection.
- [Air-Gapped Disconnected Deployments (`oc-mirror` v2)](docs/03-network-and-connectivity/02-air-gapped-oc-mirror-v2.md): OCI catalogs, streaming ephemeral caches, and IDMS manifests.
- [Air-Gapped Core Services](docs/03-network-and-connectivity/03-air-gapped-core-services.md): Split-horizon DNS, Chrony NTP clock sync (<500ms), and internal enterprise PKI.
- [OVN-Kubernetes Tuning](docs/03-network-and-connectivity/04-ovn-kubernetes-tuning.md): MTU sizing (Geneve 100-byte overhead), deterministic EgressIPs, and EgressFirewalls.
- [Kubernetes Gateway API Architecture](docs/03-network-and-connectivity/05-gateway-api-architecture.md): Next-gen role-oriented ingress, weighted canary traffic splits, gRPC AI streaming, VM SNI passthrough, and migration from OpenShift Routes.

### [04. Platform Specific Deployment Guides](docs/04-platforms/README.md)
Exhaustive configuration blueprints across all physical and cloud infrastructures:
- [Bare Metal Physical Hardware](docs/04-platforms/01-bare-metal-physical.md): Dell iDRAC, HPE iLO, Cisco UCS, Redfish Virtual Media automation.
- [VMware vSphere 8.x / 9.x](docs/04-platforms/02-vmware-vsphere.md): vSphere IPI vs ABI, vSAN storage, DRS anti-affinity, and vSphere CSI.
- [Nutanix AHV](docs/04-platforms/03-nutanix-ahv.md): Nutanix IPI, Prism Central integration, Flow security policies, and Nutanix CSI.
- [KVM & OpenStack (RHOSO)](docs/04-platforms/04-kvm-openstack.md): Standalone KVM virt-install and Red Hat OpenStack Services on OpenShift.
- [Amazon Web Services (AWS)](docs/04-platforms/05-aws.md): Private VPC IPI, STS manual credentials mode, and AWS EBS/EFS CSI.
- [Microsoft Azure](docs/04-platforms/06-azure.md): Private VNet, Azure Workload Identity Federation, Accelerated Networking, and Azure Disk CSI.
- [Google Cloud Platform (GCP)](docs/04-platforms/07-gcp.md): Shared VPC Host/Service projects, GCP Workload Identity, and PSC endpoints.
- [Microsoft Hyper-V & Azure Stack HCI](docs/04-platforms/08-microsoft-hyper-v.md): Gen 2 UEFI VM specifications, Secure Boot templates, MAC spoofing for Keepalived VIPs, and PowerShell automation.
- [OpenShift Virtualization (KubeVirt & MTV)](docs/04-platforms/09-openshift-virtualization.md): Collocated VM and container orchestration, live migration, and automated VMware migration via MTV 2.8+.

### [05. Day 0 Infrastructure Readiness](docs/05-day0-readiness/README.md)
Preflight validation and capacity planning:
- [Hardware & Capacity Sizing](docs/05-day0-readiness/01-hardware-and-sizing.md): CPU/RAM quotas, fio disk write latency verification (<10ms fdatasync).
- [DNS & Load Balancing Matrix](docs/05-day0-readiness/02-dns-loadbalancer-matrix.md): Full port mapping tables, VIPs vs external F5/HAProxy load balancers.
- [Storage Architecture & ODF](docs/05-day0-readiness/03-storage-architecture-odf.md): Ceph RBD (Block), CephFS (Shared File), and RGW (S3 Object) storage classes.
- [Helper Node Architecture & Engineering](docs/05-day0-readiness/04-helper-node-architecture.md): When the Bastion/Services node is mandatory (Bare Metal UPI, Air-Gap, Restricted On-Prem) vs eliminated (Public Cloud IPI), and full service configuration (BIND9, HAProxy, Chrony, HTTP).

### [06. Day 1 Post-Install Hardening](docs/06-day1-baselining/README.md)
Baselining, security lockdowns, and enterprise integration:
- [Cluster Operator Verification](docs/06-day1-baselining/01-cluster-operator-hardening.md): Validating all 34+ operators, troubleshooting degraded states.
- [Ingress & Custom Certificates](docs/06-day1-baselining/02-ingress-and-custom-certs.md): Replacing default wildcard certificates with corporate PKI TLS certs.
- [Identity Providers & RBAC Hardening](docs/06-day1-baselining/03-identity-providers-rbac.md): Keycloak/Entra ID OIDC SSO, revoking self-provisioners, deleting `kubeadmin`.
- [MachineConfigPools & Node Tuning](docs/06-day1-baselining/04-machineconfigpools-tuning.md): Dedicated infra node pools, real-time kernels, CPU pinning, and sysctl tuning.
- [Secrets & Automated Certificate Rotation](docs/06-day1-baselining/05-secrets-and-cert-rotation.md): cert-manager automated TLS lifecycle, ACME/Vault ClusterIssuers, and External Secrets Operator (ESO) integration.

### [07. Day 2 Operations & Lifecycle](docs/07-day2-operations/README.md)
Observability, compliance, GitOps, and upgrade management:
- [Enterprise Observability Stack](docs/07-day2-operations/01-observability-stack.md): User Workload Monitoring, LokiStack + Vector logging, Tempo distributed tracing.
- [Security & Compliance](docs/07-day2-operations/02-security-and-compliance.md): Automated CIS Benchmark and NIST SP 800-53 enforcement via Compliance Operator.
- [GitOps Foundation](docs/07-day2-operations/03-gitops-foundation.md): Red Hat OpenShift GitOps (Argo CD 3.5+), App-of-Apps, and External Secrets Operator (ESO).
- [Cluster Lifecycle & Upgrades](docs/07-day2-operations/04-lifecycle-and-upgrades.md): EUS-to-EUS upgrade paths, paused MCP canary rollouts, node drain safety.
- [Automated Upgrades & Pre-Upgrade Mandates](docs/07-day2-operations/05-automated-upgrades.md): Deep architectural rationale for why upgrades must be strictly orchestrated, why fresh etcd snapshots are non-negotiable before upgrading, paused worker MCP rollouts, and automated scripts.
- [GitOps App-of-Apps & Configuration Drift Management](docs/07-day2-operations/06-gitops-app-of-apps.md): Argo CD 3.5+ App-of-Apps pattern, automated drift self-healing, sync waves, and multi-tenant repository segregation.
- [Enterprise AI & GPU Acceleration (RHOAI & vLLM)](docs/07-day2-operations/07-openshift-ai-gpu.md): NVIDIA GPU Operator, time-slicing/MIG, Red Hat OpenShift AI (RHOAI 2.16+), and vLLM ServingRuntime for local LLM inference.

### [08. Disaster Recovery, Backup & GitOps Rebuild](docs/08-backup-dr-and-rebuild/README.md)
RTO/RPO evaluation, etcd restoration, and declarative rebuilding:
- [etcd Backup, Recovery & Quorum Loss](docs/08-backup-dr-and-rebuild/01-etcd-backup-restore.md): Scheduled snapshots and step-by-step 2-node quorum failure recovery.
- [OADP vs Vanilla Velero Deep-Dive](docs/08-backup-dr-and-rebuild/02-oadp-vs-velero-deepdive.md): Exhaustive analysis of why vanilla Velero fails on OpenShift and why OADP is mandatory.
- [Metro-DR & Regional-DR Multi-Cluster](docs/08-backup-dr-and-rebuild/03-metro-dr-and-regional-dr.md): Synchronous Metro-DR (RPO=0) vs Asynchronous Regional-DR with ACM and ODF.
- [Declarative GitOps Rebuild from Scratch](docs/08-backup-dr-and-rebuild/04-declarative-rebuild-gitops.md): Rebuilding entire production clusters in <45 mins from Git repositories.

### [09. Emergency Runbooks & Disaster Troubleshooting](docs/09-emergency-runbooks/README.md)
Tactical out-of-band triage and recovery procedures when the cluster API server is down:
- [Expired Certificates Recovery](docs/09-emergency-runbooks/01-expired-certs-recovery.md): Reviving clusters with expired kubelet certificates after prolonged offline periods via Helper Node SSH.
- [Helper Node Emergency Access & Jumping](docs/09-emergency-runbooks/02-helper-node-access-and-jumping.md): SSH bastion jumping, CoreOS private key management, and IPMI / Redfish Serial-Over-LAN (SOL) consoles.
- [Node Reinstallation & Replacement](docs/09-emergency-runbooks/03-node-reinstallation-and-replacement.md): Safely replacing degraded control plane nodes (etcd member eviction) and workers via CLI, Agent ISO, Web UI, and ACM.
- [etcd Quorum Loss Recovery](docs/09-emergency-runbooks/04-etcd-quorum-loss-recovery.md): Recovering from catastrophic 2-master loss by forcing a single-member etcd cluster leader.
- [MachineConfig & Storage Recovery](docs/09-emergency-runbooks/05-machineconfig-and-storage-recovery.md): Resolving MachineConfigPool deadlocks, drain timeouts, and container storage (`/var/lib/containers`) overlay exhaustion.

---

## Production Automation Scripts & Manifests

All scripts and manifests are ready to execute from this repository:

### Shell Scripts (`scripts/`)

> [!TIP]
> **Complete Operational Manual**: For in-depth architectural breakdowns, motivation, hands-on recipes, ASCII/Mermaid flowcharts, parameter references, and failure triage protocols for all 16 tools, consult the **[Production Automation & Operational Tooling Manual (`scripts/README.md`)](scripts/README.md)**.

| Script | Description | Usage |
| :--- | :--- | :--- |
| [`scripts/preflight-check.sh`](scripts/preflight-check.sh) | Validates DNS, reverse PTR, NTP, proxy settings, and port connectivity. | `./scripts/preflight-check.sh` |
| [`scripts/generate-agent-iso.sh`](scripts/generate-agent-iso.sh) | Validates config and builds bootable Agent-Based Installer ISO. | `TOPOLOGY=compact ./scripts/generate-agent-iso.sh` |
| [`scripts/mirror-ocp420-airgap.sh`](scripts/mirror-ocp420-airgap.sh) | Automates `oc-mirror` v2 mirroring to local Quay/Harbor registry. | `./scripts/mirror-ocp420-airgap.sh` |
| [`scripts/etcd-backup.sh`](scripts/etcd-backup.sh) | Automates etcd snapshots, validates integrity, and enforces retention. | `./scripts/etcd-backup.sh` |
| [`scripts/validate-cluster-health.sh`](scripts/validate-cluster-health.sh) | Audits ClusterOperators, MCPs, Nodes, Ingress, and StorageClasses. | `./scripts/validate-cluster-health.sh` |
| [`scripts/deploy-hyperv-vms.ps1`](scripts/deploy-hyperv-vms.ps1) | Automated PowerShell deployment of Gen 2 OpenShift VMs on Hyper-V. | `.\scripts\deploy-hyperv-vms.ps1` |
| [`scripts/pre-upgrade-health-check.sh`](scripts/pre-upgrade-health-check.sh) | Pre-upgrade audit: validates ClusterOperators, MCPs, etcd backup freshness, deprecated APIs, and firing alerts. | `./scripts/pre-upgrade-health-check.sh` |
| [`scripts/automated-cluster-upgrade.sh`](scripts/automated-cluster-upgrade.sh) | End-to-end upgrade orchestrator: pre-audit -> automated etcd backup -> worker MCP pause -> CVO upgrade -> canary rollout. | `./scripts/automated-cluster-upgrade.sh 4.20.1` |
| [`scripts/airgap-upgrade.sh`](scripts/airgap-upgrade.sh) | Air-gapped upgrade orchestrator: mirrors target release via oc-mirror v2, applies IDMS, and triggers upgrade. | `./scripts/airgap-upgrade.sh 4.20.1` |
| [`scripts/test-oadp-restore.sh`](scripts/test-oadp-restore.sh) | Automated DR verification: provisions drill namespace, creates test workload, executes backup & restore, audits data integrity. | `./scripts/test-oadp-restore.sh` |
| [`scripts/recover-expired-certs.sh`](scripts/recover-expired-certs.sh) | Emergency cert recovery from Helper Node: purges expired kubelet certs, restores bootstrap kubeconfig, approves CSRs. | `./scripts/recover-expired-certs.sh` |
| [`scripts/helper-ssh-jump.sh`](scripts/helper-ssh-jump.sh) | Out-of-band SSH jumping from Helper Node to any cluster node with automatic IPMI Serial-Over-LAN (SOL) fallback. | `./scripts/helper-ssh-jump.sh master-0` |
| [`scripts/replace-control-plane-node.sh`](scripts/replace-control-plane-node.sh) | Control plane node replacement: evicts failed member from etcd quorum, deletes node, auto-approves CSRs for replacement. | `./scripts/replace-control-plane-node.sh master-1.corp.local` |
| [`scripts/reinstall-worker-node.sh`](scripts/reinstall-worker-node.sh) | Worker & infra node replacement: cordons, drains, deletes node, monitors reprovisioning, and auto-approves CSRs. | `./scripts/reinstall-worker-node.sh worker-2.corp.local` |
| [`scripts/emergency-etcd-single-member.sh`](scripts/emergency-etcd-single-member.sh) | Catastrophic quorum recovery: forces a surviving master into a functional 1-node etcd cluster to restore API server. | `./scripts/emergency-etcd-single-member.sh master-0.corp.local` |
| [`scripts/verify-observability-stack.sh`](scripts/verify-observability-stack.sh) | Full-stack observability audit: operators, S3 buckets, UWM exemplars, Vector daemon, Tempo gateway, and TSDB cardinality. | `./scripts/verify-observability-stack.sh` |

### Production Manifests (`configs/`)
- **Agent-Based**: [`configs/agent-based/agent-config.yaml`](configs/agent-based/agent-config.yaml), [`agent-config-lacp-vlan.yaml`](configs/agent-based/agent-config-lacp-vlan.yaml), [`install-config-sno.yaml`](configs/agent-based/install-config-sno.yaml), [`install-config-compact.yaml`](configs/agent-based/install-config-compact.yaml), [`install-config-standard.yaml`](configs/agent-based/install-config-standard.yaml), [`install-config-airgap.yaml`](configs/agent-based/install-config-airgap.yaml), [`ipxe-boot.cfg`](configs/agent-based/ipxe-boot.cfg).
- **Public Cloud IPI**: [`configs/ipi-cloud/aws-install-config.yaml`](configs/ipi-cloud/aws-install-config.yaml), [`azure-install-config.yaml`](configs/ipi-cloud/azure-install-config.yaml), [`gcp-install-config.yaml`](configs/ipi-cloud/gcp-install-config.yaml).
- **Virtualization UPI**: [`configs/upi-vsphere/vsphere-install-config.yaml`](configs/upi-vsphere/vsphere-install-config.yaml).
- **Air-Gapped**: [`configs/airgap/imageset-config-v2.yaml`](configs/airgap/imageset-config-v2.yaml), [`local-registry-quay.yaml`](configs/airgap/local-registry-quay.yaml).
- **Kubernetes Gateway API**: [`configs/gateway-api/gatewayclass-openshift.yaml`](configs/gateway-api/gatewayclass-openshift.yaml), [`configs/gateway-api/enterprise-gateway.yaml`](configs/gateway-api/enterprise-gateway.yaml), [`configs/gateway-api/httproute-canary-split.yaml`](configs/gateway-api/httproute-canary-split.yaml), [`configs/gateway-api/grpcroute-ai-inference.yaml`](configs/gateway-api/grpcroute-ai-inference.yaml), [`configs/gateway-api/tlsroute-vm-passthrough.yaml`](configs/gateway-api/tlsroute-vm-passthrough.yaml).
- **Day 1**: [`configs/day1/machineconfig-chrony.yaml`](configs/day1/machineconfig-chrony.yaml), [`cluster-proxy-trustedca.yaml`](configs/day1/cluster-proxy-trustedca.yaml), [`ingresscontroller-custom-tls.yaml`](configs/day1/ingresscontroller-custom-tls.yaml), [`idp-keycloak-oidc.yaml`](configs/day1/idp-keycloak-oidc.yaml), [`mcp-infra-nodes.yaml`](configs/day1/mcp-infra-nodes.yaml).
- **Day 2**: [`configs/day2/oadp-dpa-cr.yaml`](configs/day2/oadp-dpa-cr.yaml), [`etcd-backup-cronjob.yaml`](configs/day2/etcd-backup-cronjob.yaml), [`compliance-suite-cis.yaml`](configs/day2/compliance-suite-cis.yaml), [`cluster-autoscaler.yaml`](configs/day2/cluster-autoscaler.yaml).
- **GitOps & App-of-Apps**: [`configs/gitops/gitops-operator-sub.yaml`](configs/gitops/gitops-operator-sub.yaml), [`configs/gitops/root-app-of-apps.yaml`](configs/gitops/root-app-of-apps.yaml).
- **Security & Secrets**: [`configs/security/cert-manager-clusterissuer.yaml`](configs/security/cert-manager-clusterissuer.yaml), [`configs/security/external-secrets-store.yaml`](configs/security/external-secrets-store.yaml).
- **OpenShift Virtualization**: [`configs/virt/hyperconverged-cr.yaml`](configs/virt/hyperconverged-cr.yaml), [`configs/virt/mtv-forklift-controller.yaml`](configs/virt/mtv-forklift-controller.yaml), [`configs/virt/vm-rhel9-template.yaml`](configs/virt/vm-rhel9-template.yaml).
- **Enterprise AI & GPU**: [`configs/ai/gpu-operator-clusterpolicy.yaml`](configs/ai/gpu-operator-clusterpolicy.yaml), [`configs/ai/rhoai-datasciencecluster.yaml`](configs/ai/rhoai-datasciencecluster.yaml), [`configs/ai/vllm-serving-runtime.yaml`](configs/ai/vllm-serving-runtime.yaml).
- **Observability**: [`configs/observability/cluster-monitoring-config.yaml`](configs/observability/cluster-monitoring-config.yaml), [`lokistack-cr.yaml`](configs/observability/lokistack-cr.yaml), [`clusterlogforwarder-cr.yaml`](configs/observability/clusterlogforwarder-cr.yaml), [`tempostack-cr.yaml`](configs/observability/tempostack-cr.yaml), [`opentelemetry-collector.yaml`](configs/observability/opentelemetry-collector.yaml), [`coo-ui-correlation.yaml`](configs/observability/coo-ui-correlation.yaml), [`flowcollector-cr.yaml`](configs/observability/flowcollector-cr.yaml).

---

## Technical Deep-Dive: The Velero Question

> [!CAUTION]
> **Can we use vanilla upstream Velero on OpenShift?**
> **Definitive Answer**: **NO.** Upstream Velero is designed strictly for generic vanilla Kubernetes and will critically fail in OpenShift production environments.

### Why Vanilla Velero Fails on OpenShift:
1. **Security Context Constraints (SCC)**: Vanilla Velero node-agent pods are blocked by OpenShift's default `restricted-v2` SCC, preventing host-level backup access.
2. **Proprietary API Groups**: OpenShift uses native CRDs (`route.openshift.io`, `security.openshift.io`, `build.openshift.io`). Upstream Velero fails to preserve internal route TLS certificates and build revisions during restore.
3. **Dynamic UID/GID Allocation**: OpenShift allocates dynamic UID/GID ranges per namespace. Vanilla Velero restores fixed UIDs, causing pods to fail with `CrashLoopBackOff (Permission Denied)`.
4. **The Supported Solution**: **Red Hat OADP (OpenShift API for Data Protection)** integrates Velero with the `openshift-velero-plugin`, custom SCC bindings, and automated CSI VolumeSnapshot integration, backed by full Red Hat 24x7 enterprise support.

---

## Classified Real References & External Standards (September 2026)

### 1. Official Red Hat Product Documentation & Architecture
- [Red Hat OpenShift Container Platform 4.20 Documentation Suite](https://docs.openshift.com/container-platform/4.20/welcome/index.html) — Official product documentation, architectural specifications, and release notes.
- [OpenShift 4.20 Installing with the Agent-based Installer](https://docs.openshift.com/container-platform/4.20/installing/installing_with_agent_based_installer/preparing-to-install-with-agent-based-installer.html) — Bootstrap-in-place workflow, NMState static networking, and rendezvous node assembly.
- [OpenShift 4.20 Disconnected Installation Mirroring with oc-mirror v2](https://docs.openshift.com/container-platform/4.20/installing/disconnected_install/installing-mirroring-disconnected-v2.html) — `ImageSetConfiguration` v2, local OCI streaming cache, and IDMS/ITMS cluster mirroring.
- [OpenShift 4.20 Kubernetes Gateway API Ingress Architecture](https://docs.openshift.com/container-platform/4.20/networking/gateway-api/about-gateway-api.html) — Envoy-backed Ingress Operator GatewayClass, HTTPRoute, GRPCRoute, and TLSRoute specifications.
- [Red Hat OpenShift Service Mesh 3.x (OSSM 3.0 / Istio Gateway API)](https://docs.redhat.com/en/documentation/red_hat_openshift_service_mesh) — Service mesh standardization on Kubernetes Gateway API primitives.
- [Red Hat OpenShift Data Foundation (ODF) 4.16+ Architecture](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation) — Rook-Ceph tri-modal block (RBD), filesystem (CephFS), and object (RGW) storage.
- [Red Hat OpenShift Data Foundation Disaster Recovery (ODF-MCDR)](https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.16/html-single/configuring_openshift_data_foundation_disaster_recovery_for_openshift_workloads/index) — Multi-cluster Metro-DR (synchronous Ceph stretch cluster with Arbiter) and Regional-DR (asynchronous mirroring).
- [Red Hat Advanced Cluster Management for Kubernetes (ACM 2.12+)](https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_management_for_kubernetes) — Multi-cluster fleet governance, ZTP edge site management, and Submariner cross-cluster networking.
- [Red Hat OpenShift API for Data Protection (OADP 1.4+) Guide](https://docs.openshift.com/container-platform/4.20/backup_and_restore/application_backup_and_restore/oadp-features.html) — Enterprise Velero distribution, Kopia data mover, and CSI VolumeSnapshot backup/restore.
- [Red Hat OpenShift Virtualization (KubeVirt 4.16+) Guide](https://docs.openshift.com/container-platform/4.20/virt/about_virt/about-virt.html) — Converged VM hypervisor, L4 SNI routing, live migration, and Migration Toolkit for Virtualization (Forklift).
- [Red Hat OpenShift AI (RHOAI 2.16+) & vLLM ServingRuntime](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed) — Large Language Model serving, KServe v2 open inference protocol, PagedAttention, and continuous batching.
- [Hosted Control Planes (HyperShift) Architecture & Deployment](https://docs.openshift.com/container-platform/4.20/hosted_control_planes/index.html) — Centralized containerized master components, isolated tenant namespaces, and multi-tenant Gateway API exposure.

### 2. Red Hat Knowledgebase (KCS) & Solution Blueprints
- [KCS 4893921: How to recover OpenShift 4 cluster when certificates have expired while cluster was shut down](https://access.redhat.com/solutions/4893921) — Authoritative procedure for recovering control plane and kubelet certificates via out-of-band Helper Node jump.
- [KCS 3985471: Manual renewal and approval of kubelet certificates in OpenShift 4](https://access.redhat.com/solutions/3985471) — Step-by-step renewal of expired node client/server CSRs and bootstrap-kubeconfig restoration.
- [KCS 5493261: OpenShift 4 etcd Disaster Recovery and Quorum Restoration](https://access.redhat.com/solutions/5493261) — Official disaster recovery runbook for recovering from lost etcd quorum and control plane member corruption.
- [KCS 4943941: Restoring an OpenShift 4 cluster from a single surviving control plane node](https://access.redhat.com/solutions/4943941) — Emergency procedure for forcing an etcd single-member cluster to resurrect the API server.
- [KCS 4235891: How to replace an unhealthy control plane (master) node in OpenShift 4](https://access.redhat.com/solutions/4235891) — Removing failed members from etcd membership, de-registering stale nodes, and reprovisioning master replacements.
- [KCS 4652251: How to replace a failed worker or infra node in OpenShift 4](https://access.redhat.com/solutions/4652251) — Safe cordon, drain, Machine resource deletion, and replacement node admission.
- [KCS 4290531: Recommended etcd performance baselines and disk latency troubleshooting](https://access.redhat.com/solutions/4290531) — Fio disk write latency benchmark criteria (fdatasync < 10ms at p99) to prevent Raft leader election failures.
- [KCS 4543781: Best practices for pausing Worker MachineConfigPools during cluster upgrades](https://access.redhat.com/solutions/4543781) — Decoupling control plane upgrades from worker nodes to prevent concurrent rolling reboot outages.
- [KCS 6958471: Migration from oc-mirror v1 to oc-mirror v2 for disconnected clusters](https://access.redhat.com/solutions/6958471) — Architectural shift to v2 OCI streaming format and local workspace cache.
- [KCS 3986601: Setting up corporate proxy and custom CA certificates in OpenShift 4](https://access.redhat.com/solutions/3986601) — Cluster-wide `Proxy` resource, `noProxy` bypass rules, and `additionalTrustBundle` injection.
- [KCS 4771741: Network services and architecture prerequisites for User-Provisioned / Agent-Based Infrastructure](https://access.redhat.com/solutions/4771741) — Authoritative Helper Node requirements for BIND9 DNS, HAProxy L4 load balancing, and Stratum Chrony NTP.

### 3. Open Source Upstream & Core Tooling Repositories
- [Kubernetes Gateway API Standard (`gateway.networking.k8s.io`)](https://gateway-api.sigs.k8s.io/) — Official SIG-Network standard for role-oriented L4/L7 ingress and traffic splitting.
- [OpenShift Cluster Ingress Operator (`openshift/cluster-ingress-operator`)](https://github.com/openshift/cluster-ingress-operator) — Controller managing Envoy and HAProxy routing topologies.
- [Kuadrant Operator & Architecture (`kuadrant/kuadrant-operator`)](https://github.com/Kuadrant/kuadrant-operator) — Multi-cluster API management, Authorino OIDC/RBAC auth, and Limitador rate-limiting on Gateway API.
- [KServe v2 Data Plane Specification (`kserve/kserve`)](https://github.com/kserve/kserve) — Multi-model serving and streaming gRPC open inference protocol.
- [vLLM High-Throughput LLM Engine (`vllm-project/vllm`)](https://github.com/vllm-project/vllm) — PagedAttention memory management, continuous batching, and tensor parallelism engine.
- [KubeVirt Virtualization Engine (`kubevirt/kubevirt`)](https://github.com/kubevirt/kubevirt) — Core runtime enabling VMs to execute as native Kubernetes pods with L4 SNI routing.
- [Forklift Migration Toolkit for Virtualization (`kubevirt/forklift`)](https://github.com/kubevirt/forklift) — Automated bulk migration engine from VMware vSphere and Red Hat Virtualization to KubeVirt.
- [OpenShift HyperShift Engine (`openshift/hypershift`)](https://github.com/openshift/hypershift) — Hosted Control Planes engine decoupling master pods from worker data planes.
- [OpenShift Installer (`openshift/installer`)](https://github.com/openshift/installer) — Core installation engine for Agent-Based, IPI, and UPI workflows.
- [OpenShift Assisted Service (`openshift/assisted-service`)](https://github.com/openshift/assisted-service) — On-premises automated bootstrap-in-place Discovery ISO generation and hardware assembly.
- [OpenShift oc-mirror Plugin CLI v2 (`openshift/oc-mirror`)](https://github.com/openshift/oc-mirror) — Next-generation container image mirroring CLI for air-gapped deployments.
- [OpenShift Machine Config Operator (`openshift/machine-config-operator`)](https://github.com/openshift/machine-config-operator) — Operating system configuration daemon orchestrating RHCOS in-place ostree updates and kernel tunings.
- [OpenShift OVN-Kubernetes CNI Driver (`ovn-org/ovn-kubernetes`)](https://github.com/ovn-org/ovn-kubernetes) — Geneve overlay CNI (UDP 6081) with OpenFlow in-kernel load balancing.
- [OpenShift API for Data Protection Operator (`openshift/oadp-operator`)](https://github.com/openshift/oadp-operator) — Enterprise data protection operator integrating Velero, Kopia, and CSI snapshot drivers.
- [RamenDR Multi-Cluster Disaster Recovery Operator (`ramendr/ramen`)](https://github.com/ramendr/ramen) — Open-source foundation for ODF-MCDR multi-cluster failover and replication.
- [Topology Aware Lifecycle Manager for ZTP (`openshift-kni/cluster-group-upgrades-operator`)](https://github.com/openshift-kni/cluster-group-upgrades-operator) — Fleet-scale progressive upgrades and canary rollout engine for ACM.
- [External Secrets Operator (`external-secrets/external-secrets`)](https://github.com/external-secrets/external-secrets) — Kubernetes operator synchronizing secrets from HashiCorp Vault, AWS Secrets Manager, and Azure Key Vault.
- [cert-manager (`cert-manager/cert-manager`)](https://github.com/cert-manager/cert-manager) — Cloud-native X.509 certificate management for Ingress, Gateway API, and internal mTLS.

### 4. Enterprise Security, Benchmarks & Compliance
- [CIS Red Hat OpenShift Container Platform 4 Benchmark](https://www.cisecurity.org/benchmark/red_hat_openshift) — Prescriptive security configuration benchmarks for control plane, etcd, kubelet, and worker OS hardening.
- [NIST Special Publication 800-53 Rev. 5: Security Controls for Information Systems](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final) — Federal security compliance catalog addressed by the OpenShift Compliance Operator.
- [Red Hat OpenShift Compliance Operator Profiles & Scanning (ComplianceAsCode)](https://github.com/ComplianceAsCode/content) — Declarative automated compliance auditing for CIS, PCI-DSS, and NIST-High profiles.
- [US DoD DISA Container Platform Security Technical Implementation Guide (STIG)](https://public.cyber.mil/stigs/downloads/) — Department of Defense STIG requirements for container host hardening and FIPS 140-3 cryptography.
- [PCI-DSS v4.0 Network Segmentation & TLS Ingress Standards](https://www.pcisecuritystandards.org/) — Payment Card Industry data security standards governing L4/L7 encryption, SNI passthrough, and zero-trust egress.

### 5. Infrastructure Vendor Reference Guides
- [VMware vSphere with Tanzu & OpenShift Best Practices (Broadcom / VMware Core)](https://core.vmware.com) — Architecture guidelines for vSphere 8/9, vSAN CSI integration, and DRS anti-affinity rules.
- [Nutanix OpenShift Reference Architecture (Tech Note TN-2070)](https://www.nutanix.com/solutions/openshift) — Nutanix AHV HCI integration, Nutanix CSI Volumes/Files, and Prism Element/Central management.
- [AWS Security Token Service (STS) with OpenShift IRSA Guide](https://docs.aws.amazon.com/STS/latest/UsingSTS/Welcome.html) — Keyless workload identity federation using IAM Roles for Service Accounts (IRSA).
- [Microsoft Azure Workload Identity Federation for Kubernetes](https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview) — Keyless OIDC federation eliminating Azure client secrets and service principal credentials.
- [Google Cloud Workload Identity Federation for Kubernetes & OpenShift](https://cloud.google.com/iam/docs/workload-identity-federation) — Short-lived Google IAM credentials for OpenShift Cloud Controller Manager and CSI storage drivers.
- [NVIDIA GPU Operator & Container Toolkit Architecture](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html) — GPU provisioning, MIG slicing, DCGM metrics, and CUDA runtime driver lifecycle on OpenShift.

---

## Video Walkthroughs & Architecture References (YouTube)

End-to-end architectural walkthroughs, deep-dive podcasts, and technical shorts for `openshift-4-20-installation-day0-day2` are hosted on the **[Nubenetes YouTube Channel (@nubenetes)](https://www.youtube.com/@nubenetes)**.

Below are the complete video overviews organized by original audio language and format.

### 🇪🇸 Vídeos en Español (Audio Original)

<details open>
<summary>📂 <strong>Recorridos Técnicos y Podcasts en Español (2 Vídeos)</strong></summary>

<br/>

#### 1. OpenShift 4.20 Gateway API: Modernización de Ingress, HTTPRoute y Tráfico L4-L7
- 🔗 **Enlace Directo**: [https://www.youtube.com/watch?v=hUSGPVtyidc](https://www.youtube.com/watch?v=hUSGPVtyidc)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/hUSGPVtyidc/edit](https://studio.youtube.com/video/hUSGPVtyidc/edit)
- ⏱️ **Duración**: 6:06
- 🏷️ **Dominio**: Ingress, Conectividad y Gateway API
- 📝 **Descripción completa**:
> 🌐 Modernización de Tráfico en Red Hat OpenShift 4.20: Kubernetes Gateway API, HTTPRoute y Tráfico L4-L7
>
> Recorrido arquitectónico técnico en español dedicado a la evolución del enrutamiento de red en Red Hat OpenShift 4.20. Analizamos la transición definitiva desde las tradicionales Ingress y Routes monolíticas hacia el estándar Kubernetes Gateway API.
>
> 📌 Puntos Clave de la Sesión:
> • Evolución del Modelo de Ingress: Por qué las anotaciones complejas de Ingress son reemplazadas por objetos nativos declarativos y seguros.
> • Arquitectura de Roles Desacoplados: Separación de responsabilidades entre el Administrador de Infraestructura (GatewayClass), el Operador de Plataforma (Gateway) y el Desarrollador (HTTPRoute, GRPCRoute).
> • Soporte Multitenancy y Cross-Namespace: ReferenceGrant para autorizar de forma segura conexiones entre rutas y pasarelas en diferentes espacios de nombres.
> • Control de Tráfico Avanzado: Enrutamiento ponderado para despliegues Canary, reescritura de cabeceras, redirecciones y división de tráfico sin recargas de configuración.
> • Enrutamiento L4 y Cifrado Zero-Trust: TLSRoute con passthrough SNI sin necesidad de exponer certificados privados en el borde.
>
> 🔗 Repositorio y Manifiestos de Red:
> • Módulo de Red y Gateway API: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/docs/03-network-and-connectivity
> • Repositorio Completo: https://github.com/nubenetes/openshift-4-20-installation-day0-day2
>
> ⏱️ Duración: 6:06
> #OpenShift #GatewayAPI #Kubernetes #HTTPRoute #Networking #RedHat #DevOps #SRE #TraficoCloud #CloudNative

#### 2. Podcast Arquitectura OpenShift 4.20: Guía Completa Day 0 a Day 2 y Resiliencia
- 🔗 **Enlace Directo**: [https://www.youtube.com/watch?v=zFRMP6N0-Aw](https://www.youtube.com/watch?v=zFRMP6N0-Aw)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/zFRMP6N0-Aw/edit](https://studio.youtube.com/video/zFRMP6N0-Aw/edit)
- ⏱️ **Duración**: 16:03
- 🏷️ **Dominio**: Podcast de Arquitectura (Audio) - Day 0 a Day 2 y Resiliencia
- 📝 **Descripción completa**:
> 🎙️ Podcast de Arquitectura Técnica: Red Hat OpenShift 4.20 de Day 0 a Day 2 y Resiliencia Empresarial
>
> Episodio completo en formato podcast técnico en español (sin diapositivas, diseñado para escuchar en movilidad) analizando la arquitectura integral de Red Hat OpenShift 4.20. Una conversación profunda y analítica para arquitectos de plataforma, líderes técnicos y equipos SRE sobre cómo diseñar, desplegar y operar clusters de misión crítica en centros de datos modernos y nubes privadas.
>
> 📌 Temas Clave Tratados en este Episodio:
> • Evolución Arquitectónica de OpenShift 4.20: Novedades del núcleo, CoreOS inmutable, operadores declarativos y gestión desacoplada.
> • Decisiones Críticas en Day 0: Dimensionamiento de infraestructura física y virtual (Bare Metal, VMware vSphere, Nutanix, Hyper-V), diseño de redes sin solapamiento CIDR y validación pre-flight de latencia de almacenamiento.
> • Paradigmas de Instalación: Del instalador asistido y UPI al nuevo Agent-Based Installer (ABI) con Bootstrap-in-Place y sin máquinas virtuales temporales.
> • Modernización de Red e Ingress: La transición hacia Kubernetes Gateway API, HTTPRoute ponderado para despliegues Canary y TLSRoute para cifrado de extremo a extremo sin exponer certificados privados.
> • Endurecimiento Day 1 y Operaciones Day 2: Integración de proveedores de identidad corporativos (Keycloak, Microsoft Entra ID), revocación de permisos por defecto, GitOps con Argo CD y observabilidad centralizada con Thanos y Loki.
> • Protocolos de Supervivencia y Disaster Recovery: Estrategias ante pérdida de quórum en etcd, copias de seguridad consistentes con OADP y Kopia, y restauración fuera de banda ante caídas del servidor API.
>
> 🔗 Repositorio Completo de Arquitectura y Scripts:
> • Repositorio Oficial: https://github.com/nubenetes/openshift-4-20-installation-day0-day2
> • Manual de Automatización: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/scripts
>
> ⏱️ Duración: 16:03
> #OpenShift #Podcast #Kubernetes #RedHat #ArquitecturaCloud #DevOps #SRE #PlatformEngineering #Sysadmin #CloudNative #GitOps

</details>

<br/>

### 🇬🇧 Videos in English (Original Audio)

<details open>
<summary>📂 <strong>Full-Length Technical Deep Dives & Architecture Masterclasses (11 Videos)</strong></summary>

<br/>

#### 1. OpenShift 4.20 On-Premises Architecture: Bare Metal, VMware, Nutanix and Hyper-V
- 🔗 **Direct Link**: [https://www.youtube.com/watch?v=RQ2AXSzGRzE](https://www.youtube.com/watch?v=RQ2AXSzGRzE)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/RQ2AXSzGRzE/edit](https://studio.youtube.com/video/RQ2AXSzGRzE/edit)
- ⏱️ **Duration**: 8:48
- 🏷️ **Domain**: Datacenter Platforms, Bare Metal & Hypervisors
- 📝 **Full Description**:
> 🏛️ Enterprise Architecture Deep Dive: Red Hat OpenShift 4.20 on Bare Metal, VMware, Nutanix and Hyper-V
>
> An exhaustive architectural reference and on-premises engineering masterclass for Red Hat OpenShift Container Platform (OCP) 4.20. Learn how enterprise platform architects design, size, and deploy resilient OpenShift clusters across diverse physical and virtualized enterprise infrastructure.
>
> 📌 Key Architectural Domains Explored:
> • Bare Metal Performance Deployments: Direct hardware installation, NUMA tuning, SR-IOV high-speed networking, and BIOS baselining for low-latency workloads.
> • VMware vSphere 8 and 9 Enterprise Integration: Automated Installer-Provisioned Infrastructure (IPI) vs User-Provisioned Infrastructure (UPI), vSAN storage policies, and DRS anti-affinity.
> • Nutanix AHV Hyper-Converged Architecture: Prism Element and Central integration, Nutanix CSI volume drivers, and unified storage fabric configuration.
> • Microsoft Hyper-V and Azure Stack HCI: Enterprise edge deployments, virtual switch bridging, and hybrid cloud connectivity.
> • Multi-Platform Decision Framework: Choosing the optimal deployment paradigm based on enterprise SLAs, operational complexity, and infrastructure cost.
>
> 🔗 Source Code and Architecture Manifests:
> • Documentation and Configs: https://github.com/nubenetes/openshift-4-20-installation-day0-day2
> • Platform Modules: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/docs/04-platforms
>
> ⏱️ Duration: 8:48
> #OpenShift #RedHat #Kubernetes #BareMetal #VMware #vSphere #Nutanix #HyperV #CloudNative #DevOps #PlatformEngineering

#### 2. OpenShift 4.20 Topologies and Provisioning: SNO, Compact, HyperShift and ABI
- 🔗 **Direct Link**: [https://www.youtube.com/watch?v=rSIj_iOT56o](https://www.youtube.com/watch?v=rSIj_iOT56o)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/rSIj_iOT56o/edit](https://studio.youtube.com/video/rSIj_iOT56o/edit)
- ⏱️ **Duration**: 9:31
- 🏷️ **Domain**: Deployment Topologies & Provisioning Paradigms
- 📝 **Full Description**:
> 📐 OpenShift 4.20 Topology and Provisioning Matrix: SNO, Compact, HyperShift and Agent-Based Installer
>
> A comprehensive architectural walkthrough analyzing the deployment topology options and automated provisioning paradigms in Red Hat OpenShift 4.20. Discover how to architect everything from single-node edge instances to massive enterprise clusters with decoupled control planes.
>
> 📌 Core Architectural Topics:
> • OpenShift Deployment Topologies: Single Node OpenShift (SNO), 3-Node Compact Clusters, Standard HA (3 Control Plane plus N Worker Nodes), and Remote Worker Nodes over WAN.
> • HyperShift and Hosted Control Planes: Decoupling master control planes from worker data planes, reducing infrastructure overhead and provisioning clusters in minutes.
> • Provisioning Paradigms Comparison: Full IPI automation, custom UPI integration, Assisted Installer workflows, and Agent-Based Installer (ABI).
> • Automated Hardware Discovery: Using ABI with Discovery ISOs to install air-gapped clusters without requiring external bootstrap virtual machines.
> • Production Topology Sizing: Calculating CPU, memory, etcd IOPS baselines, and control plane quorum requirements for mission-critical enterprise workloads.
>
> 🔗 Architecture Modules and Guides:
> • Topology Reference: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/docs/01-architecture-topologies
> • Provisioning Handbook: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/docs/02-provisioning-paradigms
>
> ⏱️ Duration: 9:31
> #OpenShift #Kubernetes #HyperShift #HostedControlPlanes #SNO #DevOps #SRE #PlatformEngineering #RedHat #GitOps

#### 3. OpenShift 4.20 Disaster Recovery Guide: etcd Quorum Loss, OADP and Emergency Runbooks
- 🔗 **Direct Link**: [https://www.youtube.com/watch?v=IdGKv4tPVH0](https://www.youtube.com/watch?v=IdGKv4tPVH0)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/IdGKv4tPVH0/edit](https://studio.youtube.com/video/IdGKv4tPVH0/edit)
- ⏱️ **Duration**: 7:45
- 🏷️ **Domain**: Backup, Disaster Recovery & Emergency Operations
- 📝 **Full Description**:
> 🚨 Red Hat OpenShift 4.20 Disaster Recovery Field Manual: etcd Quorum Loss, OADP and Emergency Runbooks
>
> The definitive operational survival guide for OpenShift 4.20 platform architects and SREs. Learn the step-by-step protocols required to maintain high availability, execute automated backup drills, and resurrect dead clusters when the Kubernetes API server is completely unreachable.
>
> 📌 Disaster Recovery Protocols Covered:
> • etcd Quorum Loss and Cluster Resurrection: Performing single-member recovery on control plane nodes to restore consensus without data corruption.
> • OADP and Kopia Architecture: OpenShift API for Data Protection, Velero integration, Security Context Constraints (SCC) preservation, and volume snapshotting.
> • Automated etcd Backup Schedules: Systemd timers, CronJobs, and local encrypted state preservation.
> • Expired PKI Certificate Recovery: Using the authoritative Helper Node SSH jump host to renew expired control plane and kubelet CSRs.
> • Failover Topologies: Metro-DR synchronous replication with OpenShift Data Foundation (ODF) vs Regional-DR asynchronous cross-site migration.
>
> 🔗 Emergency Scripts and Recovery Docs:
> • Disaster Recovery Guide: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/docs/08-backup-dr-and-rebuild
> • Emergency Runbooks: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/docs/09-emergency-runbooks
>
> ⏱️ Duration: 7:45
> #OpenShift #DisasterRecovery #etcd #OADP #Velero #Kubernetes #SRE #DevOps #RedHat #EmergencyRunbook

#### 4. OpenShift 4.20 Day 0 Readiness: Air-Gapped Mirroring, DNS, NTP and Preflight Architecture
- 🔗 **Direct Link**: [https://www.youtube.com/watch?v=h13w4e_Qx1U](https://www.youtube.com/watch?v=h13w4e_Qx1U)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/h13w4e_Qx1U/edit](https://studio.youtube.com/video/h13w4e_Qx1U/edit)
- ⏱️ **Duration**: 7:25
- 🏷️ **Domain**: Day 0 Readiness, Networking Services & Preflight
- 📝 **Full Description**:
> 🛡️ Day 0 Readiness Foundation for OpenShift 4.20: Air-Gapped Mirroring, DNS, NTP and Preflight Architecture
>
> Master the essential pre-flight architectural decisions that make or break an enterprise OpenShift deployment before a single node boots. Learn how to architect authoritative network services, validate hardware latencies, and prepare air-gapped container image registries.
>
> 📌 Day 0 Architectural Pillars:
> • Disconnected Air-Gapped Tooling: oc-mirror v2 OCI streaming workflows, ImageContentSourcePolicy, and local container mirror management.
> • Authoritative Network Services: Enterprise BIND9 DNS split-horizon architecture, HAProxy L4 load balancing, and Stratum Chrony NTP synchronization.
> • Preflight Validation Tooling: Benchmarking disk write latency with fio (fdatasync under 10ms at p99) to prevent etcd Raft leader election drops.
> • IPAM and Subnet Planning: MachineNetwork, ServiceNetwork, and ClusterNetwork CIDR non-overlapping routing and Geneve overlay encapsulation.
> • Production Readiness Checklists: Automated shell validation scripts for ports, firewall policies, and MTU parity.
>
> 🔗 Day 0 Architecture Modules:
> • Readiness Guide: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/docs/05-day0-readiness
> • Preflight Scripts: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/scripts
>
> ⏱️ Duration: 7:25
> #OpenShift #Day0 #AirGapped #ocmirror #Kubernetes #Networking #DNS #Sysadmin #DevOps #RedHat

#### 5. Kubernetes Gateway API on OpenShift 4.20: Day 0 to Day 2 Ingress and Traffic Engineering
- 🔗 **Direct Link**: [https://www.youtube.com/watch?v=GrCoDGJ8YiQ](https://www.youtube.com/watch?v=GrCoDGJ8YiQ)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/GrCoDGJ8YiQ/edit](https://studio.youtube.com/video/GrCoDGJ8YiQ/edit)
- ⏱️ **Duration**: 9:47
- 🏷️ **Domain**: Ingress Architecture, Traffic Engineering & Security
- 📝 **Full Description**:
> ⚡ End-to-End Kubernetes Gateway API on OpenShift 4.20: Day 0 to Day 2 Ingress Architecture
>
> An exhaustive architectural masterclass deconstructing how Red Hat OpenShift 4.20 implements the official Kubernetes Gateway API standard. Learn how to architect, provision, and operate role-oriented ingress traffic controllers from Day 0 setup to Day 2 production rollouts.
>
> 📌 Comprehensive Technical Exploration:
> • Core Custom Resource Hierarchy: GatewayClass parameters, Gateway lifecycle controller, and application route bindings (HTTPRoute, GRPCRoute, TLSRoute, TCPRoute).
> • Zero-Downtime Traffic Engineering: Native percentage-based traffic splitting for canary deployments, header matching, path rewrites, and request mirroring.
> • Edge vs Backend Security: Kuadrant integration, Authorino OIDC/RBAC enforcement, Limitador rate-limiting, and end-to-end mTLS.
> • Cross-Namespace Security with ReferenceGrant: Enforcing explicit zero-trust boundaries across multi-tenant enterprise business units.
> • Day 2 Telemetry and Observability: Ingress controller latency metrics, Prometheus SLO alerting, and Envoy access log aggregation.
>
> 🔗 Architectural Guides and Manifests:
> • Gateway API Architecture: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/blob/main/docs/03-network-and-connectivity/05-gateway-api-architecture.md
> • Ingress Configurations: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/configs
>
> ⏱️ Duration: 9:47
> #GatewayAPI #OpenShift #Kubernetes #Ingress #HTTPRoute #GRPCRoute #TLSRoute #CloudNative #DevOps #SRE

#### 6. OpenShift 4.20 Day 1 Hardening: Custom Ingress PKI, Enterprise IdP, RBAC and MCPs
- 🔗 **Direct Link**: [https://www.youtube.com/watch?v=E9eV9CHYYPE](https://www.youtube.com/watch?v=E9eV9CHYYPE)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/E9eV9CHYYPE/edit](https://studio.youtube.com/video/E9eV9CHYYPE/edit)
- ⏱️ **Duration**: 6:30
- 🏷️ **Domain**: Day 1 Post-Installation Hardening & Baselining
- 📝 **Full Description**:
> 🛡️ OpenShift 4.20 Day 1 Post-Installation Hardening: Custom PKI, Enterprise IdP, RBAC and MCPs
>
> An exhaustive architectural reference and Day 1 operational guide for Red Hat OpenShift Container Platform 4.20. Learn how enterprise platform engineers and SREs baseline and harden a newly provisioned cluster into a secure, production-grade enterprise platform immediately after installation.
>
> 📌 Key Day 1 Hardening Modules Covered:
> • Cluster Operator Verification: Validating degraded conditions, version progression, and operator stability across all core subsystems.
> • Custom Ingress PKI and TLS: Replacing default ingress wildcards with trusted Enterprise CA certificates and automating renewal workflows via cert-manager.
> • Enterprise Identity Providers and RBAC: Integrating OIDC/Keycloak and Microsoft Entra ID, disabling the default kubeadmin backdoor, and revoking cluster-wide self-provisioner permissions.
> • MachineConfigPool Partitioning: Isolating Infra, Storage, and Edge worker nodes with custom MachineConfigs, kernel arguments, and tuned profiles.
> • Enterprise Secret Management: Decoupling sensitive credentials using External Secrets Operator (ESO) with HashiCorp Vault backend integration.
>
> 🔗 Source Code and Day 1 Manifests:
> • Day 1 Baselining Guide: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/docs/06-day1-baselining
> • Complete Architecture Repository: https://github.com/nubenetes/openshift-4-20-installation-day0-day2
>
> ⏱️ Duration: 6:30
> #OpenShift #Day1 #Hardening #Kubernetes #Security #RBAC #MachineConfig #certmanager #ExternalSecrets #DevOps #SRE #RedHat

#### 7. OpenShift 4.20 Day 2 Operations: Observability, GitOps, EUS Upgrades and OpenShift AI
- 🔗 **Direct Link**: [https://www.youtube.com/watch?v=9MHiGiQcqH0](https://www.youtube.com/watch?v=9MHiGiQcqH0)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/9MHiGiQcqH0/edit](https://studio.youtube.com/video/9MHiGiQcqH0/edit)
- ⏱️ **Duration**: 6:44
- 🏷️ **Domain**: Day 2 Operations, Fleet Management & Lifecycle
- 📝 **Full Description**:
> ⚙️ OpenShift 4.20 Day 2 Operations and Fleet Management: Observability, GitOps, Upgrades and AI
>
> The definitive operational reference for day-to-day cluster administration, enterprise fleet management, and continuous lifecycle maintenance in Red Hat OpenShift 4.20. Discover how platform teams scale observability, enforce compliance, automate EUS upgrades, and orchestrate GPU-accelerated AI inference.
>
> 📌 Core Day 2 Operational Pillars:
> • Full-Stack Enterprise Observability: Configuring User Workload Monitoring (UWM), Thanos cross-cluster aggregation, LokiStack centralized logging, and OpenTelemetry distributed tracing.
> • Security and Compliance Governance: Automating CIS Kubernetes benchmarks and NIST controls using the Compliance Operator and File Integrity Operator (AIDE).
> • GitOps Foundation and Fleet Orchestration: Standardizing multi-cluster configurations using OpenShift GitOps (Argo CD) and the App-of-Apps architectural pattern.
> • Automated EUS-to-EUS Upgrades: Safely executing OpenShift 4.18 to 4.20 Extended Update Support migrations using paused MachineConfigPools and controlled canary worker waves.
> • Red Hat OpenShift AI (RHOAI) and GPU Infrastructure: Deploying the NVIDIA GPU Operator, Node Feature Discovery, and vLLM / KServe model serving pipelines for enterprise LLMs.
>
> 🔗 Architectural Guides and Manifests:
> • Day 2 Operations Handbook: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/docs/07-day2-operations
> • Complete Architecture Repository: https://github.com/nubenetes/openshift-4-20-installation-day0-day2
>
> ⏱️ Duration: 6:44
> #OpenShift #Day2 #Kubernetes #GitOps #ArgoCD #Observability #OpenShiftAI #RHOAI #DevOps #SRE #PlatformEngineering #RedHat

#### 8. OpenShift 4.20 Agent-Based Installer: Bootstrap-in-Place, NMState and Rendezvous Node
- 🔗 **Direct Link**: [https://www.youtube.com/watch?v=P1fjbXD2xbQ](https://www.youtube.com/watch?v=P1fjbXD2xbQ)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/P1fjbXD2xbQ/edit](https://studio.youtube.com/video/P1fjbXD2xbQ/edit)
- ⏱️ **Duration**: 6:32
- 🏷️ **Domain**: Provisioning Paradigms & Agent-Based Installer (ABI)
- 📝 **Full Description**:
> ⚡ Red Hat OpenShift 4.20 Agent-Based Installer: Bootstrap-in-Place, NMState and Rendezvous Architecture
>
> An exhaustive architectural deep dive into the modern Agent-Based Installer (ABI) for Red Hat OpenShift Container Platform 4.20. Discover how ABI revolutionizes bare-metal, edge, and air-gapped datacenter provisioning by completely eliminating the need for an external bootstrap virtual machine.
>
> 📌 Key Architectural Topics Explored:
> • Bootstrap-in-Place Mechanism: How Node 0 boots into RAM via the Discovery ISO, executes temporary control plane bootstrap services, and seamlessly pivots into a permanent master.
> • Rendezvous Node Coordination: Distributed consensus and hardware discovery without external orchestration servers or cloud dependencies.
> • Declarative agent-config.yaml: Configuring static NMState IP baselines, LACP bonding (802.3ad), VLAN tagging, and MTU 9000 jumbo frames before OS installation.
> • Air-Gapped and Disconnected Readiness: Embedding ignition configs and container images into a self-contained bootable ISO.
> • SNO, Compact and Distributed Targets: Deploying Single Node OpenShift, 3-node compact clusters, or multi-node enterprise environments with a single boot image.
>
> 🔗 Architecture Docs and Manifests:
> • Agent-Based Installer Guide: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/blob/main/docs/02-provisioning-paradigms/01-agent-based-installer.md
> • Production agent-config YAML: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/configs/agent-based
> • ISO Generation Script: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/blob/main/scripts/generate-agent-iso.sh
>
> ⏱️ Duration: 6:32
> #OpenShift #BareMetal #AgentBasedInstaller #Kubernetes #NMState #RedHat #DevOps #SRE #PlatformEngineering #Sysadmin

#### 9. OpenShift 4.20 Installer Guide: All Provisioning Scenarios, Topologies and Platforms
- 🔗 **Direct Link**: [https://www.youtube.com/watch?v=btCpgLINTZM](https://www.youtube.com/watch?v=btCpgLINTZM)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/btCpgLINTZM/edit](https://studio.youtube.com/video/btCpgLINTZM/edit)
- ⏱️ **Duration**: 9:10
- 🏷️ **Domain**: Provisioning Paradigms, Multi-Platform & Topologies
- 📝 **Full Description**:
> 🏛️ Complete OpenShift 4.20 Installer Masterclass: All Provisioning Scenarios, Topologies and Platforms
>
> The definitive architectural masterclass comparing every installation paradigm, topology model, and infrastructure target in Red Hat OpenShift 4.20. Learn how enterprise platform architects choose the perfect deployment pattern based on operational complexity, latency requirements, and SLA tiers.
>
> 📌 Comprehensive Architectural Comparison Matrix:
> • Provisioning Paradigms Deconstructed: Automated Installer-Provisioned Infrastructure (IPI), User-Provisioned Infrastructure (UPI), Assisted Installer, and Agent-Based Installer (ABI).
> • Deployment Topologies Evaluated: Single Node OpenShift (SNO), 3-Node Compact Clusters, Standard High-Availability (3 Masters plus N Workers), and HyperShift Hosted Control Planes (HCP).
> • HyperShift Architecture: Centralizing control planes as containerized pods to reduce infrastructure footprint and provision enterprise clusters in under 15 minutes.
> • Multi-Target Support: Bare Metal direct deployments, VMware vSphere 8/9, Nutanix AHV, Microsoft Hyper-V, and Keyless Cloud IPI (AWS, GCP, Azure).
> • Decision Framework: Balancing automated lifecycle management against custom enterprise network and storage requirements.
>
> 🔗 Complete Implementation Repository:
> • Topologies Handbook: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/docs/01-architecture-topologies
> • Provisioning Guides: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/docs/02-provisioning-paradigms
> • Full Repository Blueprint: https://github.com/nubenetes/openshift-4-20-installation-day0-day2
>
> ⏱️ Duration: 9:10
> #OpenShift #Kubernetes #HyperShift #BareMetal #VMware #IPI #UPI #AgentBasedInstaller #DevOps #SRE #PlatformEngineering #RedHat

#### 10. The OpenShift 4.20 Architecture Podcast: Complete Day 0 to Day 2 Enterprise Masterclass
- 🔗 **Direct Link**: [https://www.youtube.com/watch?v=avJB3NqaEFg](https://www.youtube.com/watch?v=avJB3NqaEFg)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/avJB3NqaEFg/edit](https://studio.youtube.com/video/avJB3NqaEFg/edit)
- ⏱️ **Duration**: 55:38
- 🏷️ **Domain**: Architecture Podcast (Audio) - Complete Day 0 to Day 2 Masterclass
- 📝 **Full Description**:
> 🎙️ The Definitive OpenShift 4.20 Architecture Podcast: Complete Day 0 to Day 2 Enterprise Masterclass
>
> An exhaustive, 55-minute technical audio podcast masterclass (audio-first format without slides, optimized for listening during your commute or engineering sessions) deconstructing the entire enterprise architecture of Red Hat OpenShift Container Platform 4.20.
>
> Designed for Principal Architects, Lead Platform Engineers, and Senior SREs, this deep dive explores the hard-earned lessons, trade-offs, and operational realities of running mission-critical OpenShift clusters across on-premises datacenters, hybrid clouds, and disconnected air-gapped environments.
>
> 📌 Architectural Modules and Discussion Roadmap:
> • Core Architectural Philosophy: Immutable Red Hat Enterprise Linux CoreOS (RHCOS), Machine Config Operator mechanics, and self-healing cluster operator control loops.
> • Infrastructure Targets and Topology Matrix: Sizing and deploying Single Node OpenShift (SNO), 3-Node Compact Converged, Standard HA clusters, and HyperShift Hosted Control Planes (HCP) across Bare Metal, VMware vSphere 8/9, Nutanix AHV, and Microsoft Hyper-V.
> • Provisioning Evolution: Deep dive into the Agent-Based Installer (ABI), Rendezvous Node consensus, and why Bootstrap-in-Place eliminates external bootstrap virtual machines forever.
> • Air-Gapped and Disconnected Operations: High-speed OCI streaming with oc-mirror v2, split-horizon BIND9 DNS, Stratum NTP baselines, and fio disk latency requirements (fdatasync under 10ms at p99).
> • Ingress Modernization with Kubernetes Gateway API: Moving away from legacy monolithic Ingress and Routes toward declarative GatewayClasses, HTTPRoute canary percentage splits, GRPCRoute submillisecond token streaming for generative AI (vLLM), and TLSRoute SNI passthrough.
> • Day 1 Post-Install Hardening: Replacing default wildcard certs with trusted Enterprise CAs via cert-manager, OIDC/Keycloak identity providers, disabling kubeadmin, and creating specialized MachineConfigPools.
> • Day 2 Fleet Operations and GitOps: Fleet orchestration using Argo CD and the App-of-Apps pattern, full-stack observability with Thanos, LokiStack, and OpenTelemetry, and executing automated EUS-to-EUS upgrades (4.18 to 4.20) with paused worker canary waves.
> • Disaster Recovery and Out-of-Band Incident Triage: etcd Raft quorum recovery, OADP with Kopia filesystem backup engines, expired certificate rescue, and IPMI Serial-over-LAN hardware access.
>
> 🔗 Complete Source Code and Architecture Manifests:
> • GitHub Blueprint Repository: https://github.com/nubenetes/openshift-4-20-installation-day0-day2
> • Scripts and Runbooks: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/scripts
>
> ⏱️ Duration: 55:38
> #OpenShift #Podcast #Kubernetes #RedHat #DevOps #SRE #PlatformEngineering #CloudNative #BareMetal #HyperShift #GatewayAPI #GitOps #Sysadmin

#### 11. OpenShift 4.20 Native Observability: Prometheus, LokiStack, Tempo and Korrel8r
- 🔗 **Direct Link**: [https://www.youtube.com/watch?v=wAcbEyMQ76M](https://www.youtube.com/watch?v=wAcbEyMQ76M)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/wAcbEyMQ76M/edit](https://studio.youtube.com/video/wAcbEyMQ76M/edit)
- ⏱️ **Duration**: 6:46
- 🏷️ **Domain**: Day 2 Native Observability, Metrics, Logs, Traces & Correlation
- 📝 **Full Description**:
> 📊 Complete OpenShift 4.20 Native Observability Stack: Prometheus, LokiStack, Tempo and Korrel8r
>
> An exhaustive architectural masterclass exploring the next-generation native telemetry fabric in Red Hat OpenShift Container Platform 4.20. Learn how platform engineers deploy, configure, and correlate metrics, structured logs, and distributed traces into a unified single-pane-of-glass observability pipeline.
>
> 📌 Key Observability Pillars Deconstructed:
> • Cluster Monitoring & User Workload Monitoring: Scraping platform and tenant metrics with Prometheus, tuning scrape intervals, and enforcing label relabelings to eliminate cardinality explosions.
> • OpenShift Logging 6.x Architecture: High-performance log collection with Vector in Rust, stream routing via ClusterLogForwarder, and multi-tenant indexing in LokiStack 3.x with S3 object storage.
> • Distributed Tracing with OpenTelemetry: Deploying the Red Hat OpenTelemetry Collector with tail-based sampling rules to capture 100 percent of latency spikes and errors while dropping noisy spans.
> • Trace Storage with TempoStack: Massively scalable, cost-efficient trace persistence on unified Ceph/S3 object storage fabrics.
> • Unified Correlation with Korrel8r: Leveraging the Cluster Observability Operator (COO) to jump instantly from a Prometheus alert to matching Loki logs and root-cause Tempo distributed traces in OpenShift Web Console.
>
> 🔗 Architecture Docs and Production Manifests:
> • Observability Architecture Guide: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/blob/main/docs/07-day2-operations/01-observability-stack.md
> • Production YAML Manifests: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/configs/observability
> • Automated Health Verification Script: https://github.com/nubenetes/openshift-4-20-installation-day0-day2/blob/main/scripts/verify-observability-stack.sh
>
> ⏱️ Duration: 6:46
> #OpenShift #Observability #Prometheus #Loki #Grafana #OpenTelemetry #Tempo #SRE #DevOps #Kubernetes #RedHat #Vector #Thanos

</details>

<br/>

### ⚡ Architecture & Automation Video Shorts (20 Shorts)

<details open>
<summary>📂 <strong>Technical Video Shorts Breakdown (20 Shorts)</strong></summary>

<br/>

#### 1. How Single-Member etcd Recovery Resurrects Dead OpenShift Clusters
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/_tAdfH_sNio](https://www.youtube.com/shorts/_tAdfH_sNio)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/_tAdfH_sNio/edit](https://studio.youtube.com/video/_tAdfH_sNio/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:15
- 🏷️ **Domain**: Disaster Recovery & Emergency Operations
- 📝 **Full Description**:
> 🚨 How Single-Member etcd Recovery Resurrects Dead OpenShift Clusters!
>
> What happens when two out of three control plane nodes lose power or suffer disk corruption? The Raft quorum breaks, and the OpenShift API server goes completely dark!
>
> Here is how single-member recovery restores the cluster:
> • Isolate the Survivor: Identify the healthiest master node with intact etcd WAL logs.
> • Force Single-Member Mode: Execute the etcd recovery script to strip dead peers and initialize an independent single-node Raft consensus.
> • API Server Rebirth: The local kubelet restarts static pods, bringing the Kubernetes API server back online.
> • Reprovision Masters: Re-add the remaining control plane nodes one by one to rebuild high-availability quorum.
>
> 🔗 Master the Emergency Runbook:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2
>
> #Shorts #OpenShift #etcd #DisasterRecovery #Kubernetes #SRE #Sysadmin #DevOps

#### 2. How OpenShift Agent-Based Installer Eliminates External Bootstrap VMs
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/qmU1J5WlNis](https://www.youtube.com/shorts/qmU1J5WlNis)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/qmU1J5WlNis/edit](https://studio.youtube.com/video/qmU1J5WlNis/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:12
- 🏷️ **Domain**: Bare Metal & Agent-Based Installer
- 📝 **Full Description**:
> ⚡ How OpenShift Agent-Based Installer Eliminates External Bootstrap VMs!
>
> Traditional on-premises Kubernetes installations required spinning up a temporary bootstrap VM just to initialize the control plane. OpenShift 4 Agent-Based Installer (ABI) eliminates that complexity with Bootstrap-in-Place!
>
> How Bootstrap-in-Place Works:
> • Single Discovery ISO: Pre-embeds ignition configs, network teaming, and container images into a bootable ISO.
> • Temporary In-Memory Master: Node 0 boots into RAM, acts as the temporary bootstrap controller, and coordinates cluster installation.
> • Seamless Role Promotion: Once control plane services are healthy, Node 0 strips the bootstrap services and pivots to a permanent master.
> • Zero Leftover Footprint: No external helper VMs to maintain, patch, or destroy post-install.
>
> 🔗 Check Out the ABI Blueprints:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2
>
> #Shorts #OpenShift #BareMetal #Installation #Kubernetes #DevOps #PlatformEngineering #Sysadmin

#### 3. Why Vanilla Velero Fails on OpenShift: The OADP Data Protection Architecture
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/Cmhxtb8cmKU](https://www.youtube.com/shorts/Cmhxtb8cmKU)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/Cmhxtb8cmKU/edit](https://studio.youtube.com/video/Cmhxtb8cmKU/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:23
- 🏷️ **Domain**: Backup, DR & OpenShift OADP
- 📝 **Full Description**:
> 🛡️ Why Vanilla Velero Fails on OpenShift: The OADP Data Protection Architecture!
>
> Velero is the de-facto standard for generic Kubernetes backups. So why does it catastrophically fail on OpenShift?
>
> Why Generic Backups Break:
> • Security Context Constraints: Vanilla Velero does not understand OpenShift SCC UID ranges, causing restored pods to be rejected by the admission controller.
> • Custom Resource Definitions: OpenShift relies on specialized CRDs like Routes, MachineConfigs, and ImageStreams that require strict restoration ordering.
> • The OADP Solution: Red Hat built OADP (OpenShift API for Data Protection) to wrap Velero with custom OpenShift plugins, native CSI snapshotting, and Kopia file-system backup engines.
>
> Back up your clusters the cloud-native enterprise way!
>
> 🔗 Explore the Backup and DR Guides:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2
>
> #Shorts #OpenShift #OADP #Velero #Kubernetes #Backup #DisasterRecovery #SRE #DevOps

#### 4. How Gateway API GRPCRoute Streams LLM Tokens Instantly on OpenShift
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/DwPHhPGrOt0](https://www.youtube.com/shorts/DwPHhPGrOt0)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/DwPHhPGrOt0/edit](https://studio.youtube.com/video/DwPHhPGrOt0/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:14
- 🏷️ **Domain**: Ingress & Generative AI Inference
- 📝 **Full Description**:
> 🤖 How Gateway API GRPCRoute Streams LLM Tokens Instantly on OpenShift!
>
> Standard web Ingress buffers HTTP requests, waiting to collect the full response payload before sending anything back. But when serving AI models with vLLM or Ollama, token buffering causes unacceptable user latency!
>
> How GRPCRoute Solves AI Streaming:
> • HTTP/2 Multiplexing: Eliminates head-of-line blocking across bidirectional streaming connections.
> • Submillisecond Token Delivery: Streams text tokens directly from the GPU inference server to the client as they are generated.
> • Role-Oriented Traffic Rules: Match on gRPC services and methods (like kserve.InferenceService) directly in declarative YAML.
>
> Supercharge your AI application serving on OpenShift!
>
> 🔗 Check Out the Gateway API Specs:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2
>
> #Shorts #GatewayAPI #GRPCRoute #OpenShift #vLLM #ArtificialIntelligence #Kubernetes #GenerativeAI

#### 5. How TLSRoute Enables Zero-Trust SNI Passthrough on OpenShift
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/DkJQ4q0cetM](https://www.youtube.com/shorts/DkJQ4q0cetM)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/DkJQ4q0cetM/edit](https://studio.youtube.com/video/DkJQ4q0cetM/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:20
- 🏷️ **Domain**: Zero-Trust Security & Layer 4 Ingress
- 📝 **Full Description**:
> 🔒 How TLSRoute Enables Zero-Trust SNI Passthrough on OpenShift!
>
> In banking, healthcare, and high-security sectors, edge proxies must never decrypt sensitive client payloads. But how do you route encrypted traffic to the right microservice or KubeVirt VM?
>
> The Power of Gateway API TLSRoute:
> • SNI Inspection: The Gateway controller inspects the Server Name Indication header inside the initial TLS ClientHello packet.
> • Zero Decryption at Edge: Packets are routed at Layer 4 directly to the target pod without terminating TLS or possessing private keys.
> • End-to-End Compliance: Guarantees strict zero-trust cryptographic isolation all the way from the user browser to the backend container.
>
> 🔗 Learn How to Configure TLSRoute:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2
>
> #Shorts #TLSRoute #GatewayAPI #OpenShift #ZeroTrust #CyberSecurity #Kubernetes #DevSecOps

#### 6. How Gateway API HTTPRoute Replaces Fragile Ingress Annotations
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/g2z9-OSA_mU](https://www.youtube.com/shorts/g2z9-OSA_mU)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/g2z9-OSA_mU/edit](https://studio.youtube.com/video/g2z9-OSA_mU/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:14
- 🏷️ **Domain**: Ingress Architecture & Traffic Splitting
- 📝 **Full Description**:
> 🚀 How Gateway API HTTPRoute Replaces Fragile Ingress Annotations!
>
> Remember when configuring a simple canary deployment or URL rewrite in Kubernetes meant stacking 15 conflicting Ingress annotations?
>
> Why HTTPRoute Changes Everything:
> • Native Canary Splitting: Split traffic by percentage (e.g. 90 percent v1, 10 percent v2) directly in standard spec fields.
> • Header and Path Rewrites: Transform request headers, methods, and URL paths natively without controller-specific regex hacks.
> • Clear Status Signals: Gateway API reports granular status conditions directly back to your YAML, pinpointing routing conflicts immediately.
>
> Retire messy Ingress annotations and upgrade to modern declarative routing!
>
> 🔗 Explore the Gateway API Reference:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2
>
> #Shorts #HTTPRoute #GatewayAPI #OpenShift #Kubernetes #Networking #DevOps #CloudNative

#### 7. How OpenShift Automated Preflight Scripts Bulletproof Cluster Installations
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/UucLub-i270](https://www.youtube.com/shorts/UucLub-i270)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/UucLub-i270/edit](https://studio.youtube.com/video/UucLub-i270/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:02
- 🏷️ **Domain**: Preflight Validation & Readiness Automation
- 📝 **Full Description**:
> 🛡️ How OpenShift Automated Preflight Scripts Bulletproof Cluster Installations!
>
> Installing OpenShift 4 on bare metal or private clouds without rigorous preflight verification is asking for silent failures. A single DNS PTR mismatch, NTP drift, or slow disk will kill control plane quorum during bootstrap!
>
> How our automated preflight scripts guarantee Day 0 readiness:
> • Authoritative DNS Checks: Validates api, api-int, and wildcard apps records across split-horizon resolvers.
> • Disk IOPS Benchmarking: Runs automated fio tests ensuring fdatasync latency stays strictly under 10ms at p99.
> • Network and MTU Validation: Verifies jumbo frames, Geneve overlay routing, and firewall port clearance.
> • Automated Cluster Health Check: Inspects all ClusterOperators, node ready states, and pending CSR approvals.
>
> Never guess your cluster readiness again!
>
> 🔗 Explore the Preflight Scripts:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/scripts
>
> #Shorts #OpenShift #Kubernetes #Sysadmin #DevOps #SRE #Bash #Preflight #Automation

#### 8. How to Automate OpenShift etcd Snapshots and Retention Policies with Bash
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/o0hq2INBw1E](https://www.youtube.com/shorts/o0hq2INBw1E)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/o0hq2INBw1E/edit](https://studio.youtube.com/video/o0hq2INBw1E/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:08
- 🏷️ **Domain**: Automated Backup & Retention Policies
- 📝 **Full Description**:
> 💾 How to Automate OpenShift etcd Snapshots and Retention Policies with Bash!
>
> etcd is the single source of truth for your entire OpenShift cluster. If all master nodes lose power or suffer storage corruption, your only survival lifeline is an uncorrupted, recent etcd snapshot!
>
> How our automated etcd backup script safeguards your control plane:
> • Official Backup Execution: Triggers Red Hat cluster-backup.sh directly or via oc debug on the leader control plane node.
> • Static Pod Preservation: Archives static pod manifests, certificates, and TLS keys alongside the snapshot db.
> • Integrity Verification: Confirms non-zero byte size and valid sqlite headers immediately post-dump.
> • Automated Pruning: Enforces configurable retention policies (e.g. 14 days) to prevent disk space exhaustion.
>
> Automate your cluster backups before disaster strikes!
>
> 🔗 Download the etcd Backup Script:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/scripts
>
> #Shorts #OpenShift #etcd #Kubernetes #Backup #DisasterRecovery #SRE #DevOps #Bash

#### 9. How Emergency Scripts Resurrect Dead OpenShift Clusters After Quorum Failure
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/r2OhAxZU5gs](https://www.youtube.com/shorts/r2OhAxZU5gs)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/r2OhAxZU5gs/edit](https://studio.youtube.com/video/r2OhAxZU5gs/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:25
- 🏷️ **Domain**: Emergency Quorum Recovery & PKI Rebirth
- 📝 **Full Description**:
> 🚨 How Emergency Scripts Resurrect Dead OpenShift Clusters After Quorum Failure!
>
> When two out of three master nodes go offline or control plane PKI certificates expire, the Kubernetes API server dies completely. Standard oc commands will not respond!
>
> Here is how our emergency out-of-band recovery script resurrects the cluster:
> • Helper Jump Host Execution: Initiates remediation out-of-band via SSH without relying on cluster networking.
> • Static Pod Quenching: Safely pauses corrupted etcd and kube-apiserver static pods on the healthiest survivor node.
> • Force Single-Member Quorum: Rewrites the Raft peer table to force single-node consensus on the surviving master.
> • API Server Revival: Kubelet restarts static pods, bringing the cluster back to life so you can add fresh masters.
>
> Master out-of-band disaster recovery protocols!
>
> 🔗 Get the Emergency Recovery Scripts:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/scripts
>
> #Shorts #OpenShift #DisasterRecovery #etcd #Kubernetes #SRE #Sysadmin #DevOps #OutofBand

#### 10. How to Automate OpenShift Disaster Recovery Drills with OADP and Kopia
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/5Jkl6h7uOgA](https://www.youtube.com/shorts/5Jkl6h7uOgA)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/5Jkl6h7uOgA/edit](https://studio.youtube.com/video/5Jkl6h7uOgA/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:08
- 🏷️ **Domain**: Automated DR Drills & OADP Harness
- 📝 **Full Description**:
> 🛡️ How to Automate OpenShift Disaster Recovery Drills with OADP and Kopia!
>
> Untested backups are just wishful thinking! An enterprise disaster recovery strategy requires continuous, automated validation of Recovery Time (RTO) and Recovery Point (RPO) SLAs.
>
> How our automated OADP drill harness script works:
> • Zero-Risk Drill: Restores the latest production OADP backup into an ephemeral, isolated sandbox namespace.
> • Security Context Verification: Validates that OpenShift SCC admission controllers accept restored pods without UID conflicts.
> • Synthetic Health Probing: Executes live HTTP synthetic health checks against restored routes and services.
> • Automated Cleanup: Calculates exact RTO seconds and cleanly deletes the test namespace post-verification.
>
> Turn your DR policy into automated proof!
>
> 🔗 Check Out the DR Test Harness:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/scripts
>
> #Shorts #OpenShift #OADP #Velero #DisasterRecovery #Kubernetes #SRE #DevOps #Kopia

#### 11. How to Automate OpenShift Master Node Replacement Without Downtime
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/XgkB-eDbl_U](https://www.youtube.com/shorts/XgkB-eDbl_U)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/XgkB-eDbl_U/edit](https://studio.youtube.com/video/XgkB-eDbl_U/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 0:58
- 🏷️ **Domain**: Master Node Replacement & Lifecycle Automation
- 📝 **Full Description**:
> 🔄 How to Automate OpenShift Master Node Replacement Without Downtime!
>
> When a physical bare-metal server or hypervisor VM hosting a master node suffers permanent hardware death, replacing it manually involves over a dozen error-prone etcdctl and oc steps.
>
> How our automated replacement assistant handles the lifecycle safely:
> • Quorum Safeguard: Verifies that at least two healthy masters are online before touching anything.
> • etcd Member Eviction: Purges the dead master member ID from the active Raft cluster membership.
> • Node Object Deletion: Cordons, drains, and unlinks the failed node resource from the Kubernetes API.
> • Assisted Reintegration: Auto-approves pending kubelet CSRs and triggers etcd cluster re-balancing.
>
> Replace failed nodes with zero operational panic!
>
> 🔗 Download the Node Replacement Script:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/scripts
>
> #Shorts #OpenShift #BareMetal #Kubernetes #etcd #DevOps #SRE #Sysadmin #Automation

#### 12. How OpenShift Canary Upgrades Protect Workloads with Automated SLO Gates
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/gN_-IyABljE](https://www.youtube.com/shorts/gN_-IyABljE)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/gN_-IyABljE/edit](https://studio.youtube.com/video/gN_-IyABljE/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:27
- 🏷️ **Domain**: Canary Upgrades & Telemetry SLO Gating
- 📝 **Full Description**:
> 🚀 How OpenShift Canary Upgrades Work: Paused MCPs and Automated SLO Gates!
>
> Upgrading a mission-critical OpenShift cluster across hundreds of worker nodes should never be done as an all-or-nothing gamble. One bad kernel parameter can take down production!
>
> How our automated upgrade orchestrator script protects your cluster:
> • Mandatory Pre-Flight Health: Audits operator states, MCP sync, and takes a pre-upgrade etcd snapshot.
> • Paused MachineConfigPools: Halts global worker upgrades while upgrading only a designated canary node.
> • Prometheus and Thanos SLO Gating: Evaluates cluster error rates and latency SLOs during a configurable soak period.
> • Automated Progressive Rollout: Resumes pool unpausing and sequential worker draining only when telemetry stays green.
>
> Deploy upgrades with bulletproof automated guardrails!
>
> 🔗 Explore the Upgrade Automation Scripts:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/scripts
>
> #Shorts #OpenShift #CanaryUpgrade #Kubernetes #DevOps #SRE #PlatformEngineering #GitOps #Bash

#### 13. How to Survive OpenShift Air-Gapped Upgrades and Out-of-Band IPMI Recovery
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/CYX30kt1B_M](https://www.youtube.com/shorts/CYX30kt1B_M)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/CYX30kt1B_M/edit](https://studio.youtube.com/video/CYX30kt1B_M/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:04
- 🏷️ **Domain**: Air-Gapped Tooling & Out-of-Band IPMI Rescue
- 📝 **Full Description**:
> 🛡️ How to Survive OpenShift Air-Gapped Upgrades and Out-of-Band IPMI Recovery!
>
> Operating OpenShift in a completely disconnected, high-security datacenter means you cannot just run oc adm upgrade against the internet. And if a catastrophic failure takes down cluster networking, you need a hardware lifeline!
>
> How our air-gap and out-of-band automation scripts keep your cluster alive:
> • Air-Gapped Mirroring: mirror-ocp420-airgap.sh uses oc-mirror v2 to stream releases into a high-speed local OCI cache.
> • Fully Offline Upgrades: airgap-upgrade.sh stages disconnected update payloads and routes nodes to the local registry.
> • Out-of-Band Rescue: helper-ssh-jump.sh bypasses broken SDN and dead operating systems, connecting directly to node motherboards via IPMI Serial-over-LAN (SOL).
>
> Bulletproof your air-gapped infrastructure against catastrophic network isolation!
>
> 🔗 Explore the Automation Tooling:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/scripts
>
> #Shorts #OpenShift #AirGapped #ocmirror #IPMI #BareMetal #Sysadmin #DevOps #SRE #DisasterRecovery #Bash

#### 14. How OpenShift Automates 10,000 Edge Deployments with Zero-Touch Provisioning
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/duGGOLqLB-A](https://www.youtube.com/shorts/duGGOLqLB-A)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/duGGOLqLB-A/edit](https://studio.youtube.com/video/duGGOLqLB-A/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:30
- 🏷️ **Domain**: Edge Automation & Zero-Touch Provisioning (ZTP)
- 📝 **Full Description**:
> 🌐 How OpenShift Automates 10,000 Edge Deployments with Zero-Touch Provisioning!
>
> How do telco operators and retail giants deploy, configure, and maintain thousands of remote Single Node OpenShift (SNO) clusters without dispatching field engineers to every site?
>
> The Zero-Touch Provisioning (ZTP) architecture:
> • Declarative SiteConfigs: Every remote edge cluster is defined as a GitOps CRD containing network, BMC, and storage specs.
> • Central Hub Management: Red Hat Advanced Cluster Management (RHACM) monitors Git and triggers automated deployments.
> • BareMetal Operator & Assisted Installer: Powers on remote servers via IPMI/Redfish, boots discovery media, and automates installation.
> • Scalable Edge Fleet: Standardizes security policies, zero-trust RBAC, and automated updates across 10,000 remote locations simultaneously.
>
> Scale your Kubernetes edge with GitOps precision!
>
> 🔗 Check Out Edge & Topology Docs:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/docs/01-architecture-topologies
>
> #Shorts #OpenShift #EdgeComputing #SNO #Kubernetes #RHACM #GitOps #Telco #DevOps #PlatformEngineering

#### 15. How OpenShift Agent-Based Installer Automates Bare Metal Installations
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/nhxRJz2dR8o](https://www.youtube.com/shorts/nhxRJz2dR8o)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/nhxRJz2dR8o/edit](https://studio.youtube.com/video/nhxRJz2dR8o/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:17
- 🏷️ **Domain**: Bare Metal Provisioning & Agent-Based Installer
- 📝 **Full Description**:
> ⚡ How OpenShift Agent-Based Installer Automates Bare Metal Installations!
>
> Installing Kubernetes on bare-metal enterprise servers used to require complex PXE servers, TFTP boots, and fragile DHCP configurations. OpenShift Agent-Based Installer (ABI) changes the game!
>
> How ABI powers bare-metal automation:
> • Self-Contained Discovery ISO: Generates a single bootable image containing Ignition manifests and container images.
> • Static NMState Integration: Pre-configures NIC bonding, VLANs, and static IPs directly in agent-config.yaml before boot.
> • Local Hardware Discovery: Inspects CPUs, memory, disks, and network interfaces automatically during live memory boot.
> • Zero Network Dependencies: Installs flawlessly in high-security air-gapped environments without external internet access.
>
> Say goodbye to legacy PXE servers forever!
>
> 🔗 Download Agent-Based Manifests:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/configs/agent-based
>
> #Shorts #OpenShift #BareMetal #AgentBasedInstaller #Kubernetes #NMState #DevOps #SRE #Sysadmin

#### 16. How OpenShift Eliminates Bootstrap VMs with the Rendezvous Node Pattern
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/1_tlji_6oxk](https://www.youtube.com/shorts/1_tlji_6oxk)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/1_tlji_6oxk/edit](https://studio.youtube.com/video/1_tlji_6oxk/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:14
- 🏷️ **Domain**: Rendezvous Node & Bootstrap-in-Place Architecture
- 📝 **Full Description**:
> 🚀 How OpenShift Eliminates Bootstrap VMs with the Rendezvous Node Pattern!
>
> In traditional OpenShift 4 IPI or UPI installs, an external bootstrap VM was required just to launch the temporary control plane. Once the cluster was alive, that VM was destroyed, wasting resources and adding friction!
>
> How the Rendezvous Node Pattern works:
> • Designated Master in RAM: Node 0 is assigned as the Rendezvous Host and boots into a lightweight live environment.
> • Temporary In-Memory Control Plane: Runs etcd and the temporary assisted-service in memory on bare metal.
> • Control Plane Handoff: The permanent masters join the temporary cluster and take over active Raft consensus.
> • Bootstrap Self-Destruction: Node 0 cleanly wipes its temporary bootstrap containers and pivots to a normal production master.
>
> Clean, elegant, and zero wasted infrastructure!
>
> 🔗 Explore the ABI Architecture:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2/blob/main/docs/02-provisioning-paradigms/01-agent-based-installer.md
>
> #Shorts #OpenShift #Kubernetes #RendezvousNode #BareMetal #DevOps #SRE #PlatformEngineering #Sysadmin

#### 17. How OpenShift Replaced Fluentd with Vector and LokiStack for High-Speed Logging
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/EE_EMARHnb8](https://www.youtube.com/shorts/EE_EMARHnb8)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/EE_EMARHnb8/edit](https://studio.youtube.com/video/EE_EMARHnb8/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:22
- 🏷️ **Domain**: Enterprise Logging & Vector / LokiStack 3.x
- 📝 **Full Description**:
> 🪵 How OpenShift Replaced Fluentd with Vector and LokiStack for High-Speed Logging!
>
> Legacy Kubernetes logging with Fluentd and Elasticsearch choked on high-volume clusters, consuming massive CPU and running out of disk. OpenShift Logging 6.x completely redesigns the stack!
>
> Why Vector and LokiStack change enterprise logging:
> • Vector Rust Engine: Replaces Fluentd with an ultra-lightweight daemon that consumes up to 70 percent less CPU and RAM.
> • Declarative Routing: ClusterLogForwarder routes application, infrastructure, and audit logs to dedicated sinks and S3 buckets.
> • LokiStack 3.x TSDB: Indexes only log labels, storing compressed chunk payloads directly in cheap object storage (ODF Ceph or AWS S3).
> • Multi-Tenant Isolation: Enforces strict RBAC boundaries so development teams can only query their own application logs.
>
> Upgrade your logging from a resource hog to a high-speed telemetry engine!
>
> 🔗 Explore Logging Manifests:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/configs/observability
>
> #Shorts #OpenShift #Loki #Vector #Logging #Kubernetes #DevOps #SRE #CloudNative #Sysadmin

#### 18. How OpenShift Prevents Metric Explosions in Prometheus and Thanos
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/8832jzvfc_Q](https://www.youtube.com/shorts/8832jzvfc_Q)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/8832jzvfc_Q/edit](https://studio.youtube.com/video/8832jzvfc_Q/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:16
- 🏷️ **Domain**: Cluster Monitoring & Metric High-Cardinality Control
- 📝 **Full Description**:
> 📈 How OpenShift Prevents Metric Explosions in Prometheus and Thanos!
>
> What happens when a developer deploys a microservice that exposes user IDs or random UUIDs as Prometheus metric labels? High-cardinality explosion! The Prometheus scraper runs out of memory and crashes the monitoring stack!
>
> How OpenShift User Workload Monitoring (UWM) defends the cluster:
> • Mandatory Scrape Limits: Enforces sampleLimit thresholds (e.g. 5,000 samples per scrape) directly in the ServiceMonitor.
> • Label Relabeling Rules: Uses metricRelabelings in cluster-monitoring-config to drop ephemeral labels like timestamp or client_ip before ingestion.
> • Tenant Resource Quotas: Isolates user workload monitoring pods from core platform Prometheus to protect cluster alerting.
> • Thanos Compaction Guardrails: Prevents memory spikes during long-term metric downsampling and deduplication.
>
> Keep your metrics fast, lean, and crash-free!
>
> 🔗 Check Out Monitoring Configs:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/configs/observability
>
> #Shorts #OpenShift #Prometheus #Thanos #Monitoring #Kubernetes #SRE #DevOps #PlatformEngineering

#### 19. How Korrel8r Correlates Prometheus Metrics to Loki Logs and Tempo Traces
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/bffmO5yGGBA](https://www.youtube.com/shorts/bffmO5yGGBA)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/bffmO5yGGBA/edit](https://studio.youtube.com/video/bffmO5yGGBA/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:24
- 🏷️ **Domain**: Full-Stack Correlation & Cluster Observability Operator
- 📝 **Full Description**:
> 🔗 How Korrel8r Correlates Prometheus Metrics to Loki Logs and Tempo Traces!
>
> During a high-severity incident, SREs waste critical minutes jumping between alert dashboards, log queries, and tracing consoles trying to piece together what broke.
>
> How Korrel8r and Cluster Observability Operator (COO) solve correlation:
> • Unified Graph Engine: Korrel8r models Kubernetes resources, Prometheus alerts, Loki log streams, and Tempo traces as interconnected graph nodes.
> • One-Click Console Navigation: When an alert fires in the OpenShift Web Console, Korrel8r automatically generates contextual links to matching logs and traces.
> • Exemplar Integration: Click directly from a latency spike in a Prometheus chart straight into the exact OpenTelemetry trace span that caused it.
> • Subsecond Root-Cause Analysis: Cuts Mean Time to Resolution (MTTR) from hours down to seconds.
>
> Experience true full-stack correlation in OpenShift 4.20!
>
> 🔗 Explore COO Correlation Manifests:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/configs/observability
>
> #Shorts #OpenShift #Korrel8r #Observability #Kubernetes #Grafana #Loki #Tempo #Prometheus #SRE #DevOps

#### 20. How Tail Based Sampling Filters Trace Data in OpenTelemetry and Tempo
- 🔗 **Direct Link**: [https://www.youtube.com/shorts/28vd1iD0sDI](https://www.youtube.com/shorts/28vd1iD0sDI)
- 🛠️ **YouTube Studio**: [https://studio.youtube.com/video/28vd1iD0sDI/edit](https://studio.youtube.com/video/28vd1iD0sDI/edit)
- 🌐 **Language**: English (Original Audio)
- ⏱️ **Duration**: 1:25
- 🏷️ **Domain**: Distributed Tracing & Tail-Based Sampling
- 📝 **Full Description**:
> 🎯 How Tail Based Sampling Filters Trace Data in OpenTelemetry and Tempo!
>
> Collecting 100 percent of distributed traces across a massive microservices architecture generates petabytes of data, 99 percent of which are boring, successful 200 OK requests. But head-based random sampling risks missing rare critical errors!
>
> How OpenTelemetry Collector tail-based sampling works:
> • In-Memory Span Buffering: Collects all spans belonging to a trace and waits until the entire trace completes.
> • Intelligent Evaluation Rules: Inspects the entire trace before deciding whether to keep it or drop it.
> • 100 Percent Error Retention: Captures every single trace containing HTTP 5xx codes or unhandled exceptions.
> • Latency Threshold Gating: Automatically saves traces whose duration exceeds acceptable SLA thresholds (e.g. over 500ms).
> • Cost-Efficient Tempo Ingestion: Drops boring repetitive traffic, slashing storage costs while keeping all actionable debugging data.
>
> Master intelligent distributed tracing on OpenShift 4.20!
>
> 🔗 Download OpenTelemetry Collector Configs:
> https://github.com/nubenetes/openshift-4-20-installation-day0-day2/tree/main/configs/observability
>
> #Shorts #OpenTelemetry #Tempo #DistributedTracing #OpenShift #Kubernetes #Microservices #SRE #DevOps

</details>

---

## License

This repository is licensed under the [Apache 2.0 License](LICENSE).
Copyright © 2026 Nubenetes.
