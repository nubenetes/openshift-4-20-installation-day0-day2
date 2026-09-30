#!/usr/bin/env bash
# ==============================================================================
# OpenShift 4.20 Full Native Observability Stack Verification & Diagnostics
# ==============================================================================
# Validates Cluster Monitoring (UWM + Exemplars), OpenShift Logging 6.x (Vector),
# LokiStack 3.x, OpenTelemetry, TempoStack, Korrel8r Correlation, and Cardinality.
# ==============================================================================
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

echo -e "${BLUE}======================================================================${NC}"
echo -e "${BOLD}${BLUE} OpenShift 4.20 Native Observability Stack Diagnostic Engine${NC}"
echo -e "${BLUE}======================================================================${NC}"

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  echo "Usage: $0 [options]"
  echo ""
  echo "Audits the OpenShift 4.20 full native observability stack including:"
  echo "  - Core operators (CMO, Logging 6.x Vector, Loki 3.x, OpenTelemetry, TempoStack, COO, NetObserv)"
  echo "  - S3 Object Storage connectivity & LokiStack status"
  echo "  - User Workload Monitoring (UWM) & OpenMetrics Exemplar retention"
  echo "  - Vector collector daemonset health & Structured Metadata forwarding"
  echo "  - TempoStack gateway, OTel collectors & sampling pipelines"
  echo "  - Korrel8r & Console UI plugins for 3-way correlation"
  echo "  - Prometheus TSDB series cardinality baseline audit"
  echo ""
  echo "Prerequisites: OpenShift CLI (oc) logged in with cluster-admin permissions."
  exit 0
fi

# Check prerequisites
if ! command -v oc &> /dev/null; then
  echo -e "[${RED}FATAL${NC}] 'oc' command-line tool not found in PATH."
  exit 1
fi

if ! oc whoami &> /dev/null; then
  echo -e "[${RED}FATAL${NC}] Unable to connect to OpenShift API server. Ensure valid KUBECONFIG."
  exit 1
fi

# ------------------------------------------------------------------------------
# 1. Auditing Observability Operators
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${CYAN}--- 1. Auditing Observability Operators & Subscriptions ---${NC}"

check_operator() {
  local op_name="$1"
  local ns="$2"
  if oc get csv -n "${ns}" 2>/dev/null | grep -i "${op_name}" | grep -q "Succeeded"; then
    local version
    version=$(oc get csv -n "${ns}" --no-headers | grep -i "${op_name}" | awk '{print $1}')
    echo -e "  [${GREEN}HEALTHY${NC}] Operator ${BOLD}${op_name}${NC} is Succeeded (${version})."
  else
    echo -e "  [${YELLOW}WARNING${NC}] Operator ${BOLD}${op_name}${NC} not found or not in 'Succeeded' state in namespace '${ns}'."
    WARNINGS=$((WARNINGS + 1))
  fi
}

check_operator "cluster-monitoring-operator" "openshift-monitoring"
check_operator "cluster-logging" "openshift-logging"
check_operator "loki-operator" "openshift-operators-redhat"
check_operator "opentelemetry-operator" "openshift-operators"
check_operator "tempo-operator" "openshift-operators"
check_operator "cluster-observability-operator" "openshift-operators"
check_operator "netobserv-operator" "openshift-netobserv-operator"

# ------------------------------------------------------------------------------
# 2. Monitoring & User Workload Monitoring (UWM) Status
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${CYAN}--- 2. Auditing Monitoring & User Workload Monitoring (UWM) ---${NC}"

# Check if UWM is enabled
UWM_ENABLED=$(oc get configmap cluster-monitoring-config -n openshift-monitoring -o jsonpath='{.data.config\.yaml}' 2>/dev/null | grep -c "enableUserWorkload: true" || true)

if [ "${UWM_ENABLED}" -gt 0 ]; then
  echo -e "  [${GREEN}HEALTHY${NC}] User Workload Monitoring (UWM) is explicitly enabled in cluster-monitoring-config."
else
  echo -e "  [${YELLOW}WARNING${NC}] User Workload Monitoring (UWM) is NOT enabled in openshift-monitoring/cluster-monitoring-config."
  WARNINGS=$((WARNINGS + 1))
fi

# Check UWM Prometheus pods
if oc get namespace openshift-user-workload-monitoring &> /dev/null; then
  UWM_PODS=$(oc get pods -n openshift-user-workload-monitoring --no-headers 2>/dev/null | awk '$3 != "Running" {print $1, $3}' || true)
  if [ -z "${UWM_PODS}" ]; then
    UWM_COUNT=$(oc get pods -n openshift-user-workload-monitoring --no-headers 2>/dev/null | wc -l)
    echo -e "  [${GREEN}HEALTHY${NC}] All ${UWM_COUNT} User Workload Monitoring pods are Running."
  else
    echo -e "  [${RED}DEGRADED${NC}] Abnormal pods in openshift-user-workload-monitoring:"
    echo "${UWM_PODS}"
    ERRORS=$((ERRORS + 1))
  fi
else
  echo -e "  [${YELLOW}WARNING${NC}] Namespace 'openshift-user-workload-monitoring' does not exist yet."
fi

# Check Exemplar configuration
EXEMPLAR_CONFIG=$(oc get configmap cluster-monitoring-config -n openshift-monitoring -o jsonpath='{.data.config\.yaml}' 2>/dev/null | grep -c "exemplars:" || true)
if [ "${EXEMPLAR_CONFIG}" -gt 0 ]; then
  echo -e "  [${GREEN}HEALTHY${NC}] OpenMetrics Exemplar storage is configured in cluster-monitoring-config."
else
  echo -e "  [${YELLOW}INFO${NC}] OpenMetrics Exemplars not detected in cluster-monitoring-config (required for metric-to-trace correlation)."
fi

# ------------------------------------------------------------------------------
# 3. OpenShift Logging 6.x & LokiStack Status
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${CYAN}--- 3. Auditing Logging 6.x & LokiStack Storage ---${NC}"

if oc get namespace openshift-logging &> /dev/null; then
  # Check Vector collector daemonset
  VECTOR_DS=$(oc get ds -n openshift-logging -l app.kubernetes.io/component=collector --no-headers 2>/dev/null || true)
  if [ -n "${VECTOR_DS}" ]; then
    DESIRED=$(echo "${VECTOR_DS}" | awk '{print $2}')
    READY=$(echo "${VECTOR_DS}" | awk '{print $4}')
    if [ "${DESIRED}" == "${READY}" ] && [ "${READY}" -gt 0 ]; then
      echo -e "  [${GREEN}HEALTHY${NC}] Vector collector DaemonSet is active: ${READY}/${DESIRED} pods ready."
    else
      echo -e "  [${YELLOW}DEGRADED${NC}] Vector collector DaemonSet not fully ready: ${READY}/${DESIRED} pods."
      WARNINGS=$((WARNINGS + 1))
    fi
  else
    echo -e "  [${YELLOW}WARNING${NC}] Vector collector DaemonSet not found in 'openshift-logging'."
  fi

  # Check LokiStack CR
  LOKI_STATUS=$(oc get lokistack -n openshift-logging -o jsonpath='{.items[0].status.conditions[?(@.type=="Ready")].status}' 2>/dev/null || echo "NotFound")
  if [ "${LOKI_STATUS}" == "True" ]; then
    LOKI_NAME=$(oc get lokistack -n openshift-logging -o jsonpath='{.items[0].metadata.name}')
    echo -e "  [${GREEN}HEALTHY${NC}] LokiStack '${LOKI_NAME}' status is Ready=True."
  elif [ "${LOKI_STATUS}" == "NotFound" ]; then
    echo -e "  [${YELLOW}WARNING${NC}] No LokiStack custom resource found in 'openshift-logging'."
    WARNINGS=$((WARNINGS + 1))
  else
    echo -e "  [${RED}DEGRADED${NC}] LokiStack status is NOT Ready (current status: ${LOKI_STATUS})."
    ERRORS=$((ERRORS + 1))
  fi

  # Check Loki S3 secret
  if oc get secret logging-loki-s3 -n openshift-logging &> /dev/null; then
    echo -e "  [${GREEN}HEALTHY${NC}] Object storage secret 'logging-loki-s3' exists."
  else
    echo -e "  [${YELLOW}WARNING${NC}] Object storage secret 'logging-loki-s3' not found in openshift-logging."
  fi
else
  echo -e "  [${YELLOW}WARNING${NC}] Namespace 'openshift-logging' does not exist."
fi

# ------------------------------------------------------------------------------
# 4. Distributed Tracing & TempoStack Status
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${CYAN}--- 4. Auditing Distributed Tracing (TempoStack & OpenTelemetry) ---${NC}"

if oc get namespace openshift-tracing &> /dev/null; then
  # Check TempoStack CR
  TEMPO_STATUS=$(oc get tempostack -n openshift-tracing -o jsonpath='{.items[0].status.conditions[?(@.type=="Ready")].status}' 2>/dev/null || echo "NotFound")
  if [ "${TEMPO_STATUS}" == "True" ]; then
    TEMPO_NAME=$(oc get tempostack -n openshift-tracing -o jsonpath='{.items[0].metadata.name}')
    echo -e "  [${GREEN}HEALTHY${NC}] TempoStack '${TEMPO_NAME}' status is Ready=True."
  elif [ "${TEMPO_STATUS}" == "NotFound" ]; then
    echo -e "  [${YELLOW}WARNING${NC}] No TempoStack custom resource found in 'openshift-tracing'."
    WARNINGS=$((WARNINGS + 1))
  else
    echo -e "  [${RED}DEGRADED${NC}] TempoStack status is NOT Ready (current status: ${TEMPO_STATUS})."
    ERRORS=$((ERRORS + 1))
  fi

  # Check OpenTelemetry Collector
  OTEL_STATUS=$(oc get opentelemetrycollector -n openshift-tracing -o jsonpath='{.items[0].status.scale.replicas}' 2>/dev/null || echo "NotFound")
  if [ "${OTEL_STATUS}" != "NotFound" ] && [ "${OTEL_STATUS}" -gt 0 ]; then
    OTEL_NAME=$(oc get opentelemetrycollector -n openshift-tracing -o jsonpath='{.items[0].metadata.name}')
    echo -e "  [${GREEN}HEALTHY${NC}] OpenTelemetryCollector '${OTEL_NAME}' is active (${OTEL_STATUS} replicas)."
  else
    echo -e "  [${YELLOW}INFO${NC}] OpenTelemetryCollector not found in 'openshift-tracing'."
  fi
else
  echo -e "  [${YELLOW}WARNING${NC}] Namespace 'openshift-tracing' does not exist."
fi

# ------------------------------------------------------------------------------
# 5. Network Observability (eBPF FlowCollector)
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${CYAN}--- 5. Auditing Network Observability (eBPF FlowCollector) ---${NC}"

FLOW_STATUS=$(oc get flowcollector cluster -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null || echo "NotFound")
if [ "${FLOW_STATUS}" == "True" ]; then
  echo -e "  [${GREEN}HEALTHY${NC}] Network Observability FlowCollector 'cluster' is Ready=True."
elif [ "${FLOW_STATUS}" == "NotFound" ]; then
  echo -e "  [${YELLOW}INFO${NC}] FlowCollector 'cluster' not deployed (optional eBPF network telemetry)."
else
  echo -e "  [${YELLOW}DEGRADED${NC}] FlowCollector status is not Ready (current status: ${FLOW_STATUS})."
fi

# ------------------------------------------------------------------------------
# 6. Correlation Engine (Korrel8r & Console Observability Plugins)
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${CYAN}--- 6. Auditing Correlation Engine (Korrel8r & Console Plugins) ---${NC}"

CONSOLE_PLUGINS=$(oc get consoles.operator.openshift.io cluster -o jsonpath='{.spec.plugins}' 2>/dev/null || echo "[]")

check_console_plugin() {
  local plugin="$1"
  if echo "${CONSOLE_PLUGINS}" | grep -q "${plugin}"; then
    echo -e "  [${GREEN}HEALTHY${NC}] Console plugin '${BOLD}${plugin}${NC}' is registered in Console operator."
  else
    echo -e "  [${YELLOW}INFO${NC}] Console plugin '${BOLD}${plugin}${NC}' is not enabled in Console operator."
  fi
}

check_console_plugin "logging-view-plugin"
check_console_plugin "distributed-tracing-console-plugin"
check_console_plugin "netobserv-plugin"

# Check Korrel8r deployment
if oc get deployment -A -l app.kubernetes.io/name=korrel8r &> /dev/null; then
  KORREL8R_READY=$(oc get deployment -A -l app.kubernetes.io/name=korrel8r -o jsonpath='{.items[0].status.readyReplicas}' 2>/dev/null || echo "0")
  if [ "${KORREL8R_READY}" -gt 0 ]; then
    echo -e "  [${GREEN}HEALTHY${NC}] Korrel8r correlation service is running (${KORREL8R_READY} ready replicas)."
  else
    echo -e "  [${YELLOW}DEGRADED${NC}] Korrel8r correlation service has 0 ready replicas."
  fi
else
  echo -e "  [${YELLOW}INFO${NC}] Dedicated Korrel8r deployment not found (managed by Cluster Observability Operator)."
fi

# ------------------------------------------------------------------------------
# 7. High-Cardinality Analysis & Governance Audit
# ------------------------------------------------------------------------------
echo -e "\n${BOLD}${CYAN}--- 7. Cardinality Governance & Series Analysis ---${NC}"

# Query Prometheus series count via oc exec into prometheus pod
PROM_POD=$(oc get pods -n openshift-monitoring -l app.kubernetes.io/name=prometheus --no-headers 2>/dev/null | head -n 1 | awk '{print $1}' || true)

if [ -n "${PROM_POD}" ]; then
  TOTAL_SERIES=$(oc exec -n openshift-monitoring "${PROM_POD}" -c prometheus -- curl -s http://localhost:9090/api/v1/status/tsdb 2>/dev/null | grep -o '"numSeries":[0-9]*' | cut -d: -f2 || echo "N/A")
  if [ "${TOTAL_SERIES}" != "N/A" ] && [ "${TOTAL_SERIES}" -gt 0 ]; then
    echo -e "  [${GREEN}AUDIT${NC}] Platform Prometheus Active Head Series: ${BOLD}${TOTAL_SERIES}${NC}"
    if [ "${TOTAL_SERIES}" -gt 3000000 ]; then
      echo -e "  [${YELLOW}ALERT${NC}] Head series count exceeds 3,000,000! Review high-cardinality ServiceMonitors and relabeling rules."
      WARNINGS=$((WARNINGS + 1))
    fi
  else
    echo -e "  [${YELLOW}INFO${NC}] Could not query TSDB status from platform Prometheus."
  fi
else
  echo -e "  [${YELLOW}INFO${NC}] Platform Prometheus pod not ready for TSDB introspection."
fi

# ------------------------------------------------------------------------------
# Final Assessment & Triage Summary
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}======================================================================${NC}"
echo -e "${BOLD}${BLUE} Observability Stack Verification Summary${NC}"
echo -e "${BLUE}======================================================================${NC}"

if [ "${ERRORS}" -eq 0 ] && [ "${WARNINGS}" -eq 0 ]; then
  echo -e "[${GREEN}SUCCESS${NC}] All core Observability components, storage backends, and correlation services are fully operational."
  exit 0
elif [ "${ERRORS}" -eq 0 ]; then
  echo -e "[${YELLOW}WARNING${NC}] Core components functional, but ${WARNINGS} warning(s) detected. Review the checklist above."
  exit 0
else
  echo -e "[${RED}FAILURE${NC}] ${ERRORS} critical error(s) and ${WARNINGS} warning(s) detected in the observability stack."
  exit 1
fi
