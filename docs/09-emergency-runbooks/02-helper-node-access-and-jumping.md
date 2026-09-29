# Helper Node Emergency Access: SSH Bastion Jumping, Emergency Consoles & IPMI/Redfish SOL

## Overview & Architecture

When OpenShift 4.20 operates normally, cluster administrators interact with nodes using the Kubernetes API via `oc debug node/<node-name>` or through temporary privileged pods.

However, during a **control plane outage, certificate expiration, CNI SDN breakdown, or network partition**, the Kubernetes API server is completely unresponsive. Under these emergency conditions, **out-of-band access orchestrated from the Helper / Bastion Node** is the only supported operational mechanism to triage, diagnose, and recover the physical or virtual hosts.

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                             OUT-OF-BAND EMERGENCY ACCESS TOPOLOGY                                │
├──────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                  │
│   ┌───────────────────────────────┐                                                              │
│   │      HELPER / BASTION NODE     │                                                              │
│   │    (Static IP, BIND9, SSH)    │                                                              │
│   └───────────────┬───────────────┘                                                              │
│                   │                                                                              │
│       ┌───────────┴───────────────────────────────────────┐                                      │
│       ▼                                                   ▼                                      │
│  [PRIMARY PATH]                                      [SECONDARY / OUT-OF-BAND PATH]              │
│  Direct SSH (core@<node-ip>)                         IPMI / Redfish SOL & VM Consoles            │
│  • Port 22 (SSH)                                     • Port 623 (UDP IPMI RMCP+)                 │
│  • User: core                                        • Dell iDRAC / HPE iLO / Cisco CIMC         │
│  • Key: ~/.ssh/id_rsa                                • virsh console / vSphere VMRC / Hyper-V    │
│  • Used for: Service recovery,                       • Used for: BIOS/Boot hangs, kernel panics, │
│    crictl, kubelet cert repair                         network isolation, grub recovery          │
│       │                                                   │                                      │
│       ▼                                                   ▼                                      │
│  ┌───────────────────────────────┐                   ┌───────────────────────────────┐           │
│  │   Control Plane Master 0-2    │                   │   Worker & Infra Nodes 0-N    │           │
│  │   (RHCOS Immutable System)    │                   │   (RHCOS Immutable System)    │           │
│  └───────────────────────────────┘                   └───────────────────────────────┘           │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## Method 1: SSH Bastion Access via CoreOS Private Key

### 1. Key Management & Authentication
Red Hat Enterprise Linux CoreOS (RHCOS) nodes are immutable and enforce strict key-based authentication:
- **Default Administrative User**: `core` (passwordless `sudo` rights).
- **Password Authentication**: Disabled by default in RHCOS.
- **SSH Key Pair**: The private key matching the public key specified in `install-config.yaml` (`sshKey`) or `agent-config.yaml`.

Ensure the private key is secured with strict Unix permissions on the Helper Node:
```bash
chmod 0600 ~/.ssh/id_rsa
```

### 2. Helper Node SSH Client Configuration
To eliminate connection timeouts, host-key prompts, and enable fast jumping across the cluster, configure `/root/.ssh/config` or `~/.ssh/config` on the Helper Node:

```sshconfig
# OpenShift 4.20 Cluster Node Configuration
Host master-* worker-* infra-* *.corp.local 192.168.10.*
    User core
    IdentityFile ~/.ssh/id_rsa
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    ConnectTimeout 5
    ServerAliveInterval 15
    ServerAliveCountMax 3
```

### 3. Jumping to Nodes from the Helper Node
Connect directly to any control plane or worker node:
```bash
# Jump to master-0
ssh core@master-0.corp.local

# Jump directly via static IP
ssh -i ~/.ssh/id_rsa core@192.168.10.10
```

---

## Method 2: Serial-Over-LAN (SOL) via IPMI / BMC Redfish

When a node experiences a kernel panic, networking failure, or hangs during early boot, SSH is inaccessible. Access the node's serial console directly through the Baseboard Management Controller (BMC).

### 1. IPMI Serial-Over-LAN Activation
From the Helper Node, use `ipmitool` over RMCP+ (port 623 UDP):

```bash
# Establish active Serial-Over-LAN session
ipmitool -I lanplus -H <bmc-ip> -U <bmc-user> -P <bmc-password> sol activate
```

### 2. Exiting or Resetting a Hung SOL Session
If another administrator left a session open or the session hangs:
- **Exit SOL session**: Press `~.` (tilde followed immediately by period).
- **Force deactivate locked session**:
  ```bash
  ipmitool -I lanplus -H <bmc-ip> -U <bmc-user> -P <bmc-password> sol deactivate
  ```

### 3. Out-of-Band Power Management via IPMI
```bash
# Check current power status
ipmitool -I lanplus -H <bmc-ip> -U <bmc-user> -P <bmc-password> power status

# Graceful ACPI power off
ipmitool -I lanplus -H <bmc-ip> -U <bmc-user> -P <bmc-password> power soft

# Hard power cycle (reboot)
ipmitool -I lanplus -H <bmc-ip> -U <bmc-user> -P <bmc-password> power cycle
```

---

## Method 3: Hypervisor Virtual Consoles (Virtual Machine Topologies)

When running OpenShift virtualized on VMware vSphere, Nutanix AHV, Microsoft Hyper-V, or KVM:

### 1. KVM / RHOSO (Libvirt)
From the KVM hypervisor or helper host:
```bash
# Connect to RHCOS serial console
virsh console <domain-name>

# Exit virsh console: Press Ctrl + ]
```

### 2. VMware vSphere
- Open the **VMware Remote Console (VMRC)** or Web HTML5 console via vCenter.
- Press `Enter` to wake the screen; log in as `core`.

### 3. Microsoft Hyper-V / Azure Stack HCI
From the Windows Hyper-V host via PowerShell:
```powershell
# Open interactive VM console
vmconnect.exe localhost "ocp-master-0"

# Alternatively, query VM network adapters
Get-VMNetworkAdapter -VMName "ocp-master-0" | Select-Object VMName, IPAddresses, Status
```

---

## Essential Emergency Diagnostic Commands Inside RHCOS

Once logged into a node via SSH or console, execute these root-level diagnostics:

### 1. Container & Pod Diagnostics (`crictl`)
Because the Kubernetes API is down, use `crictl` to interact directly with CRI-O:

```bash
# List all running containers
sudo crictl ps

# List containers in crashloop or error
sudo crictl ps --state Exited

# View logs of the etcd or API server static pod
sudo crictl logs $(sudo crictl ps -a --name etcd-member -q | head -n1)
sudo crictl logs $(sudo crictl ps -a --name kube-apiserver -q | head -n1)

# Inspect pod sandbox status
sudo crictl pods
```

### 2. Systemd Core Daemon Inspection
```bash
# Check status of Kubelet and CRI-O
sudo systemctl status kubelet
sudo systemctl status crio

# Stream systemd journal logs
sudo journalctl -u kubelet -n 100 --no-pager
sudo journalctl -u crio -n 100 --no-pager
```

### 3. Static Pod Manifests & Core State
In OpenShift, core control plane pods are managed as static pods:
- Manifest directory: `/etc/kubernetes/manifests/` (`etcd-pod.yaml`, `kube-apiserver-pod.yaml`, `kube-controller-manager-pod.yaml`).
- Static pod resources & certificates: `/etc/kubernetes/static-pod-resources/`.
- Dynamic kubelet PKI directory: `/var/lib/kubelet/pki/`.

---

## Automated Bastion Jumping Tool (`scripts/helper-ssh-jump.sh`)

To eliminate manual IP lookups and automate emergency fallback to IPMI when SSH is dead, use the repository's helper tool:

```bash
# Jump to a node interactively
./scripts/helper-ssh-jump.sh master-0

# Jump and execute an emergency diagnostic command non-interactively
./scripts/helper-ssh-jump.sh master-0 "crictl ps && systemctl status kubelet"

# Jump with automated fallback to IPMI SOL console if SSH port 22 is unreachable
BMC_USER=root BMC_PASS=calvin BMC_IP=192.168.10.100 ./scripts/helper-ssh-jump.sh master-0
```
