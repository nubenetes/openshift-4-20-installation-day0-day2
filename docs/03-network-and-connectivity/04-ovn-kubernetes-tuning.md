# OVN-Kubernetes CNI Tuning & Advanced Policies

OpenShift 4.20 defaults to **OVN-Kubernetes** (Open Virtual Network) as its native Container Network Interface (CNI), providing OpenFlow-based distributed routing, load balancing, security policies, and Geneve overlay encapsulation.

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: MTU Sizing & Validation
1. Verify underlying physical MTU:
   ```bash
   ip link show eth0
   ```
2. Calculate Geneve overlay MTU:
   - For standard 1500 MTU switches -> Pod MTU = **1400** (1500 - 100 bytes Geneve header).
   - For Jumbo 9000 MTU switches -> Pod MTU = **8900**.
3. Set cluster MTU in `install-config.yaml`:
   ```yaml
   networking:
     networkType: OVNKubernetes
     clusterNetworkMTU: 1400
   ```

### Step 2: Configure Deterministic EgressIP for Core Legacy Integration
1. Assign a secondary IP on the machine network to act as an egress gateway:
   ```yaml
   apiVersion: k8s.ovn.org/v1
   kind: EgressIP
   metadata:
     name: finance-egress
   spec:
     egressIPs:
       - 192.168.10.180
     namespaceSelector:
       matchLabels:
         app.kubernetes.io/tier: finance
   ```
2. Label target worker nodes with `k8s.ovn.org/egress-assignable=""`.

### Step 3: Enforce Namespace Outbound EgressFirewall
1. Restrict application pods from reaching sensitive internal subnets:
   ```yaml
   apiVersion: k8s.ovn.org/v1
   kind: EgressFirewall
   metadata:
     name: default
     namespace: payment-service
   spec:
     egress:
       - type: Allow
         to:
           cidrSelector: 192.168.20.0/24  # Allow database subnet
       - type: Deny
         to:
           cidrSelector: 0.0.0.0/0        # Block all other outbound traffic
   ```

### Step 4: Verify Overlay Traffic & Flows
1. Verify OVN pod status:
   ```bash
   oc get pods -n openshift-ovn-kubernetes
   ```
2. Test inter-pod ping with packet size verifying MTU:
   ```bash
   ping -M do -s 1372 <pod-ip>
   ```

---
[Back to Network Index](README.md) • [Next Chapter: Platform Deployment Guides](../04-platforms/README.md)
