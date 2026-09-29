#!/usr/bin/env bash
# ==============================================================================
# OpenShift 4.20 Agent-Based Installer (ABI) ISO Generator
# ==============================================================================
set -euo pipefail

WORKDIR="${WORKDIR:-/var/tmp/ocp-agent-build}"
CONFIG_SRC_DIR="${CONFIG_SRC_DIR:-configs/agent-based}"
TOPOLOGY="${TOPOLOGY:-compact}" # sno, compact, or standard

echo "=== Generating OpenShift 4.20 Agent-Based Installation ISO ==="
echo "Topology: ${TOPOLOGY}"
echo "Working Directory: ${WORKDIR}"

if ! command -v openshift-install &>/dev/null; then
  echo "[ERROR] openshift-install binary not found in PATH!" >&2
  exit 1
fi

rm -rf "${WORKDIR}"
mkdir -p "${WORKDIR}"

echo "[1/4] Copying install-config.yaml and agent-config.yaml..."
cp "${CONFIG_SRC_DIR}/install-config-${TOPOLOGY}.yaml" "${WORKDIR}/install-config.yaml"
cp "${CONFIG_SRC_DIR}/agent-config.yaml" "${WORKDIR}/agent-config.yaml"

echo "[2/4] Validating configurations..."
# Ensure pullSecret is populated
if grep -q 'YOUR_PULL_SECRET_HERE' "${WORKDIR}/install-config.yaml"; then
  echo "[ERROR] Please update install-config.yaml with a valid Red Hat pull secret!" >&2
  exit 1
fi

echo "[3/4] Running Agent-Based image creation..."
openshift-install agent create image --dir="${WORKDIR}" --log-level=info

echo "[4/4] Agent ISO Generation Complete!"
ls -lh "${WORKDIR}"/agent.*.iso
echo "Sha256 Checksum:"
sha256sum "${WORKDIR}"/agent.*.iso
echo ""
echo "Mount this ISO via Redfish/Virtual Media or burn to USB to boot all cluster nodes."
echo "Monitor installation with:"
echo "  openshift-install agent wait-for install-complete --dir=${WORKDIR}"
