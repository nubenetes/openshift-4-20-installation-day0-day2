# DNS & Load Balancer Engineering Matrix

OpenShift 4.20 requires two distinct ingress paths: **Control Plane Ingress** (API & MachineConfig) and **Application Ingress** (Router).

---

## Comprehensive Port Mapping Matrix

| Port | Protocol | Source | Destination | Purpose |
| :---: | :---: | :--- | :--- | :--- |
| **6443** | TCP | Clients & Worker Nodes | Control Plane API (VIP/LB) | Kubernetes API Server |
| **22623** | TCP | Nodes during install/boot | Control Plane (VIP/LB) | Machine Config Server (Ignition) |
| **2379-2380**| TCP | Master Nodes | Master Nodes | etcd Client & Peer Raft Communication |
| **10250** | TCP | Master Nodes | Master & Worker Nodes | Kubelet API |
| **443** | TCP | External Clients / End Users| Ingress Router (VIP/LB) | HTTPS Application Ingress |
| **80** | TCP | External Clients / End Users| Ingress Router (VIP/LB) | HTTP Redirect Ingress |
| **6081** | UDP | All Nodes | All Nodes | OVN-Kubernetes Geneve Overlay CNI |

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Forward DNS Record Registration
1. In your enterprise DNS server (BIND9, Infoblox, or Active Directory), create the mandatory forward `A` records:
   - `api.<cluster>.<baseDomain>` -> API Load Balancer IP (e.g. `192.168.10.100`)
   - `api-int.<cluster>.<baseDomain>` -> API Load Balancer IP (e.g. `192.168.10.100`)
   - `*.apps.<cluster>.<baseDomain>` -> Ingress Router Load Balancer IP (e.g. `192.168.10.101`)

### Step 2: Reverse PTR Record Registration
1. Create reverse `PTR` records for every master node, worker node, and VIP:
   - `192.168.10.11` -> `master-0.<cluster>.<baseDomain>`
   - `192.168.10.12` -> `master-1.<cluster>.<baseDomain>`
   - `192.168.10.13` -> `master-2.<cluster>.<baseDomain>`

### Step 3: Validate DNS Propagation with preflight-check.sh
1. From the deployment workstation, execute the preflight check script:
   ```bash
   CLUSTER_NAME=ocp420 BASE_DOMAIN=corp.local API_VIP=192.168.10.100 APPS_VIP=192.168.10.101 ./scripts/preflight-check.sh
   ```
2. Ensure all forward and reverse records return `[PASS]`.

### Step 4: External Enterprise Load Balancer Setup (F5 BIG-IP / Citrix / HAProxy)
1. For UPI and non-VIP installations, create backend pools for:
   - **Port 6443**: Health check HTTPS `GET /readyz` expecting HTTP 200.
   - **Port 22623**: Health check TCP connect.
   - **Ports 80 & 443**: Health check TCP connect or HTTP `GET /healthz`.
2. For IPI or Agent-Based installations, specify `apiVIPs` and `ingressVIPs` in `install-config.yaml` to let OpenShift manage Keepalived VIPs automatically.

---
[Next: Storage Architecture & ODF](03-storage-architecture-odf.md) • [Back to Day 0 Index](README.md)
