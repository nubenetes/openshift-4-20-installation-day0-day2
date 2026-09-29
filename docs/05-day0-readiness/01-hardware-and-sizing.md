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

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Hardware Pre-Audit & CPU Architecture Verification
1. Verify that all target physical or virtual nodes utilize supported 64-bit architectures (x86_64 or aarch64):
   ```bash
   lscpu | grep -E "Architecture|Model name|CPU\(s\):"
   ```
2. Confirm hardware virtualization extensions are enabled:
   ```bash
   egrep -c '(vmx|svm)' /proc/cpuinfo
   ```

### Step 2: Memory Quota & Swap Disabling
1. Validate that the host has sufficient unallocated ECC memory (minimum 32 GB for control plane, 16 GB for SNO):
   ```bash
   free -h
   ```
2. OpenShift CoreOS disables Linux swap by default. If validating a pre-existing host, ensure swap is disabled:
   ```bash
   sudo swapoff -a
   ```

### Step 3: Mandatory etcd Disk fdatasync Latency Benchmark
1. etcd writes its write-ahead log (WAL) synchronously to disk. The 99th percentile of `fdatasync` disk write latency **must be under 10ms**:
   ```bash
   fio --rw=write --ioengine=sync --fdatasync=1 --directory=/var/tmp        --size=22m --bs=2300 --name=etcd-bench-test
   ```
2. Examine the `fdatasync` p99 latency metric. If `p99 > 10.00ms`, the underlying storage array or SAN LUN is too slow and will trigger etcd election timeouts during cluster load.

### Step 4: Network Interface & NUMA Topology Optimization
1. In high-performance multi-socket servers, align network interfaces with the corresponding NUMA node:
   ```bash
   numactl --hardware
   cat /sys/class/net/eth0/device/numa_node
   ```
2. Dedicate high-throughput network cards (10/25GbE) to NUMA socket 0 alongside storage controllers to eliminate cross-socket QPI/UPI bus latency.

---
[Next: DNS & Load Balancing Matrix](02-dns-loadbalancer-matrix.md) • [Back to Day 0 Index](README.md)
