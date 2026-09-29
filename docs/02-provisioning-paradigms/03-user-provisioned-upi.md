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

## Step-by-Step UPI Execution Workflow

1. **Ignition Config Generation**:
   ```bash
   openshift-install create ignition-configs --dir=./upi-workspace
   ```
   Generates `bootstrap.ign`, `master.ign`, `worker.ign`, and `metadata.json`.
2. **Infrastructure Pre-Requisites**:
   - Host Ignition files on an internal web server (e.g. `http://webserver.corp.local:8080/master.ign`).
   - Configure external load balancers targeting API (6443) and Machine Config Server (22623).
3. **VM Deployment**:
   - Provision VMs and inject the Ignition URL via kernel boot parameter:
     ```
     coreos.inst.ignition_url=http://webserver.corp.local:8080/master.ign
     ```
4. **Bootstrap Sign-off & CSR Approval**:
   - Monitor bootstrap completion:
     ```bash
     openshift-install wait-for bootstrap-complete --dir=./upi-workspace --log-level=info
     ```
   - Approve node Certificate Signing Requests (CSRs):
     ```bash
     oc get csr -o name | xargs oc adm certificate approve
     ```

---
[Next: GitOps Zero Touch Provisioning (ZTP)](04-ztp-acm-gitops.md) • [Back to Index](README.md)
