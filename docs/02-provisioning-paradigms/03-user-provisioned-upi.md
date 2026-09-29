# User Provisioned Infrastructure (UPI)

User Provisioned Infrastructure (UPI) is utilized when enterprise security policies prohibit the OpenShift installer from creating cloud or datacenter infrastructure.

---

## Responsibility Matrix: UPI vs IPI

| Infrastructure Component | IPI Automated | UPI Enterprise Responsibility |
| :--- | :---: | :---: |
| **IPAM & Subnets** | Installer | Network Engineering (Infra Team) |
| **DNS Records (`api`, `api-int`, `*.apps`)** | Installer | Active Directory / Infoblox / BIND |
| **External Load Balancers (Port 6443, 22623, 443)**| Installer | F5 BIG-IP / Citrix ADC / HAProxy / Cloud LBs |
| **VM / Bare-Metal Hardware Provisioning** | Installer | VMware vCenter / Nutanix / Server Team |
| **Storage Arrays & LUNs** | CSI Dynamic | Storage Engineering (SAN/NAS/CSI) |
| **Operating System Booting (Ignition)** | Installer | TFTP / PXE / HTTP Server hosting Ignition |

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Pre-Provision Enterprise Infrastructure
1. **Network**: Create dedicated VLANs and allocate static IP addresses for 1 Bootstrap VM, 3 Master VMs, and N Worker VMs.
2. **DNS**: Register forward `A` records and reverse `PTR` records for:
   - `api.<cluster>.<domain>` -> External Load Balancer IP
   - `api-int.<cluster>.<domain>` -> Internal Load Balancer IP
   - `*.apps.<cluster>.<domain>` -> Ingress Router IP
   - All VM hostnames to their respective static IPs.
3. **Load Balancers**: Configure external load balancers:
   - Port 6443 (API): Backends = Bootstrap IP, Master 0, Master 1, Master 2.
   - Port 22623 (MachineConfig): Backends = Bootstrap IP, Master 0, Master 1, Master 2.
   - Ports 80 & 443 (Ingress): Backends = Worker nodes.

### Step 2: Generate Ignition Configuration Files
1. Prepare `install-config.yaml` with `platform: none` (or specific hypervisor UPI platform block).
2. Generate ignition manifests:
   ```bash
   openshift-install create ignition-configs --dir=./upi-workspace
   ```
3. Verify output files: `bootstrap.ign`, `master.ign`, `worker.ign`, and `metadata.json`.

### Step 3: Host Ignition Files on Internal Web Server
1. Upload `bootstrap.ign`, `master.ign`, and `worker.ign` to an internal HTTP web server reachable by all cluster nodes:
   ```bash
   cp *.ign /var/www/html/ignition/
   chmod 644 /var/www/html/ignition/*.ign
   ```

### Step 4: Provision VMs & Inject Ignition URL
1. Create the Bootstrap VM, 3 Control Plane VMs, and initial Worker VMs on VMware, Hyper-V, or KVM.
2. Boot VMs with the RHCOS Live ISO, passing the kernel parameter:
   ```
   coreos.inst.install_dev=/dev/sda
   coreos.inst.ignition_url=http://webserver.corp.local/ignition/master.ign
   ```
3. Reboot VMs to boot from local disk.

### Step 5: Wait for Bootstrap Completion
1. Monitor bootstrap progress:
   ```bash
   openshift-install wait-for bootstrap-complete --dir=./upi-workspace --log-level=info
   ```
2. When the command returns successfully, **remove the Bootstrap VM from the load balancer pools** and permanently destroy/decommission the Bootstrap VM.

### Step 6: Approve Node Certificate Signing Requests (CSRs)
1. While workers boot, monitor CSR requests:
   ```bash
   export KUBECONFIG=./upi-workspace/auth/kubeconfig
   oc get csr
   ```
2. Approve pending node certificates:
   ```bash
   oc get csr -o name | xargs oc adm certificate approve
   ```

### Step 7: Wait for Installation Completion
1. Track full cluster initialization:
   ```bash
   openshift-install wait-for install-complete --dir=./upi-workspace
   ```

---
[Next: GitOps Zero Touch Provisioning (ZTP)](04-ztp-acm-gitops.md) • [Back to Index](README.md)
