# Nutanix AHV Deployment Guide

OpenShift 4.20 offers first-class native integration with **Nutanix Acropolis Hypervisor (AHV)** and Prism Central.

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Prism Central Account & Network Setup
1. Create a service account in Nutanix Prism Central with Cluster Admin privileges.
2. In Prism Central, configure an IPAM network subnet with a DHCP range or static IP pool.
3. Reserve 2 static VIPs: `apiVIPs` and `ingressVIPs`.

### Step 2: Upload RHCOS Image to Nutanix Prism
1. Download the official RHCOS Nutanix image (`rhcos-4.20-x86_64-nutanix.qcow2`).
2. In Prism Central -> Compute & Storage -> Images, upload the QCOW2 image and note the image name.

### Step 3: Author Nutanix IPI install-config.yaml
1. Configure `platform.nutanix` specifying Prism Central endpoint, credentials, Prism Element UUID, and subnet name.

### Step 4: Run Nutanix IPI Installation
1. Execute the installation:
   ```bash
   openshift-install create cluster --dir=./nutanix-cluster --log-level=info
   ```
2. The installer clones VMs directly from the Prism image, configures Nutanix Flow security categories, and assembles the cluster.

### Step 5: Install Nutanix CSI Operator
1. From OperatorHub, install the certified **Nutanix CSI Operator**.
2. Create the `NutanixCsiStorage` custom resource pointing to your Nutanix cluster data service IP for high-performance block volumes.

---
[Next: KVM & OpenStack](04-kvm-openstack.md) • [Back to Platforms Index](README.md)
