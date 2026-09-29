# Public Cloud AWS Deployment Guide

OpenShift 4.20 on Amazon Web Services (AWS) supports fully automated IPI deployments into greenfield or existing brownfield Virtual Private Clouds (VPC).

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: VPC, Subnets & Route53 Setup
1. Create or designate an AWS VPC across 3 Availability Zones.
2. Provision 3 private subnets for control plane and compute nodes.
3. Configure Route53 private hosted zone for the base domain (`corp.cloud`).

### Step 2: Generate Short-Lived STS Credentials via ccoctl
1. Extract credential requests from the release payload:
   ```bash
   oc adm release extract --credentials-requests      --cloud=aws      --to=./credrequests      quay.io/openshift-release-dev/ocp-release:4.20.0-x86_64
   ```
2. Run `ccoctl` to generate IAM roles and OIDC identity providers:
   ```bash
   ccoctl aws create-all      --name=ocp420-aws      --region=eu-west-1      --credentials-requests-dir=./credrequests
   ```

### Step 3: Configure AWS install-config.yaml
1. Author `install-config.yaml` specifying `credentialsMode: Manual`, `publish: Internal`, and private subnet IDs (see [`configs/ipi-cloud/aws-install-config.yaml`](../../configs/ipi-cloud/aws-install-config.yaml)).

### Step 4: Create Cluster Manifests & Inject IAM Secrets
1. Generate cluster manifests:
   ```bash
   openshift-install create manifests --dir=./aws-cluster
   ```
2. Copy generated STS IAM secrets into `./aws-cluster/manifests/`.

### Step 5: Execute Automated Cluster Deployment
1. Initiate the installation:
   ```bash
   openshift-install create cluster --dir=./aws-cluster --log-level=info
   ```
2. AWS CloudFormation and Machine API launch private EC2 instances, NLBs, and security groups.

### Step 6: Validate IRSA Authentication & Storage CSI
1. Confirm AWS EBS CSI driver communicates via STS without long-lived keys:
   ```bash
   oc get pods -n openshift-cluster-csi-drivers
   ```

---
[Next: Azure Deployment Guide](06-azure.md) • [Back to Platforms Index](README.md)
