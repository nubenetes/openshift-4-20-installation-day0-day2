# 04 - Platform Specific Architecture & Deployment Guides

OpenShift 4.20 provides deep, platform-native integrations across on-premises bare-metal, private virtualization stacks, and hyper-scale public clouds.

---

## Platform Support & Integration Matrix

| Platform | Primary Provisioning Method | CSI Storage Provider | Node Automation (MachineSets) | Special Considerations |
| :--- | :--- | :--- | :---: | :--- |
| **Bare Metal** | Agent-Based / ZTP Redfish | ODF (Ceph) / LSO | Yes (via Metal3 / Ironic) | IPMI/Redfish BMC virtual media |
| **VMware vSphere 8/9**| Agent-Based or IPI | vSphere CSI Driver | Yes (vCenter integration) | VCF / NSX ALB vs Keepalived VIPs |
| **Nutanix AHV** | Nutanix IPI or ABI | Nutanix CSI Driver | Yes (Prism Central) | Prism Central 2024.x+ integration |
| **KVM / OpenStack** | ABI / OpenStack IPI | Cinder CSI / ODF | Yes (RHOSO / Nova) | KubeVirt coexistence & SR-IOV |
| **AWS** | Cloud IPI / Private VPC | AWS EBS / EFS CSI | Yes (EC2 Auto Scaling) | STS / IRSA short-lived tokens |
| **Azure** | Cloud IPI / Private VNet | Azure Managed Disk CSI | Yes (Azure VMSS) | Azure Workload Identity Federation |
| **GCP** | Cloud IPI / Shared VPC | Google Compute Engine PD | Yes (GCP MIG) | GCP Workload Identity & PSC |

---
[Back to Global Navigation](../00-navigation.md)
