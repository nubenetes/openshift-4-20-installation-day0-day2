# Air-Gapped Core Services: DNS, NTP & Internal PKI

An air-gapped OpenShift 4.20 cluster requires three indispensable foundation services within the isolated network: **Split-Horizon Internal DNS**, **High-Precision Local NTP**, and **Enterprise Internal PKI**.

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Configure Internal Split-Horizon DNS (BIND9 / Infoblox)
1. Create forward zone `corp.local` with required records:
   ```zone
   api.ocp420.corp.local.       IN  A  192.168.10.100
   api-int.ocp420.corp.local.   IN  A  192.168.10.100
   *.apps.ocp420.corp.local.    IN  A  192.168.10.101
   master-0.ocp420.corp.local.  IN  A  192.168.10.11
   master-1.ocp420.corp.local.  IN  A  192.168.10.12
   master-2.ocp420.corp.local.  IN  A  192.168.10.13
   ```
2. Create reverse lookup zone (`10.168.192.in-addr.arpa`) mapping each IP to its FQDN.
3. Validate with `dig`:
   ```bash
   dig +short api.ocp420.corp.local @192.168.10.1
   dig +short -x 192.168.10.11 @192.168.10.1
   ```

### Step 2: Deploy Local Stratum-1/2 NTP Server (Chrony)
1. Configure an internal Linux host as a local NTP stratum synchronized against GPS or hardware clock:
   ```ini
   # /etc/chrony.conf on local NTP server
   local stratum 8
   allow 192.168.10.0/24
   ```
2. Create an OpenShift `MachineConfig` pointing all cluster nodes to this internal NTP server (see [`configs/day1/machineconfig-chrony.yaml`](../../configs/day1/machineconfig-chrony.yaml)).

### Step 3: Establish Internal Enterprise Root & Intermediate PKI
1. Generate corporate root CA and signing intermediate certificate.
2. Issue wildcard TLS certificate for `*.apps.ocp420.corp.local` and registry certificate for `quay.internal.corp`.
3. Embed root CA into `install-config.yaml` under `additionalTrustBundle`.

### Step 4: Deploy Air-Gapped Red Hat Quay / Harbor
1. Install standalone Red Hat Quay or Harbor container registry on an internal server.
2. Configure persistent storage (NFS / SAN) for Quay image layers.
3. Load the mirrored OpenShift 4.20 payload into Quay.

---
[Next: OVN-Kubernetes Tuning](04-ovn-kubernetes-tuning.md) • [Back to Index](README.md)
