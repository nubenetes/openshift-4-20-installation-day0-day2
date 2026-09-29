# Public Cloud Google Cloud Platform (GCP) Deployment Guide

OpenShift 4.20 on Google Cloud Platform (GCP) provides robust enterprise multi-zone reliability, Shared VPC networking, and Private Service Connect (PSC).

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Shared VPC Setup (Host Project)
1. In the GCP Host Project, establish a Shared VPC with subnets for master nodes (`snet-ocp-masters`) and worker nodes (`snet-ocp-workers`).
2. Attach the Service Project to the Shared VPC.

### Step 2: GCP Workload Identity Federation
1. Generate GCP Workload Identity pools and provider bindings using `ccoctl`:
   ```bash
   ccoctl gcp create-all      --name=ocp420-gcp      --region=europe-west1      --project=enterprise-service-project      --credentials-requests-dir=./credrequests
   ```

### Step 3: Configure GCP install-config.yaml
1. Specify Shared VPC details, instance types (`n2-standard-8`), and `credentialsMode: Manual` (see [`configs/ipi-cloud/gcp-install-config.yaml`](../../configs/ipi-cloud/gcp-install-config.yaml)).

### Step 4: Execute Installation
1. Trigger automated deployment:
   ```bash
   openshift-install create cluster --dir=./gcp-cluster --log-level=info
   ```

### Step 5: Verify Persistent Disk CSI & PSC Endpoints
1. Validate that the Google Compute Engine Persistent Disk CSI driver is operational.

---
[Next: Microsoft Hyper-V](08-microsoft-hyper-v.md) • [Back to Platforms Index](README.md)
