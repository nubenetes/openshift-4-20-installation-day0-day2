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
| **500, 4500**| UDP | All Nodes | All Nodes | OVN-Kubernetes IPsec Encryption (if enabled)|

---

## Load Balancer Topologies

1. **Integrated Virtual IPs (VIPs)**:
   - Built into OpenShift via Keepalived and HAProxy static pods on master nodes.
   - Configured via `apiVIPs` and `ingressVIPs` in `install-config.yaml`.
   - Ideal for bare metal, vSphere, Nutanix, and OpenStack environments.
2. **External Enterprise Load Balancers (F5 BIG-IP / Citrix / HAProxy)**:
   - Required in strict DMZ environments.
   - Requires health checks:
     - Port 6443: TCP check or HTTPS `GET /readyz` expecting HTTP 200.
     - Port 22623: TCP check.

---
[Next: Storage Architecture & ODF](03-storage-architecture-odf.md) • [Back to Day 0 Index](README.md)
