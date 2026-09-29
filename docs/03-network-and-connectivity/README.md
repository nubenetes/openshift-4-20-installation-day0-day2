# 03 - Network Architecture & Connectivity Scenarios

Network architecture is the most common source of installation failure. OpenShift 4.20 requires precise routing, MTU sizing, DNS propagation, and certificate injection across connected, proxy, and air-gapped environments.

---

## Connectivity Scenario Matrix

| Scenario | Internet Access | Ingress / Egress Path | Mirror Registry Required | Root PKI Trust Injection |
| :--- | :--- | :--- | :---: | :---: |
| **Fully Connected** | Direct via NAT / IGW | Direct Outbound (TCP 443) | No | Optional |
| **Corporate Proxy** | Mediated via HTTP/HTTPS Proxy | Intercepted via forward proxy | Optional | Mandatory (`trustedCA` in cluster Proxy) |
| **Restricted / Air-Gapped** | Zero Outbound Internet Access | Dark site / Private LAN only | **Mandatory** (`oc-mirror` v2) | **Mandatory** (Internal Private CA) |
| **Dual-Homed DMZ** | Split (Mgmt vs Application) | Multi-NIC via Multus / SR-IOV | Recommended | Mandatory |

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

    subgraph Services["Kubernetes Services (172.30.0.0/16)"]
        ClusterIP["Kube-Proxy replacement via OVN OpenFlow rules"]
    end

    eth0 <--> GeneveTunnel
```

---
[Back to Global Navigation](../00-navigation.md)
