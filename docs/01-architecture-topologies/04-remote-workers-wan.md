# Remote Worker Nodes over WAN Architecture

OpenShift 4.20 supports deploying worker nodes at remote edge sites or branch offices connected over Wide Area Networks (WAN) to a centralized 3-node Control Plane residing in a core data center or cloud region.

---

## Architectural Layout

```mermaid
flowchart TD
    subgraph CoreDC["Core Data Center / Cloud Region"]
        M1["Master 0"]
        M2["Master 1"]
        M3["Master 2"]
        HubRegistry["Enterprise Registry"]
    end

    subgraph EdgeSiteA["Edge Site Alpha (Factory Floor)"]
        RW1["Remote Worker A1"]
        RW2["Remote Worker A2"]
        LocalEdgeAppsA["Edge Pods (Autonomous Caching)"]
    end

    subgraph EdgeSiteB["Edge Site Beta (Distribution Hub)"]
        RW3["Remote Worker B1"]
        RW4["Remote Worker B2"]
        LocalEdgeAppsB["Edge Pods"]
    end

    CoreDC <== "WAN Link (Latency <= 100ms RTT)" ==> EdgeSiteA
    CoreDC <== "WAN Link (Latency <= 100ms RTT)" ==> EdgeSiteB
```

---

## Network & Latency Engineering Parameters

| Parameter | Threshold Requirement | Consequence of Violation |
| :--- | :--- | :--- |
| **Max Network Latency** | <= 100ms RTT | Kubelet node heartbeats time out; master marks node  |
| **Network Bandwidth** | >= 100 Mbps per worker | Slow image pulling and metric collection throttling |
| **Packet Loss** | < 0.5% | TCP retransmissions impact etcd lease updates and pod status |
| **CNI Encapsulation** | OVN-Kubernetes Geneve (UDP 6081)| Firewalls across WAN must allow UDP 6081 and IPsec/WireGuard |

---

## Kubelet Heartbeat Tuning for WAN Links
Under default configurations, a node is marked  if the master does not receive node status for 40 seconds. For WAN links with transient jitter, tune the  via MCO:

```yaml
apiVersion: machineconfiguration.openshift.io/v1
kind: KubeletConfig
metadata:
  name: remote-worker-kubelet-tuning
spec:
  machineConfigPoolSelector:
    matchLabels:
      pools.operator.openshift.io/remote-worker: ""
  kubeletConfig:
    nodeStatusUpdateFrequency: 10s
    nodeStatusReportFrequency: 1m
```

---
[Next: Hosted Control Planes (HyperShift)](05-hypershift-hosted-cp.md) • [Back to Topologies Index](README.md)
