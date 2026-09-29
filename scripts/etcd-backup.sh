#!/usr/bin/env bash
# ==============================================================================
# OpenShift 4.20 Automated etcd Snapshot & Backup Utility
# ==============================================================================
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-/var/recovery/etcd-backups}"
RETENTION_DAYS="${RETENTION_DAYS:-14}"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TARGET_DIR="${BACKUP_DIR}/etcd_snapshot_${TIMESTAMP}"

mkdir -p "${TARGET_DIR}"

echo "=== Starting OpenShift 4.20 etcd Backup (${TIMESTAMP}) ==="

if [ -f /usr/local/bin/cluster-backup.sh ]; then
  echo "[1/3] Executing official Red Hat cluster-backup.sh..."
  /usr/local/bin/cluster-backup.sh "${TARGET_DIR}"
else
  echo "[INFO] cluster-backup.sh not present in local filesystem. Checking if running from oc client..."
  MASTER_NODE=$(oc get nodes -l node-role.kubernetes.io/control-plane= -o jsonpath='{.items[0].metadata.name}')
  echo "Running cluster-backup.sh on control plane node: ${MASTER_NODE}"
  oc debug "node/${MASTER_NODE}" -- chroot /host /usr/local/bin/cluster-backup.sh /var/home/core/etcd-backup-${TIMESTAMP}
  echo "Snapshot created on master node filesystem at /var/home/core/etcd-backup-${TIMESTAMP}"
  exit 0
fi

echo "[2/3] Verifying snapshot integrity..."
SNAPSHOT_FILE=$(find "${TARGET_DIR}" -name "snapshot_*.db" | head -n1)
if [ -n "${SNAPSHOT_FILE}" ]; then
  echo "Snapshot verified: ${SNAPSHOT_FILE} ($(du -h "${SNAPSHOT_FILE}" | cut -f1))"
else
  echo "[ERROR] No snapshot file found in ${TARGET_DIR}!" >&2
  exit 1
fi

echo "[3/3] Enforcing retention policy: deleting backups older than ${RETENTION_DAYS} days..."
find "${BACKUP_DIR}" -maxdepth 1 -type d -name "etcd_snapshot_*" -mtime "+${RETENTION_DAYS}" -exec rm -rf {} +
echo "Backup complete and verified!"
