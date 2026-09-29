# KVM / Libvirt & Red Hat OpenStack Services (RHOSO)

For organizations standardizing on open-source virtualization or Red Hat OpenStack Services on OpenShift (RHOSO / RHOSP 17/18), OpenShift 4.20 delivers enterprise cloud elasticity.

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Host Bridge & Virtualization Preparation (Standalone KVM)
1. Verify KVM virtualization extensions:
   ```bash
   egrep -c '(vmx|svm)' /proc/cpuinfo
   ```
2. Create a Linux bridge (e.g. `br0`) attached to physical NIC for external connectivity.

### Step 2: Generate Agent-Based ISO
1. Create `install-config.yaml` with `platform: none`.
2. Generate the Agent ISO:
   ```bash
   openshift-install agent create image --dir=./kvm-cluster
   ```

### Step 3: Automated VM Creation via virt-install
1. Create QCOW2 sparse disks:
   ```bash
   qemu-img create -f qcow2 /var/lib/libvirt/images/master0.qcow2 120G
   ```
2. Provision and boot VMs using `virt-install`:
   ```bash
   virt-install      --name ocp-master-0      --ram 32768      --vcpus 8      --disk path=/var/lib/libvirt/images/master0.qcow2,bus=virtio      --cdrom ./kvm-cluster/agent.x86_64.iso      --network bridge=br0,model=virtio      --os-variant rhel9.0      --noautoconsole
   ```
3. Repeat for `master-1`, `master-2`, and worker nodes.

### Step 4: Monitor Cluster Convergence
1. Track completion:
   ```bash
   openshift-install agent wait-for install-complete --dir=./kvm-cluster
   ```

---
[Next: Public Cloud AWS](05-aws.md) • [Back to Platforms Index](README.md)
