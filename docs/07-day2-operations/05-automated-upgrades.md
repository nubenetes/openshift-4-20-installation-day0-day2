# Automated Cluster Lifecycle & Upgrade Engineering

OpenShift 4.20 introduces enhanced lifecycle management, supporting Extended Update Support (EUS), automated canary worker pools, and disconnected update pipelines.

---

## Why OpenShift Upgrades Require Strict Orchestration

Unlike generic Kubernetes distributions where upgrading involves replacing binary packages manually, OpenShift orchestrates hundreds of coordinated tasks across operating systems and control plane operators:
1. **RHCOS In-Place Pivot**: Every node upgrade downloads an ostree container payload and updates the underlying operating system kernel, systemd units, and CRI-O configuration.
2. **Kubernetes API Deprecations**: The Kubernetes version advances (e.g. 1.31 -> 1.32). Applications using deprecated APIs will fail unless identified beforehand.
3. **Control Plane Quorum Lock**: If etcd Raft consensus fails during an upgrade, the API goes down permanently.
4. **No Rollback Capability**: Kubernetes and OpenShift **do not support automated downgrades/rollbacks** once etcd schema migrations have occurred. Restoring an etcd snapshot taken immediately prior to the upgrade is the **only disaster recovery mechanism**.

---

## Mandatory Pre-Upgrade Architecture & Checklist

```mermaid
flowchart TD
    PreCheck[1. Execute pre-upgrade-health-check.sh] --> CheckCO{Are all 34+ ClusterOperators healthy?}
    CheckCO -- No --> Halt1[ABORT: Fix degraded operators first]
    CheckCO -- Yes --> CheckBackup{Has etcd been backed up within 24h?}
    CheckBackup -- No --> Halt2[ABORT: Run etcd-backup.sh immediately]
    CheckBackup -- Yes --> CheckAPIs{Are there deprecated API calls?}
    CheckAPIs -- Yes --> ResolveAPIs[Remediate workloads before upgrade]
    CheckAPIs -- No --> PauseWorker[2. Pause Worker MachineConfigPool<br/>spec.paused: true]
    PauseWorker --> TriggerUpgrade[3. Trigger oc adm upgrade --to=target]
    TriggerUpgrade --> MonitorCP[4. Monitor Control Plane & CVO to completion]
    MonitorCP --> UnpauseWorker[5. Unpause Worker MCP<br/>Rolling reboot under maxUnavailable: 1]
    UnpauseWorker --> PostVerify[6. Execute validate-cluster-health.sh]
```

---

## Upgrade Scenarios & Automation Scripts

### 1. Standard Production Upgrade (Connected / Hybrid)
Utilize [`scripts/automated-cluster-upgrade.sh`](../../scripts/automated-cluster-upgrade.sh):
```bash
./scripts/automated-cluster-upgrade.sh 4.20.1
```
The script automatically:
1. Executes [`scripts/pre-upgrade-health-check.sh`](../../scripts/pre-upgrade-health-check.sh).
2. Takes an automated etcd snapshot via [`scripts/etcd-backup.sh`](../../scripts/etcd-backup.sh).
3. Pauses the worker `MachineConfigPool` (`oc patch mcp worker --type=merge -p '{"spec":{"paused":true}}'`).
4. Initiates the upgrade and monitors the Cluster Version Operator (CVO).
5. Unpauses the worker pool for controlled sequential worker draining and node updates.
6. Runs post-upgrade health verification.

### 2. Disconnected / Air-Gapped Cluster Upgrade
Air-gapped clusters cannot reach `api.openshift.com` or `quay.io`. Run [`scripts/airgap-upgrade.sh`](../../scripts/airgap-upgrade.sh):
```bash
LOCAL_REGISTRY=quay.internal.corp:8443/openshift4 ./scripts/airgap-upgrade.sh 4.20.1
```
The script:
1. Mirrors the release payload, metadata, and graph using `oc-mirror` v2.
2. Applies the generated `ImageDigestMirrorSet` (IDMS) manifests.
3. Initiates the upgrade directly using the mirrored release image digest.

### 3. Single Node OpenShift (SNO) Upgrade
- Because SNO runs control plane and user workloads on a single physical host, an upgrade **will cause temporary workload downtime** during the node reboot (typically 3 to 7 minutes).
- SNO upgrades should be scheduled during maintenance windows or coordinated fleet-wide via Red Hat Advanced Cluster Management (ACM) and TALM.

---
[Back to Day 2 Index](README.md) • [Next Chapter: Backup, DR & Rebuild](../08-backup-dr-and-rebuild/README.md)
