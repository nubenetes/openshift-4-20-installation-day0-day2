# 04 - Platform Specific Architecture & Deployment Guides

OpenShift 4.20 provides deep, platform-native integrations across on-premises bare-metal, private virtualization stacks, hyper-scale public clouds, and native OpenShift Virtualization.

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
| **Microsoft Hyper-V** | Agent-Based / PowerShell UPI | ODF / Local VHDX / SMB CSI | Manual / External IaC | Gen 2 UEFI, MicrosoftUEFICACert, MAC Spoofing |
| **OpenShift Virtualization** | HyperConverged (HCO) on Bare Metal | ODF Ceph RBD (RWX Block) | Yes (KubeVirt CRDs) | MTV 2.8+ vCenter live warm migration |

---

## Section Documents
- [01. Physical Bare Metal](01-bare-metal-physical.md)
- [02. VMware vSphere 8.x / 9.x](02-vmware-vsphere.md)
- [03. Nutanix AHV HCI](03-nutanix-ahv.md)
- [04. KVM & OpenStack (RHOSO)](04-kvm-openstack.md)
- [05. Amazon Web Services (AWS)](05-aws.md)
- [06. Microsoft Azure](06-azure.md)
- [07. Google Cloud Platform (GCP)](07-gcp.md)
- [08. Microsoft Hyper-V & Azure Stack HCI](08-microsoft-hyper-v.md)
- [09. OpenShift Virtualization & MTV](09-openshift-virtualization.md)

---
[Back to Global Navigation](../00-navigation.md)
