# OADP vs Vanilla Velero: Exhaustive Architectural Evaluation

A frequent question among platform architects is: **"Can we simply install vanilla upstream Velero on OpenShift instead of OADP?"**

The definitive technical verdict is: **NO. Vanilla Velero is neither recommended nor supported on OpenShift. OADP is mandatory.**

---

## Technical Comparison Matrix

| Capability / Requirement | Vanilla Upstream Velero | Red Hat OADP (OpenShift API for Data Protection) |
| :--- | :---: | :---: |
| **OpenShift CRD Support** | ❌ Fails (Ignores OpenShift metadata) | ✅ Native OpenShift Backup Plugin included |
| **Security Context Constraints (SCC)** | ❌ Blocked by restricted-v2 SCC | ✅ Pre-configured with compliant privileged SCCs |
| **Route & Ingress Translation** | ❌ Drops Route metadata & certificates | ✅ Restores full TLS keys, CA certs, and route endpoints |
| **DeploymentConfig & BuildConfig** | ❌ Fails to translate triggers/revisions | ✅ Preserves build history, image streams, and triggers |
| **UID / GID Range Preservation** | ❌ Breaks when restoring across namespaces | ✅ Translates OpenShift allocated UID/GID ranges |
| **CSI VolumeSnapshot Integration** | Requires manual configuration | ✅ Automated out-of-the-box via CSI plugin |
| **Red Hat Enterprise Support** | ❌ Unsupported (Community only) | ✅ Full Red Hat L1-L3 24x7 Production SLA |

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Install OADP Operator
1. Subscribe to the **OADP Operator** from the Red Hat OperatorHub:
   ```bash
   oc create namespace openshift-adp
   oc apply -f configs/day2/oadp-operator-sub.yaml
   ```
2. Wait for OADP operator pod to be `Running`.

### Step 2: Configure Cloud Storage Credentials (S3 / MinIO / Ceph RGW)
1. Store object store credentials in a secret:
   ```bash
   cat << EOF > /tmp/credentials-velero
   [default]
   aws_access_key_id = EnterpriseBackupKey
   aws_secret_access_key = EnterpriseBackupSecret
   EOF

   oc create secret generic cloud-credentials      --namespace openshift-adp      --from-file cloud=/tmp/credentials-velero
   rm /tmp/credentials-velero
   ```

### Step 3: Deploy DataProtectionApplication (DPA) Custom Resource
1. Deploy the DPA CR with **Kopia** data-mover enabled (see [`configs/day2/oadp-dpa-cr.yaml`](../../configs/day2/oadp-dpa-cr.yaml)):
   ```bash
   oc apply -f configs/day2/oadp-dpa-cr.yaml
   ```
2. Verify Velero pod and node-agent daemonset are active:
   ```bash
   oc get pods -n openshift-adp
   ```

### Step 4: Execute Application & Persistent Volume Backup
1. Trigger an on-demand backup of target namespace:
   ```yaml
   apiVersion: velero.io/v1
   kind: Backup
   metadata:
     name: payment-app-backup
     namespace: openshift-adp
   spec:
     includedNamespaces:
       - payment-system
     snapshotVolumes: true
     storageLocation: dpa-enterprise-prod-1
   ```
2. Check backup progress:
   ```bash
   oc describe backup payment-app-backup -n openshift-adp
   ```

### Step 5: Disaster Recovery & Restore Drill
1. Simulate namespace corruption or disaster:
   ```bash
   oc delete namespace payment-system
   ```
2. Trigger the restore:
   ```yaml
   apiVersion: velero.io/v1
   kind: Restore
   metadata:
     name: payment-app-restore
     namespace: openshift-adp
   spec:
     backupName: payment-app-backup
     restorePVs: true
   ```
3. OADP reconstructs the namespace, allocates valid UIDs, re-attaches PVC snapshots, restores Routes with TLS certificates, and brings workloads online.

---
[Next: Metro-DR & Regional-DR](03-metro-dr-and-regional-dr.md) • [Back to DR Index](README.md)
