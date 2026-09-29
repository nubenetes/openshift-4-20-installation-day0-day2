# Emergency Recovery: Expired Control Plane & Data Plane Certificates

## Overview & Failure Mechanics

In Red Hat OpenShift 4.20, Kubernetes internal certificates rotate automatically during normal online cluster operation:
- **Kubelet Client Certificates**: Valid for **30 days**; rotated dynamically by the `cluster-kube-apiserver-operator` and kubelet when ~80% of life has passed.
- **Serving Certificates (Kube-apiserver, Ingress, Router)**: Valid for **1 to 2 years**.
- **Admin Kubeconfigs**: Valid for **1 to 5 years**.

When a cluster experiences a **prolonged shutdown** (e.g. lab power-off, datacenter maintenance, seasonal shutdown) or remains **air-gapped and disconnected** without NTP time sync for longer than **30 consecutive days**, the kubelet client certificates expire.

```
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                 THE EXPIRED CERTIFICATE DEADLOCK                                 │
├──────────────────────────────────────────────────────────────────────────────────────────────────┤
│ 1. Nodes boot after 30+ days offline. Kubelet client cert is expired (validity: 30 days).         │
│ 2. Kubelet fails to authenticate to kube-apiserver: "x509: certificate has expired".             │
│ 3. Kube-apiserver static pods fail liveness/readiness probes and crash.                         │
│ 4. "oc" CLI commands from external bastions fail: "connection refused" or "x509: expired".      │
│ 5. Automated certificate rotation cannot run because it requires a functional API server!       │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```

> [!CAUTION]
> **API Server Inaccessibility**:
> You **cannot** fix this problem by running `oc` commands from an external workstation, because the cluster API server is down or rejecting unauthenticated connections. All recovery commands **must be orchestrated from the Helper / Bastion Node directly to the nodes via SSH**.

---

## Prerequisites & Preflight Checks

Before attempting certificate renewal, ensure the following are accessible from the Helper Node:
1. **CoreOS SSH Private Key**: Located at `~/.ssh/id_rsa`, `~/.ssh/id_rsa_ocp`, or `/root/.ssh/id_rsa`.
2. **Network Reachability**: Static IP reachability to all control plane nodes (`master-0`, `master-1`, `master-2`).
3. **NTP Time Synchronization**: Chrony or NTP must reflect the current real date/time on all nodes.

---

## End-to-End Step-by-Step Remediation Procedure

### Step 1: Verify and Resynchronize Node Clocks
If system clocks drifted into the future or reverted to BIOS defaults (e.g. year 1970/2000), certificates will be reported as invalid.

From the Helper Node, check the clock on all masters:
```bash
for node in master-0 master-1 master-2; do
  echo "=== Clock on ${node} ==="
  ssh -i ~/.ssh/id_rsa core@${node} "date && chronyc tracking"
done
```

If clocks are desynchronized, force immediate NTP stepping across all control plane nodes:
```bash
for node in master-0 master-1 master-2; do
  ssh -i ~/.ssh/id_rsa core@${node} "sudo chronyc makestep"
done
```

---

### Step 2: Establish Direct SSH to Master-0
Select the first control plane node (`master-0` or Rendezvous host) to serve as the initial recovery seed:
```bash
ssh -i ~/.ssh/id_rsa core@master-0
```

Verify the exact failure in the kubelet systemd journal:
```bash
sudo journalctl -u kubelet -n 50 --no-pager | grep -i "x509"
```
*Expected Error*: `certificate has expired or is not yet valid: current time ... is after ...`

---

### Step 3: Purge Expired Kubelet Client Credentials on Master-0
Stop the kubelet daemon to release certificate lockfiles:
```bash
sudo systemctl stop kubelet
```

Backup and remove the expired dynamic client certificates:
```bash
sudo rm -rf /var/lib/kubelet/pki/kubelet-client-current.pem
sudo rm -f /var/lib/kubelet/pki/kubelet-client-*.pem
sudo rm -f /var/lib/kubelet/kubeconfig
```

---

### Step 4: Restore Bootstrap Kubeconfig on Master-0
OpenShift retains the original cluster bootstrap credentials in `/etc/kubernetes/`. Copy the bootstrap kubeconfig back into the kubelet configuration directory:

```bash
# Check primary bootstrap location
if [ -f /etc/kubernetes/kubeconfig ]; then
  sudo cp /etc/kubernetes/kubeconfig /var/lib/kubelet/kubeconfig
elif [ -f /etc/kubernetes/bootstrap-secrets/kubeconfig ]; then
  sudo cp /etc/kubernetes/bootstrap-secrets/kubeconfig /var/lib/kubelet/kubeconfig
else
  echo "ERROR: No bootstrap kubeconfig found in /etc/kubernetes!"
  exit 1
fi

sudo chmod 0600 /var/lib/kubelet/kubeconfig
```

---

### Step 5: Start Kubelet and Generate New CSRs
Start the kubelet daemon:
```bash
sudo systemctl start kubelet
```

Kubelet will detect the absence of a valid client certificate, authenticate to the local API server using the restored bootstrap credentials, and generate a new pending Certificate Signing Request (CSR):
```bash
sudo journalctl -u kubelet -f -n 30
```
Look for: `Certificate request was submitted to the API server...`

---

### Step 6: Approve Pending CSRs from Master-0
On `master-0`, locate the local administrative kubeconfig with valid internal serving certificates:

```bash
export KUBECONFIG=/etc/kubernetes/static-pod-resources/kube-apiserver-certs/secrets/node-kubeconfigs/lb-ext.kubeconfig
```

If `lb-ext.kubeconfig` is expired, use the internal localhost administrative kubeconfig:
```bash
export KUBECONFIG=/etc/kubernetes/static-pod-resources/kube-apiserver-certs/secrets/node-kubeconfigs/localhost.kubeconfig
```

Verify that the local API server responds and check for pending CSRs:
```bash
oc get csr
```

Approve all pending client and serving CSRs:
```bash
oc get csr -ojsonpath='{range .items[?(@.status.conditions==[])]}{.metadata.name}{"
"}{end}' | while read csr; do
  echo "Approving CSR: ${csr}"
  oc adm certificate approve "${csr}"
done
```

Verify that kubelet on `master-0` has acquired a new certificate:
```bash
ls -l /var/lib/kubelet/pki/kubelet-client-current.pem
```

---

### Step 7: Cascade Remediation to Remaining Control Plane Nodes
Now that `master-0` has a healthy kubelet and the kube-apiserver is processing requests, log into `master-1` and `master-2` sequentially from the Helper Node and repeat Steps 3 through 5:

```bash
for node in master-1 master-2; do
  echo "=== Restoring Kubelet Credentials on ${node} ==="
  ssh -i ~/.ssh/id_rsa core@${node} "sudo systemctl stop kubelet &&     sudo rm -rf /var/lib/kubelet/pki/kubelet-client-current.pem &&     sudo rm -f /var/lib/kubelet/kubeconfig &&     sudo cp /etc/kubernetes/kubeconfig /var/lib/kubelet/kubeconfig &&     sudo systemctl start kubelet"
done
```

On `master-0`, continuously approve the new pending CSRs generated by `master-1` and `master-2`:
```bash
for i in {1..10}; do
  oc get csr -ojsonpath='{range .items[?(@.status.conditions==[])]}{.metadata.name}{"
"}{end}' | while read csr; do
    echo "Approving CSR: ${csr}"
    oc adm certificate approve "${csr}"
  done
  sleep 5
done
```

---

### Step 8: Cascade Remediation to Data Plane Worker & Infra Nodes
Once all 3 control plane nodes show `Ready` status (`oc get nodes`), repeat the procedure for all worker nodes:

From the Helper Node:
```bash
WORKER_NODES=$(cat /etc/hosts | grep -E "worker|infra" | awk '{print $2}')

for node in ${WORKER_NODES}; do
  echo "=== Recovering Worker Node: ${node} ==="
  ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa core@${node}     "sudo systemctl stop kubelet &&      sudo rm -rf /var/lib/kubelet/pki/kubelet-client-current.pem &&      sudo rm -f /var/lib/kubelet/kubeconfig &&      sudo cp /etc/kubernetes/kubeconfig /var/lib/kubelet/kubeconfig &&      sudo systemctl start kubelet"
done
```

On `master-0`, approve both the **Node Client** CSRs and the **Node Serving** CSRs:
```bash
# Approve initial client CSRs
oc get csr -ojsonpath='{range .items[?(@.status.conditions==[])]}{.metadata.name}{"
"}{end}' | xargs -r oc adm certificate approve

# Wait 30 seconds for nodes to generate serving CSRs, then approve again
sleep 30
oc get csr -ojsonpath='{range .items[?(@.status.conditions==[])]}{.metadata.name}{"
"}{end}' | xargs -r oc adm certificate approve
```

---

### Step 9: Reconcile Cluster Operators & MCO
With all nodes reporting `Ready`, the OpenShift operator controllers will wake up and automatically rotate any remaining internal certificates (OAuth, Ingress, Monitoring, etcd):

1. Check operator progress:
   ```bash
   oc get co
   ```
2. Wait for `kube-apiserver`, `kube-controller-manager`, `etcd`, and `machine-config` operators to report `Available=True` and `Degraded=False`.
3. Verify that MachineConfigPools reconcile:
   ```bash
   oc get mcp
   ```

---

## Automated Execution via Helper Node Script

To automate this entire 9-step recovery sequence in emergency production situations, execute the repository's dedicated automation tool from the Helper Node:

```bash
./scripts/recover-expired-certs.sh
```

This script:
1. Validates SSH keys and tests passwordless connectivity to all control plane nodes.
2. Verifies Chrony clock synchronization across the cluster.
3. Automatically purges expired kubelet client certificates and restores bootstrap kubeconfigs.
4. Starts kubelet and polls the local master admin socket to approve all pending CSRs until the API server and operators reach full health.
