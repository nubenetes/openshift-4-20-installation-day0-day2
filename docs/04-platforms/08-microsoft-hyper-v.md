# Microsoft Hyper-V & Azure Stack HCI Deployment Guide

Deploying Red Hat OpenShift Container Platform 4.20 on Microsoft Hyper-V (Windows Server 2022 / 2025) and Azure Stack HCI utilizes the **Agent-Based Installer (ABI)** or User-Provisioned Infrastructure (UPI) using `platform: none` or `platform: baremetal` with virtual IPs.

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Configure Hyper-V Virtual Switch & Subnet
1. Open Hyper-V Manager on Windows Server or Azure Stack HCI node.
2. Create an **External Virtual Switch** (e.g. `ExternalSwitch`) bound to a 10GbE/25GbE physical NIC.
3. Reserve static IPs for 3 Masters (`192.168.10.11-13`), Workers (`192.168.10.21-22`), and VIPs (`192.168.10.100` and `.101`).

### Step 2: Generate Agent-Based ISO
1. Generate `agent.x86_64.iso` containing static NMState IP addresses and Rendezvous IP.
2. Copy `agent.x86_64.iso` to the Hyper-V storage path (e.g. `C:\ISO\agent.x86_64.iso`).

### Step 3: Run Automated PowerShell VM Provisioning Script
1. Execute [`scripts/deploy-hyperv-vms.ps1`](../../scripts/deploy-hyperv-vms.ps1) as Administrator:
   ```powershell
   .\scripts\deploy-hyperv-vms.ps1 -ClusterName "ocp420" `
                                   -SwitchName "ExternalSwitch" `
                                   -IsoPath "C:\ISOgent.x86_64.iso" `
                                   -VmPath "C:\Hyper-V\Virtual Machines"
   ```
2. The script automates:
   - Creation of Generation 2 VMs with fixed/dynamic VHDX disks.
   - Setting static memory (disabling Dynamic Memory).
   - Configuring UEFI Secure Boot template to `MicrosoftUEFICertificateAuthority`.
   - Enabling **MAC Address Spoofing** on all virtual NICs for Keepalived VIP failover.
   - Attaching `agent.x86_64.iso` to virtual DVD drives.

### Step 4: Power On VMs & Monitor Bootstrap-in-Place
1. Power on all VMs simultaneously:
   ```powershell
   Get-VM -Name "ocp420-*" | Start-VM
   ```
2. The VMs boot into live RHCOS, discover each other, format VHDX disks, and establish Raft quorum.

### Step 5: Post-Install Verification & ISO Ejection
1. Track completion from your workstation:
   ```bash
   openshift-install agent wait-for install-complete --dir=.
   ```
2. Eject the ISO from the virtual DVD drives once installation is verified:
   ```powershell
   Get-VM -Name "ocp420-*" | Get-VMDvdDrive | Set-VMDvdDrive -Path $null
   ```

---
[Next: Public Cloud AWS](05-aws.md) • [Back to Platforms Index](README.md)
