# Cluster Lifecycle & EUS-to-EUS Upgrades

OpenShift 4.20 supports Extended Update Support (EUS), allowing enterprise organizations to transition between even-numbered releases (e.g. 4.18 -> 4.20) with minimal disruption.

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Subscribe to EUS Channel
1. Inspect available channels:
   ```bash
   oc get clusterversion -o jsonpath='{.items[0].spec.channel}'
   ```
2. Set channel to `eus-4.20` or `stable-4.20`:
   ```bash
   oc patch clusterversion version --type=merge -p '{"spec":{"channel":"eus-4.20"}}'
   ```

### Step 2: Audit API Request Counts for Deprecations
1. Review deprecated API usage:
   ```bash
   oc get apirequestcounts -o jsonpath='{range .items[?(@.status.removedInRelease!="")]}{.metadata.name}{" - RemovedIn: "}{.status.removedInRelease}{"\n"}{end}'
   ```

### Step 3: Execute Pre-Upgrade Audit & Mandatory etcd Snapshot
1. Run [`scripts/pre-upgrade-health-check.sh`](../../scripts/pre-upgrade-health-check.sh).
2. Take a fresh etcd snapshot via [`scripts/etcd-backup.sh`](../../scripts/etcd-backup.sh).

### Step 4: Orchestrate Upgrade via automated-cluster-upgrade.sh
1. Trigger the fully orchestrated upgrade:
   ```bash
   ./scripts/automated-cluster-upgrade.sh 4.20.1
   ```
2. The orchestrator pauses the worker pool, updates the control plane CVO, and rolls out workers sequentially.

---
[Next: Automated Upgrades Deep-Dive](05-automated-upgrades.md) • [Back to Day 2 Index](README.md)
