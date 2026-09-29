# etcd Backup, Recovery & Quorum Loss Restoration

etcd stores the state of every resource in the OpenShift cluster. Loss of etcd quorum renders the cluster API unresponsive and halts scheduling.

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Automated Daily etcd Snapshot Scheduling
1. Deploy the automated etcd backup CronJob to the `openshift-etcd` namespace:
   ```bash
   oc apply -f configs/day2/etcd-backup-cronjob.yaml
   ```
2. Verify the CronJob is scheduled (defaults to 02:00 AM daily):
   ```bash
   oc get cronjob -n openshift-etcd
   ```

### Step 2: Manual On-Demand Pre-Upgrade Backup
1. Before performing any cluster upgrade or major maintenance, execute a manual snapshot:
   ```bash
   ./scripts/etcd-backup.sh
   ```
2. The script executes `/usr/local/bin/cluster-backup.sh`, verifies snapshot integrity, and saves archives to `/var/recovery/etcd-backups/`.

### Step 3: Quorum Loss Detection & Node Assessment
1. Symptoms of etcd quorum loss:
   - `oc` commands fail with `The connection to the server api.<cluster> was refused` or `Client.Timeout exceeded`.
   - 2 out of 3 master nodes fail simultaneously.
2. Select one surviving control plane node (e.g., `master-0`) to serve as the recovery host.

### Step 4: Stop Master Static Pods on Recovery Node
1. Connect via SSH to `master-0`:
   ```bash
   ssh core@master-0.corp.local
   sudo -i
   ```
2. Move static pod manifests out of `/etc/kubernetes/manifests/` to halt running etcd and kube-apiserver containers:
   ```bash
   mv /etc/kubernetes/manifests/etcd-pod.yaml /tmp/
   mv /etc/kubernetes/manifests/kube-apiserver-pod.yaml /tmp/
   ```

### Step 5: Execute etcd Recovery Script
1. Run the official Red Hat recovery script, passing the verified snapshot file:
   ```bash
   /usr/local/bin/cluster-restore-etcd.sh /var/home/core/assets/backup/snapshot_YYYY_MM_DD.db
   ```
2. The script resets the Raft cluster membership, configures `master-0` as a single-node cluster, and restores the key-value database.

### Step 6: Restart Static Pods & Re-Establish Quorum
1. Move static pod manifests back to restore control plane services:
   ```bash
   mv /tmp/etcd-pod.yaml /etc/kubernetes/manifests/
   mv /tmp/kube-apiserver-pod.yaml /etc/kubernetes/manifests/
   ```
2. Wait for `kube-apiserver` and `etcd` static pods to report healthy.

### Step 7: Re-Join and Re-Install Peer Master Nodes
1. Re-install or reboot `master-1` and `master-2`.
2. Delete the old etcd member pods from `openshift-etcd` to allow the etcd-operator to force peer synchronization.
3. Validate 3-node quorum restoration:
   ```bash
   oc get pods -n openshift-etcd
   ```

---
[Next: OADP vs Velero Deep-Dive](02-oadp-vs-velero-deepdive.md) • [Back to DR Index](README.md)
