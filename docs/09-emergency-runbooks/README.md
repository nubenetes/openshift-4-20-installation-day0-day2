# Emergency Operational Runbooks & Disaster Troubleshooting Index

This directory provides battle-tested, procedural runbooks and operational scripts to diagnose, triage, and recover from catastrophic and degraded states in **Red Hat OpenShift Container Platform 4.20**.

These runbooks are specifically designed for operational realities where standard high-level tools (`oc debug node`, web console, Prometheus alerts) may be **completely unavailable** due to API server failure, network partition, certificate expiration, or quorum loss.

---

## Incident Severity & Triage Framework

| Severity Level | Impact & Failure State | Core Symptoms | Primary Runbook | Recovery Automation Script |
| :--- | :--- | :--- | :--- | :--- |
| **Sev-1: Catastrophic Outage** | Complete cluster control plane loss; API server unresponsive. | `x509: certificate has expired`, `connection refused` on 6443, etcd quorum loss. | [`01-expired-certs-recovery.md`](01-expired-certs-recovery.md)<br/>[`04-etcd-quorum-loss-recovery.md`](04-etcd-quorum-loss-recovery.md) | [`scripts/recover-expired-certs.sh`](../../scripts/recover-expired-certs.sh)<br/>[`scripts/emergency-etcd-single-member.sh`](../../scripts/emergency-etcd-single-member.sh) |
| **Sev-2: Degraded Master / Split-Brain Risk** | Loss or corruption of a single control plane node (2 of 3 healthy). | `etcd-quorum-guard` alerts, master node `NotReady`, hardware disk failure. | [`03-node-reinstallation-and-replacement.md`](03-node-reinstallation-and-replacement.md) | [`scripts/replace-control-plane-node.sh`](../../scripts/replace-control-plane-node.sh) |
| **Sev-2: Infrastructure Lockout** | Inability to access cluster nodes via standard Kubernetes tooling. | API server down, SDN broken, Bastion access required. | [`02-helper-node-access-and-jumping.md`](02-helper-node-access-and-jumping.md) | [`scripts/helper-ssh-jump.sh`](../../scripts/helper-ssh-jump.sh) |
| **Sev-3: Node Degradation & Deadlock** | Worker node failure, MachineConfigPool stuck in `Updating=True`, disk full. | Drain timeouts, overlayfs 100% full, kubelet eviction deadlock. | [`03-node-reinstallation-and-replacement.md`](03-node-reinstallation-and-replacement.md)<br/>[`05-machineconfig-and-storage-recovery.md`](05-machineconfig-and-storage-recovery.md) | [`scripts/reinstall-worker-node.sh`](../../scripts/reinstall-worker-node.sh) |

---

## Emergency Runbooks Catalog

1. **[`01-expired-certs-recovery.md`](01-expired-certs-recovery.md)**:
   * **Scope**: Clusters powered off or disconnected for >30 days / >1 year where kubelet client and serving certificates have expired.
   * **Execution**: Executed directly from the **Helper Node** via SSH without relying on a functional API server.
   * **Mechanism**: Kubelet certificate purge, bootstrap kubeconfig restoration, emergency static pod startup, and manual/automated CSR re-approval loop.

2. **[`02-helper-node-access-and-jumping.md`](02-helper-node-access-and-jumping.md)**:
   * **Scope**: Out-of-band node access when `oc debug node` or cluster networking is non-functional.
   * **Execution**: Helper Node SSH bastion routing (`core` user), private key validation, Serial-Over-LAN (SOL) via IPMI / Redfish, and hypervisor console access (vSphere, Hyper-V, KVM).

3. **[`03-node-reinstallation-and-replacement.md`](03-node-reinstallation-and-replacement.md)**:
   * **Scope**: Replacing broken, corrupted, or upgraded physical/virtual control plane and worker nodes.
   * **Execution**: Multiple workflows: Automated CLI scripts, Bare-metal Agent ISO boot, Assisted Installer Web UI, OpenShift Web Console, and ACM multicluster fleet management.
   * **Mechanism**: Clean etcd member deletion, node object cleanup, reprovisioning, CSR approval, and etcd cluster member re-addition.

4. **[`04-etcd-quorum-loss-recovery.md`](04-etcd-quorum-loss-recovery.md)**:
   * **Scope**: Loss of 2 out of 3 control plane nodes resulting in complete loss of etcd Raft consensus.
   * **Execution**: Helper-node orchestrated single-member cluster restoration on the surviving master node, resetting cluster membership, bringing API server online, and re-adding new masters.

5. **[`05-machineconfig-and-storage-recovery.md`](05-machineconfig-and-storage-recovery.md)**:
   * **Scope**: MachineConfigPool degraded states, node drain deadlocks, and container storage (`/var/lib/containers`) overlay exhaustion.
   * **Execution**: SSH intervention via `crictl`, clearing dangling image layers, overriding node drain timeouts, and reconciling MCO degraded operators.

---

## Operational Safety Rules During Emergencies

> [!CAUTION]
> **Rule 1: Never Force Reboots Simultaneously on Multiple Masters**:
> During etcd degradation or certificate expiration, rebooting multiple control plane nodes simultaneously will destroy in-memory Raft state and cause unrecoverable quorum loss. Always work node-by-node.

> [!IMPORTANT]
> **Rule 2: Execute from the Helper Node**:
> When the cluster API server is unresponsive (`connection refused` on port 6443), all remediation commands must originate from the designated Bastion/Helper Node using the cluster CoreOS SSH key (`~/.ssh/id_rsa_ocp` or `/root/.ssh/id_rsa`).

> [!TIP]
> **Rule 3: Check System Clocks Before Touching Certificates**:
> A clock drift of even a few minutes can cause certificate validation failures (`x509: certificate has expired or is not yet valid`). Always verify NTP synchronization with `chronyc sources -v` across all nodes before regenerating certificates.
