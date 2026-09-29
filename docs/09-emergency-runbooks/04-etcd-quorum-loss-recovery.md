# Emergency etcd Single-Member Quorum Restoration & Split-Brain Recovery

## Failure Scenario & Quorum Mechanics

OpenShift 4.20 requires a minimum of **(N/2) + 1** active control plane nodes to maintain etcd Raft consensus:
- In a standard **3-master cluster**, quorum requires at least **2 masters online**.
- If **2 masters are lost simultaneously** (e.g. storage array crash, rack power failure, double disk failure), the cluster loses etcd quorum.

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                   CATASTROPHIC QUORUM COLLAPSE                                   │
├──────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                  │
│   [master-0: HEALTHY]         [master-1: DEAD]            [master-2: DEAD]                       │
│            │                          │                           │                              │
│            ▼                          ▼                           ▼                              │
│   Attempting Raft Vote        No Response (Offline)       No Response (Offline)                  │
│                                                                                                  │
│   Result: 1 / 3 votes (33%) < 50%+1 quorum requirement.                                          │
│   Status: etcd rejects all reads and writes.                                                     │
│   Symptom: kube-apiserver terminates. External "oc" commands fail with Connection Refused.       │
│                                                                                                  │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```

> [!CAUTION]
> **Cluster Cannot Auto-Heal**:
> A cluster that has lost etcd quorum will **never recover on its own**, even if the surviving master has 100% of the cluster state intact. You must manually force the surviving node to become a **single-member cluster leader**, restore API server operation, and then reintegrate the remaining two nodes.

---

## Pre-Recovery Strategy

1. **Choose the Seed Master**: Select the surviving master with the most recent transaction state (highest Raft index) or the Rendezvous node (`master-0`).
2. **Execute from Helper Node**: All commands must be issued via SSH from the Bastion/Helper Node to the seed master (`core@master-0`).
3. **Locate etcd Snapshot**: Determine whether restoring from a recent verified snapshot ([`scripts/etcd-backup.sh`](../../scripts/etcd-backup.sh)) or from the local surviving `/var/lib/etcd` data directory.

---

## End-to-End Step-by-Step Restoration Procedure

### Step 1: SSH into the Surviving Master
```bash
ssh -i ~/.ssh/id_rsa core@master-0.corp.local
```

Verify that the other two masters are genuinely unreachable or powered off before proceeding:
```bash
ping -c 2 master-1.corp.local || echo "master-1 is down"
ping -c 2 master-2.corp.local || echo "master-2 is down"
```

---

### Step 2: Quench Static Pods on Master-0
Move static pod manifests out of `/etc/kubernetes/manifests` so CRI-O cleanly stops the conflicting control plane containers:

```bash
sudo mkdir -p /tmp/manifests-backup
sudo mv /etc/kubernetes/manifests/* /tmp/manifests-backup/
```

Verify that etcd and kube-apiserver containers have stopped:
```bash
sudo crictl ps --name etcd-member
sudo crictl ps --name kube-apiserver
```

---

### Step 3: Execute Single-Member Disaster Recovery Script
RHCOS includes an emergency etcd snapshot restore script at `/usr/local/bin/etcd-snapshot-restore.sh`.

#### Option A: Restore from a Known Good Snapshot
If you have a fresh pre-disaster snapshot taken via [`scripts/etcd-backup.sh`](../../scripts/etcd-backup.sh):
```bash
# Copy snapshot to master-0 if on helper node
sudo /usr/local/bin/etcd-snapshot-restore.sh /var/lib/etcd-backup/snapshot_<timestamp>.db
```

#### Option B: Force Local Surviving Database into Single-Member Mode
If restoring directly from the current in-place database on `master-0`:
1. Take an immediate emergency local snapshot of the current raw `/var/lib/etcd` directory:
   ```bash
   sudo ETCDCTL_API=3 etcdctl snapshot save /tmp/emergency-live-snapshot.db      --cacert=/etc/kubernetes/static-pod-resources/etcd-certs/secrets/etcd-all-certs/etcd-ca-bundle.crt      --cert=/etc/kubernetes/static-pod-resources/etcd-certs/secrets/etcd-all-certs/etcd-serving-master-0.crt      --key=/etc/kubernetes/static-pod-resources/etcd-certs/secrets/etcd-all-certs/etcd-serving-master-0.key
   ```
2. Execute the single-member restore:
   ```bash
   sudo /usr/local/bin/etcd-snapshot-restore.sh /tmp/emergency-live-snapshot.db
   ```

*What this script does*:
- Erases the multi-node peer member list in the database.
- Sets the cluster ID to a new single-member identity containing only `master-0`.
- Places the new database in `/var/lib/etcd/data`.

---

### Step 4: Restore Static Pod Manifests
Move the static pod manifests back into the active directory:

```bash
sudo mv /tmp/manifests-backup/* /etc/kubernetes/manifests/
```

Kubelet will automatically detect the manifests and start the single-member etcd container:
```bash
sudo crictl ps | grep etcd-member
```

Stream logs to verify that etcd has elected itself leader of the new 1-member cluster:
```bash
sudo crictl logs $(sudo crictl ps -a --name etcd-member -q | head -n1)
```
*Expected Log*: `elected leader of 1-member cluster at term ...`

---

### Step 5: Verify API Server Recovery
Within 2–3 minutes, the `kube-apiserver` static pod will detect healthy etcd endpoints on localhost (port 2379) and begin serving requests:

```bash
export KUBECONFIG=/etc/kubernetes/static-pod-resources/kube-apiserver-certs/secrets/node-kubeconfigs/lb-ext.kubeconfig
oc get nodes
```
*Expected Output*: `master-0` reports `Ready`; `master-1` and `master-2` report `NotReady`.

---

### Step 6: Clear Stale Control Plane Machine & Node Entries
From the Helper Node, remove the dead control plane nodes from the cluster inventory:

```bash
for dead_node in master-1.corp.local master-2.corp.local; do
  echo "Deleting stale node: ${dead_node}"
  oc delete node "${dead_node}" --ignore-not-found
done
```

---

### Step 7: Incrementally Rebuild 3-Master Quorum
Follow the procedure in [`docs/09-emergency-runbooks/03-node-reinstallation-and-replacement.md`](03-node-reinstallation-and-replacement.md) to sequentially reinstall:
1. Reinstall `master-1` -> approve CSRs -> verify etcd grows to 2 members.
2. Reinstall `master-2` -> approve CSRs -> verify etcd grows to 3 members.
3. Validate final quorum:
   ```bash
   oc rsh -n openshift-etcd $(oc get pods -n openshift-etcd -l app=etcd --no-headers | head -n1 | awk '{print $1}') etcdctl endpoint health -w table
   ```

---

## Automated Tooling

To execute this single-member recovery automatically in a disaster scenario, run:
```bash
./scripts/emergency-etcd-single-member.sh master-0.corp.local
```
