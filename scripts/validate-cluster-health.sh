#!/usr/bin/env bash
# ==============================================================================
# OpenShift 4.20 Cluster Health & Post-Install Verification
# ==============================================================================
set -euo pipefail

RED='[0;31m'
GREEN='[0;32m'
YELLOW='[1;33m'
BLUE='[0;34m'
NC='[0m'

echo -e "${BLUE}======================================================================${NC}"
echo -e "${BLUE} OpenShift 4.20 Comprehensive Cluster Health Verification${NC}"
echo -e "${BLUE}======================================================================${NC}"

echo -e "
--- 1. Checking Cluster Operators ---"
unhealthy_co=$(oc get co --no-headers | awk '$3 != "True" || $4 != "False" || $5 != "False" {print $1, "Avail:"$3, "Prog:"$4, "Degr:"$5}')
if [ -z "${unhealthy_co}" ]; then
  echo -e "[${GREEN}HEALTHY${NC}] All 34+ Cluster Operators are Available=True, Progressing=False, Degraded=False."
else
  echo -e "[${RED}DEGRADED${NC}] The following Cluster Operators are in an abnormal state:"
  echo "${unhealthy_co}"
fi

echo -e "
--- 2. Checking MachineConfigPools (MCP) ---"
unhealthy_mcp=$(oc get mcp --no-headers | awk '$3 != "True" || $4 != "False" || $5 != "False" {print $1, "Updated:"$3, "Updating:"$4, "Degraded:"$5}')
if [ -z "${unhealthy_mcp}" ]; then
  echo -e "[${GREEN}HEALTHY${NC}] All MachineConfigPools are Updated=True and Degraded=False."
else
  echo -e "[${YELLOW}UPDATING/DEGRADED${NC}] MCP status issues:"
  echo "${unhealthy_mcp}"
fi

echo -e "
--- 3. Checking Nodes Status ---"
not_ready_nodes=$(oc get nodes --no-headers | awk '$2 != "Ready" {print $1, $2}')
if [ -z "${not_ready_nodes}" ]; then
  total_nodes=$(oc get nodes --no-headers | wc -l)
  echo -e "[${GREEN}HEALTHY${NC}] All ${total_nodes} nodes are in 'Ready' state."
else
  echo -e "[${RED}UNREADY${NC}] Unready nodes detected:"
  echo "${not_ready_nodes}"
fi

echo -e "
--- 4. Checking Ingress Controller & Router Pods ---"
ingress_status=$(oc get ingresscontroller default -n openshift-ingress-operator -o jsonpath='{.status.conditions[?(@.type=="Available")].status}')
if [ "${ingress_status}" == "True" ]; then
  echo -e "[${GREEN}HEALTHY${NC}] Default IngressController is Available."
else
  echo -e "[${RED}DEGRADED${NC}] Default IngressController is NOT Available!"
fi

echo -e "
--- 5. Checking StorageClasses ---"
default_sc=$(oc get sc -o jsonpath='{.items[?(@.metadata.annotations.storageclass\.kubernetes\.io/is-default-class=="true")].metadata.name}')
if [ -n "${default_sc}" ]; then
  echo -e "[${GREEN}CONFIGURED${NC}] Default StorageClass is set to: ${default_sc}"
else
  echo -e "[${YELLOW}WARNING${NC}] No default StorageClass configured! Stateful workloads may fail to dynamically provision PVCs."
fi

echo -e "
======================================================================"
echo -e " Validation Complete!"
echo -e "======================================================================"
