# Agent-Based Installer (ABI) Deep Dive

The Agent-Based Installer (ABI) is the primary, state-of-the-art installation mechanism for on-premises bare-metal, VMware vSphere, Nutanix, and edge clusters in OpenShift 4.20.

---

## The Paradigm Shift: Bootstrap-in-Place

In traditional OpenShift 4 UPI/IPI installations, a 4th temporary **Bootstrap Node** was required. This bootstrap node hosted an ephemeral control plane to launch etcd and the Machine Config Operator, only to be permanently destroyed upon installation completion.

The Agent-Based Installer eliminates this waste using **Bootstrap-in-Place (BiP)**:

```mermaid
sequenceDiagram
    autonumber
    actor Admin as Platform Engineer
    participant Host1 as master-0 (Rendezvous Host)
    participant Host2 as master-1
    participant Host3 as master-2
    
    Admin->>Host1: Boot from agent.iso (Virtual Media / USB)
    Admin->>Host2: Boot from agent.iso
    Admin->>Host3: Boot from agent.iso
    
    Note over Host1,Host3: Assisted Agent runs in memory (RHCOS Live)
    Host2->>Host1: Connect to Rendezvous IP (Assisted Service)
    Host3->>Host1: Connect to Rendezvous IP (Assisted Service)
    
    Host1->>Host1: Bootstrap-in-Place: Starts temporary single-node etcd
    Host1->>Host2: Instructs installation & node joining
    Host1->>Host3: Instructs installation & node joining
    
    Note over Host1,Host3: 3-Node etcd Quorum formed
    Host1->>Host1: Pivots temporary bootstrap into permanent master-0
    Host1-->>Admin: Installation Complete! Cluster Available
```

---

## Key Configuration Files

The Agent-Based Installer is driven by two declarative YAML manifests:
1. `install-config.yaml`: Defines cluster metadata, network CIDRs, platform parameters, and pull secret.
2. `agent-config.yaml`: Defines the Rendezvous IP, target host MAC addresses, network interfaces (NMState for static IPs or bonds), and root disk hints.

Example generation command:
```bash
openshift-install agent create image --dir=./cluster-workspace
```
Outputs `agent.x86_64.iso` ready to be mounted via Redfish BMC virtual media.

---
[Next: Installer Provisioned Infrastructure (IPI)](02-installer-provisioned-ipi.md) • [Back to Index](README.md)
