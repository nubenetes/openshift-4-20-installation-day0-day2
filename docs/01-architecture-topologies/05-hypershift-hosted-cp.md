# Hosted Control Planes (HyperShift) Architecture

Hosted Control Planes (HyperShift) decouple the OpenShift control plane from the data plane, running the master components as native Kubernetes workloads (deployments, statefulsets, and configmaps) inside a centralized Management (Hosting) Cluster.

---

## Architectural Comparison

```mermaid
flowchart TD
    subgraph Classic["Classic OpenShift Cluster"]
        VM1["Master VM 1 (Dedicated OS)"]
        VM2["Master VM 2 (Dedicated OS)"]
        VM3["Master VM 3 (Dedicated OS)"]
        W1["Worker Node 1"]
        W2["Worker Node 2"]
    end

    subgraph Hosted["Hosted Control Planes Model"]
        subgraph ManagementCluster["Central Management Cluster"]
            HCP1["Namespace: clusters-tenant1<br/>kube-apiserver Pods<br/>etcd StatefulSet<br/>KCM Pods"]
            HCP2["Namespace: clusters-tenant2<br/>kube-apiserver Pods<br/>etcd StatefulSet<br/>KCM Pods"]
        end
        subgraph DataPlane["Tenant Data Plane (Workers Only)"]
            TW1["Tenant 1 - Worker 1"]
            TW2["Tenant 1 - Worker 2"]
            TW3["Tenant 2 - Worker 1"]
        end
    end
```

#### Architectural Breakdown: Classic OpenShift vs. Hosted Control Planes (HyperShift)

- **Classic OpenShift Model**: Requires at least three dedicated control plane instances (physical bare-metal servers or VMs) per cluster, running dedicated RHCOS operating systems, independent etcd clusters, and fixed compute footprints.
- **Hosted Control Plane (HCP) Model**: Consolidates the control plane into standard containerized Kubernetes pods (`kube-apiserver`, `etcd` StatefulSet, `kube-controller-manager`) deployed in dedicated tenant namespaces inside a central OpenShift Management Cluster.
- **Data Plane (Tenant Workers)**: Tenant clusters consist solely of worker nodes (on bare metal, VMware, or cloud instances) that connect back to the hosted control plane pods over secure Konnectivity/VPN tunnels.
- **Cost & Provisioning Benefits**: Reduces infrastructure hardware overhead by up to 60%, shrinks cluster spin-up time from 40 minutes to under 15 minutes, and enables multi-tenant API ingress exposure via Kubernetes Gateway API.

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Install HyperShift CLI & Operator on Management Cluster
1. Ensure the management cluster is running OpenShift 4.20 with Red Hat Advanced Cluster Management (ACM 2.12+).
2. Install the `hypershift` CLI binary:
   ```bash
   curl -sSL -o hypershift https://mirror.openshift.com/pub/openshift-v4/clients/hypershift/latest/hypershift-linux.tar.gz
   tar -xzf hypershift-linux.tar.gz && sudo mv hypershift /usr/local/bin/
   ```
3. Initialize the Hosted Control Plane Operator on the Management Cluster:
   ```bash
   hypershift install --oidc-storage-provider-s3-bucket=enterprise-hypershift-oidc                       --oidc-storage-provider-s3-region=eu-west-1                       --oidc-storage-provider-s3-credentials=~/.aws/credentials
   ```

### Step 2: Create a HostedCluster Custom Resource
1. Deploy a new hosted control plane targeting AWS, KubeVirt, or Agent bare-metal workers:
   ```bash
   hypershift create cluster aws      --name tenant-alpha      --node-pool-replicas 3      --base-domain corp.cloud      --region eu-west-1      --pull-secret ~/.openshift/pull-secret      --aws-creds ~/.aws/credentials      --release-image quay.io/openshift-release-dev/ocp-release:4.20.0-x86_64
   ```

### Step 3: Monitor Control Plane Pod Deployment
1. Inspect the hosted control plane namespace on the Management Cluster:
   ```bash
   oc get pods -n clusters-tenant-alpha
   ```
2. Verify `kube-apiserver`, `etcd-0/1/2`, `openshift-apiserver`, and `oauth-openshift` pods reach `Running` state in under 60 seconds.

### Step 4: Extract Tenant Kubeconfig & Access Cluster
1. Retrieve the kubeconfig for the hosted tenant cluster:
   ```bash
   hypershift create kubeconfig --name tenant-alpha > tenant-alpha.kubeconfig
   export KUBECONFIG=$(pwd)/tenant-alpha.kubeconfig
   oc get nodes
   ```

### Step 5: Scale and Manage Worker NodePools
1. Scale the tenant data plane dynamically without affecting the control plane:
   ```bash
   oc scale nodepool tenant-alpha -n clusters --replicas=10
   ```

### Step 6: Zero-Downtime Control Plane Upgrades
1. Update the control plane version with zero disruption to tenant worker workloads:
   ```bash
   oc patch hostedcluster tenant-alpha -n clusters --type=merge -p '{"spec":{"release":{"image":"quay.io/openshift-release-dev/ocp-release:4.20.1-x86_64"}}}'
   ```

### Step 7: Multi-Tenant API Ingress via Kubernetes Gateway API
On the central management cluster, expose hundreds of hosted `kube-apiserver` endpoints (port 6443) cleanly using the **Kubernetes Gateway API**:
1. Shared management `Gateway` binds external DNS listeners (`api.tenant-*.corp.cloud`).
2. Declarative `TLSRoute` resources direct incoming TLS connections directly to each tenant's `kube-apiserver` Service without port exhaustion or TLS re-encryption overhead.
3. Reference: [`docs/03-network-and-connectivity/05-gateway-api-architecture.md`](../03-network-and-connectivity/05-gateway-api-architecture.md).


