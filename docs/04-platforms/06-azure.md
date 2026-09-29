# Public Cloud Azure Deployment Guide

OpenShift 4.20 on Microsoft Azure supports self-managed IPI/UPI clusters deployed across Enterprise Azure Virtual Networks (VNet).

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Resource Group & VNet Preparation
1. Create a Resource Group (e.g. `rg-ocp-network`) and Virtual Network (`vnet-ocp-prod`).
2. Create dedicated subnets:
   - `snet-control-plane` (`/27` minimum).
   - `snet-compute` (`/24` or larger).

### Step 2: Azure Workload Identity Federation Setup
1. Extract Azure credential requests:
   ```bash
   oc adm release extract --credentials-requests --cloud=azure --to=./credrequests quay.io/openshift-release-dev/ocp-release:4.20.0-x86_64
   ```
2. Use `ccoctl` to create User-Assigned Managed Identities and configure federated OIDC credentials against Microsoft Entra ID.

### Step 3: Configure install-config.yaml
1. Specify `credentialsMode: Manual`, `publish: Internal`, resource group, and subnet names (see [`configs/ipi-cloud/azure-install-config.yaml`](../../configs/ipi-cloud/azure-install-config.yaml)).

### Step 4: Execute Automated Installation
1. Generate manifests and copy `ccoctl` secrets into manifests directory.
2. Run installation:
   ```bash
   openshift-install create cluster --dir=./azure-cluster --log-level=info
   ```

### Step 5: Post-Install Accelerated Networking Verification
1. Ensure all Azure VMs report Accelerated Networking (SR-IOV) enabled for optimal throughput.

---
[Next: Google Cloud Platform (GCP)](07-gcp.md) • [Back to Platforms Index](README.md)
