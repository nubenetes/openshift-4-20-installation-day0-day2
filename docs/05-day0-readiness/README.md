# 05 - Day 0 Infrastructure Readiness & Prerequisites

Day 0 encompasses all architectural planning, hardware validation, network provisioning, and DNS/storage preparation executed before triggering the installation.

---

## Preflight Verification Checklist

- [ ] **Hardware & Sizing**: Master nodes satisfy minimum 8 vCPU, 32 GB RAM, and <10ms fdatasync disk latency.
- [ ] **Network Connectivity**: CIDR blocks (`machineNetwork`, `clusterNetwork`, `serviceNetwork`) do not overlap with corporate routes.
- [ ] **DNS Records**: Forward resolution for `api`, `api-int`, and `*.apps`, plus reverse PTR for all node IPs.
- [ ] **NTP Clock Sync**: All hosts synchronized against a reliable local or upstream NTP server (drift < 500ms).
- [ ] **Load Balancing**: External or integrated VIPs configured for ports 6443, 22623, 80, and 443.
- [ ] **Storage & CSI**: Primary block/file storage class identified, or raw NVMe disks allocated for ODF Ceph.
- [ ] **Automated Preflight Execution**: Run `scripts/preflight-check.sh` on the bastion host.
- [ ] **Helper Node Verification**: Validate DNS, HAProxy, and Chrony services on the Bastion / Services host.

---

## Section Documents
- [01. Hardware Sizing & Capacity Calculations](01-hardware-and-sizing.md)
- [02. DNS & Load Balancing Matrix](02-dns-loadbalancer-matrix.md)
- [03. Storage Architecture & ODF](03-storage-architecture-odf.md)
- [04. Helper Node Architecture & Engineering](04-helper-node-architecture.md)

---
[Back to Global Navigation](../00-navigation.md)
