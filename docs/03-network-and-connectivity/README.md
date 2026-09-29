# 03 - Network Architecture & Connectivity Scenarios

Network architecture is the most common source of installation failure. OpenShift 4.20 requires precise routing, MTU sizing, DNS propagation, and certificate injection across connected, proxy, and air-gapped environments.

---

## Connectivity Scenario Matrix

| Scenario | Internet Access | Ingress / Egress Path | Mirror Registry Required | Root PKI Trust Injection | Ingress Standard |
| :--- | :--- | :--- | :---: | :---: | :--- |
| **Fully Connected** | Direct via NAT / IGW | Direct Outbound (TCP 443) | No | Optional | **Kubernetes Gateway API** / Ingress |
| **Corporate Proxy** | Mediated via HTTP/HTTPS Proxy | Intercepted via forward proxy | Optional | Mandatory (`trustedCA` in cluster Proxy) | **Gateway API** + Enterprise PKI |
| **Restricted / Air-Gapped** | Zero Outbound Internet Access | Dark site / Private LAN only | **Mandatory** (`oc-mirror` v2) | **Mandatory** (Internal Private CA) | **Gateway API** + Private CA TLS |
| **Dual-Homed DMZ** | Split (Mgmt vs Application) | Multi-NIC via Multus / SR-IOV | Recommended | Mandatory | **Gateway API** Multi-Listener |

---

## Documentation Modules in this Section

1. [`01-connected-with-proxies.md`](01-connected-with-proxies.md) — Forward proxy configuration, `noProxy` bypass rules, and custom `trustedCA` injection.
2. [`02-air-gapped-oc-mirror-v2.md`](02-air-gapped-oc-mirror-v2.md) — Disconnected mirroring standard with `oc-mirror` v2, OCI streaming catalogs, and IDMS manifests.
3. [`03-air-gapped-core-services.md`](03-air-gapped-core-services.md) — Split-horizon DNS, Chrony Stratum NTP sync, and internal enterprise PKI.
4. [`04-ovn-kubernetes-tuning.md`](04-ovn-kubernetes-tuning.md) — OVN-Kubernetes CNI, MTU Geneve encapsulation sizing, EgressIPs, and EgressFirewalls.
5. [`05-gateway-api-architecture.md`](05-gateway-api-architecture.md) — **Kubernetes Gateway API Standard (`gateway.networking.k8s.io`)**, OpenShift Ingress Operator, Service Mesh 3.x, canary routing, and migration from legacy Routes.

---

## Core Network Architecture (OVN-Kubernetes)

```mermaid
flowchart TD
    subgraph HostNetwork[" Node Underlay Network (192.168.10.0/24) "]
        eth0["Bonded Primary NIC (MTU 9000 Jumbo or 1500)"]
    end

    subgraph OVNOverlay[" OVN-Kubernetes Geneve Overlay (10.128.0.0/14) "]
        GeneveTunnel["Geneve Overlay Tunnel (UDP 6081)<br/>Overhead: 100 Bytes | MTU: 1400 or 8900"]
        Pod1["Pod A (10.128.2.14)"]
        Pod2["Pod B (10.128.4.88)"]
        GeneveTunnel <--> Pod1
        GeneveTunnel <--> Pod2
    end

    subgraph Services["Kubernetes Services & Gateway API"]
        ClusterIP["Kube-Proxy replacement via OVN OpenFlow rules"]
        Gateway["Gateway API Envoy Listeners (80/443/gRPC)"]
    end

    eth0 <--> GeneveTunnel
    GeneveTunnel <--> Gateway
```

---
[Back to Global Navigation](../00-navigation.md)
