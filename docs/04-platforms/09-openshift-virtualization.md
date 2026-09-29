# 09 - OpenShift Virtualization & VMware Migration (MTV)

With recent VMware licensing and architectural shifts, **OpenShift Virtualization (KubeVirt)** running on physical Bare Metal has become the premier enterprise strategy for modernizing legacy virtual machines alongside cloud-native containers.

---

## Architectural Overview: Bare Metal Hyperconvergence

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                     OPENSHIFT VIRTUALIZATION & MTV ARCHITECTURE                        │
└────────────────────────────────────────────────────────────────────────────────────────┘

    ┌───────────────────────────┐                ┌───────────────────────────┐
    │ Legacy VMware vCenter 8/9 │                │ OpenShift Virtualization  │
    │  (ESXi Clusters & VMFS)   │                │   (KubeVirt on Bare Metal)│
    └─────────────┬─────────────┘                └─────────────┬─────────────┘
                  │                                            │
                  │ Warm / Cold Migration Pipeline             │
                  └─────────────────────►──────────────────────┘
                                        │
                         ┌──────────────┴──────────────┐
                         │ Migration Toolkit for Virt  │
                         │    (MTV 2.8+ Forklift)      │
                         └─────────────────────────────┘
                                        │
           ┌────────────────────────────┼────────────────────────────┐
           ▼                            ▼                            ▼
┌─────────────────────┐      ┌─────────────────────┐      ┌─────────────────────┐
│ High-Performance VMs│      │ L2 Trunk Networking │      │ ODF Block RWX Storage│
│ • Gen 2 UEFI VMs    │      │ • NMState Bridges   │      │ • Ceph RBD RWX      │
│ • SecureBoot & vTPM │      │ • VLAN Passthrough  │      │ • Sub-second Live   │
│ • NUMA CPU Pinning  │      │ • SR-IOV 100GbE vNIC│      │   Migration Failover│
└─────────────────────┘      └─────────────────────┘      └─────────────────────┘
```

---

## 1. Day 0 Infrastructure Prerequisites

To support high-performance enterprise virtual machines and sub-second live migration:

1. **BIOS / Hardware Virtualization**:
   - Ensure Intel VT-x / AMD-V and VT-d (IOMMU) are enabled in server BIOS.
2. **Network Layer 2 Bridge Trunking (NMState)**:
   - Configure a Linux bridge on the worker nodes to attach VM vNICs directly to corporate VLANs:
   ```yaml
   apiVersion: nmstate.io/v1
   kind: NodeNetworkConfigurationPolicy
   metadata:
     name: br-vlan-trunk
   spec:
     nodeSelector:
       node-role.kubernetes.io/worker: ""
     desiredState:
       interfaces:
         - name: br-vlan
           type: linux-bridge
           state: up
           bridge:
             options:
               stp:
                 enabled: false
             port:
               - name: bond0.100
   ```
3. **Storage Architecture (ODF Ceph RBD RWX)**:
   - Virtual Machine disks require **ReadWriteMany (RWX)** block storage classes (`ocs-storagecluster-ceph-rbd`) to enable live-migration across physical worker nodes without downtime.

---

## 2. Deploying OpenShift Virtualization (HCO 4.20)

1. **Subscribe and Configure HyperConverged Operator**:
   Apply [`configs/virt/hyperconverged-cr.yaml`](../../configs/virt/hyperconverged-cr.yaml).
2. **Key Capabilities Activated**:
   - Automated CPU host-passthrough and NUMA alignment.
   - Live migration tuning: 10 concurrent cluster migrations with 1024 MiB/s dedicated migration network bandwidth.
   - Automated workload updates: During node kernel updates, VMs automatically live-migrate to healthy nodes without disruption.

---

## 3. Migration Toolkit for Virtualization (MTV 2.8+) Pipeline

The **Migration Toolkit for Virtualization (MTV)** orchestrates agentless, parallel migrations from VMware vCenter:

1. **Deploy Forklift Controller**:
   Apply [`configs/virt/mtv-forklift-controller.yaml`](../../configs/virt/mtv-forklift-controller.yaml).

2. **Configure Migration Plan**:
   - **Provider Discovery**: MTV automatically discovers VMware Datacenters, Clusters, Resource Pools, and VM templates.
   - **Storage Mapping**: Maps VMware VMFS/vSAN datastores to OpenShift Data Foundation Ceph block storage.
   - **Network Mapping**: Maps VMware Distributed Virtual Switches (DVS) / port groups directly to NMState Linux bridges.
   - **Warm Migration**: Pre-copies disk blocks while the VM is running in VMware. The final cutover takes **<2 minutes** with minimal application downtime.

---

## 4. Virtual Machine Template & Lifecycle

Deploy production virtual machines using declarative Kubernetes CRDs:
- Apply [`configs/virt/vm-rhel9-template.yaml`](../../configs/virt/vm-rhel9-template.yaml) to instantiate a Gen 2 UEFI RHEL 9 VM with 8 vCPU, 32 GB RAM, and cloud-init SSH injection.

---

## Verification & Management Commands

```bash
# Verify OpenShift Virtualization hyperconverged cluster health
oc get hyperconverged kubevirt-hyperconverged -n openshift-cnv

# Inspect running VirtualMachines and VirtualMachineInstances
oc get vms,vmis -n production-vms

# Test live-migration of a VM to another physical node
oc virt migrate prod-db-rhel9-vm -n production-vms
oc get vmi prod-db-rhel9-vm -n production-vms -o jsonpath='{.status.migrationState.status}'
```

---
[Back to Platform Specific Index](README.md) • [Next: Day 0 Readiness Overview](../05-day0-readiness/README.md)
