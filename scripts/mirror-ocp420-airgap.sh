#!/usr/bin/env bash
# ==============================================================================
# OpenShift 4.20 Air-Gapped Mirroring Automation (oc-mirror v2)
# ==============================================================================
set -euo pipefail

OCP_VERSION="${OCP_VERSION:-4.20.0}"
CONFIG_FILE="${CONFIG_FILE:-configs/airgap/imageset-config-v2.yaml}"
DESTINATION_REGISTRY="${DESTINATION_REGISTRY:-quay.internal.corp:8443/openshift4}"
CACHE_DIR="${CACHE_DIR:-/var/tmp/oc-mirror-cache}"
OUTPUT_DIR="${OUTPUT_DIR:-/var/tmp/oc-mirror-workspace}"

echo "=== OpenShift 4.20 Disconnected Mirroring with oc-mirror v2 ==="
echo "Release Target: ${OCP_VERSION}"
echo "Config:         ${CONFIG_FILE}"
echo "Destination:    ${DESTINATION_REGISTRY}"

if ! command -v oc-mirror &>/dev/null; then
  echo "[ERROR] oc-mirror plugin not found! Please install the oc-mirror CLI plugin for OCP 4.20." >&2
  exit 1
fi

mkdir -p "${CACHE_DIR}" "${OUTPUT_DIR}"

echo "[1/3] Validating ImageSetConfiguration..."
if [ ! -f "${CONFIG_FILE}" ]; then
  echo "[ERROR] Config file ${CONFIG_FILE} does not exist!" >&2
  exit 1
fi

echo "[2/3] Executing oc-mirror v2 mirror-to-mirror workflow..."
oc-mirror --config "${CONFIG_FILE}"           docker://"${DESTINATION_REGISTRY}"           --v2           --cache-dir "${CACHE_DIR}"           --workspace file://"${OUTPUT_DIR}"

echo "[3/3] Mirror completed successfully!"
echo "Cluster manifests (IDMS, ITMS, CatalogSources) generated in: ${OUTPUT_DIR}"
echo "Apply manifests to your disconnected cluster with:"
echo "  oc apply -f ${OUTPUT_DIR}/results-*/"
