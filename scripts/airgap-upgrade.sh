#!/usr/bin/env bash
# ==============================================================================
# OpenShift 4.20 Air-Gapped / Disconnected Upgrade Automation
# Mirrors release payload -> updates IDMS & release signatures -> triggers upgrade
# ==============================================================================
set -euo pipefail

TARGET_VERSION="${1:-4.20.1}"
LOCAL_REGISTRY="${LOCAL_REGISTRY:-quay.internal.corp:8443/openshift4}"
WORKDIR="${WORKDIR:-/var/tmp/ocp-airgap-upgrade}"

echo "=== OpenShift 4.20 Air-Gapped Upgrade Orchestrator ==="
echo "Target Version: ${TARGET_VERSION}"
echo "Local Registry: ${LOCAL_REGISTRY}"

mkdir -p "${WORKDIR}"

# 1. Generate ImageSetConfiguration for target release
printf 'apiVersion: mirror.openshift.io/v2alpha1\nkind: ImageSetConfiguration\nstorageConfig:\n  local:\n    path: %s/cache\nmirror:\n  platform:\n    channels:\n      - name: stable-4.20\n        minVersion: %s\n        maxVersion: %s\n        type: ocp\n    graph: true\n' "${WORKDIR}" "${TARGET_VERSION}" "${TARGET_VERSION}" > "${WORKDIR}/imageset-upgrade.yaml"

echo "[1/4] Mirroring OCP ${TARGET_VERSION} payload to ${LOCAL_REGISTRY} via oc-mirror v2..."
oc-mirror --config "${WORKDIR}/imageset-upgrade.yaml" \
          docker://${LOCAL_REGISTRY} \
          --v2 \
          --workspace file://${WORKDIR}/workspace

echo "[2/4] Applying updated ImageDigestMirrorSet (IDMS)..."
oc apply -f ${WORKDIR}/workspace/results-*/

echo "[3/4] Triggering cluster upgrade via local release image..."
RELEASE_DIGEST=$(oc adm release info --image-for=release docker://${LOCAL_REGISTRY}/openshift/release-images:${TARGET_VERSION}-x86_64)
oc adm upgrade --to-image="${RELEASE_DIGEST}" --allow-upgrade-to-unknown-version=true

echo "[4/4] Air-gapped upgrade initiated! Monitor status with:"
echo "  oc get clusterversion"
