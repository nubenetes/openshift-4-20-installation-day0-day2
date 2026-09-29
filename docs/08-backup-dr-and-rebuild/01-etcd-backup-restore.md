# etcd Backup, Recovery & Quorum Loss Restoration

etcd stores the state of every resource in the OpenShift cluster. Loss of etcd quorum renders the cluster API unresponsive and halts scheduling.

---

## 1. Automated etcd Snapshot Scheduling
Run the official Red Hat backup utility via scheduled CronJob (see [`configs/day2/etcd-backup-cronjob.yaml`](../../configs/day2/etcd-backup-cronjob.yaml)) or manually via `scripts/etcd-backup.sh`.

---

## 2. Quorum Loss Recovery Procedure (Step-by-Step)

If 2 out of 3 master nodes are destroyed and etcd cannot form quorum:

1. **Select Recovery Master**: Choose one remaining healthy control plane host (e.g. `master-0`).
2. **Stop Control Plane Static Pods**:
   ```bash
   ssh core@master-0.corp
   sudo -i
   mv /etc/kubernetes/manifests/etcd-pod.yaml /tmp/
   mv /etc/kubernetes/manifests/kube-apiserver-pod.yaml /tmp/
   ```
3. **Run etcd Snapshot Restore Script**:
   ```bash
   /usr/local/bin/cluster-restore-etcd.sh /var/home/core/etcd-backup-snapshot.db
   ```
4. **Restart Static Pods**:
   ```bash
   mv /tmp/etcd-pod.yaml /etc/kubernetes/manifests/
   mv /tmp/kube-apiserver-pod.yaml /etc/kubernetes/manifests/
   ```
5. **Verify Single-Node Quorum & Re-join Peers**:
   Once `master-0` is healthy, force re-enrollment of `master-1` and `master-2` via `oc get pods -n openshift-etcd`.

---
[Next: OADP vs Velero Deep-Dive](02-oadp-vs-velero-deepdive.md) • [Back to DR Index](README.md)
