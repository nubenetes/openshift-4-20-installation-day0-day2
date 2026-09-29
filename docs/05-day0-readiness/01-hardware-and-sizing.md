# Hardware Sizing & Capacity Calculations

Improperly sized master nodes cause etcd election timeouts, API latency spikes, and cascade failure across workers.

---

## Detailed Node Resource Allocations

| Role | Minimum Production Sizing | Heavy Enterprise / Scale Sizing (>250 Nodes) |
| :--- | :--- | :--- |
| **Control Plane (Master)** | 8 vCPU, 32 GB RAM, 120 GB SSD | 16-32 vCPU, 64-128 GB RAM, 500 GB NVMe |
| **Infra Nodes** | 8 vCPU, 32 GB RAM, 200 GB SSD | 16 vCPU, 64 GB RAM, 500 GB NVMe |
| **ODF Storage Nodes** | 16 vCPU, 64 GB RAM, 3x Raw NVMe | 32 vCPU, 128 GB RAM, 6-12x Enterprise NVMe |
| **Worker Nodes (General)** | 8 vCPU, 32 GB RAM, 120 GB SSD | Sized according to application workload profile |

---

## etcd Performance Verification Command
To verify that your storage hardware meets the etcd <10ms write latency threshold:

```bash
fio --rw=write --ioengine=sync --fdatasync=1 --directory=/var/lib/etcd     --size=22m --bs=2300 --name=etcd-bench
```
Examine the `fdatasync` p99 latency metric. If `fdatasync p99 > 10.00ms`, the underlying storage will lead to cluster instability during load or node scale-out.

---
[Next: DNS & Load Balancing Matrix](02-dns-loadbalancer-matrix.md) • [Back to Day 0 Index](README.md)
