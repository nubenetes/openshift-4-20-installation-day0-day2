# Enterprise Observability Stack

OpenShift 4.20 provides a unified observability plane incorporating metrics, distributed tracing, and centralized logging.

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Enable User Workload Monitoring (UWM)
1. Edit the cluster monitoring ConfigMap in `openshift-monitoring`:
   ```bash
   oc apply -f - << 'EOF'
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: cluster-monitoring-config
     namespace: openshift-monitoring
   data:
     config.yaml: |
       enableUserWorkload: true
   EOF
   ```
2. Confirm user workload Prometheus instances spin up in `openshift-user-workload-monitoring`:
   ```bash
   oc get pods -n openshift-user-workload-monitoring
   ```

### Step 2: Deploy OpenShift Logging Operator & LokiStack
1. Install **Red Hat OpenShift Logging** and **Loki Operator** from OperatorHub.
2. Create an S3 / ODF object bucket for log retention.
3. Deploy the `LokiStack` CR:
   ```yaml
   apiVersion: loki.grafana.com/v1
   kind: LokiStack
   metadata:
     name: logging-loki
     namespace: openshift-logging
   spec:
     size: 1x.small
     storage:
       schemas:
         - version: v13
           effectiveDate: "2026-09-01"
       secret:
         name: logging-loki-s3
         type: s3
     storageClassName: ocs-storagecluster-ceph-rbd
     tenants:
       mode: openshift-logging
   ```

### Step 3: Configure ClusterLogForwarder
1. Deploy `ClusterLogging` and forward logs to LokiStack via Vector:
   ```yaml
   apiVersion: logging.openshift.io/v1
   kind: ClusterLogging
   metadata:
     name: instance
     namespace: openshift-logging
   spec:
     managementState: Managed
     logStore:
       type: lokistack
       lokistack:
         name: logging-loki
     collection:
       type: vector
   ```

### Step 4: Deploy Red Hat OpenTelemetry & Tempo Tracing
1. Subscribe to the **Red Hat build of OpenTelemetry** and **Tempo Operator**.
2. Deploy a `TempoStack` instance and auto-inject sidecars to microservices by annotating deployments with `sidecar.opentelemetry.io/inject: "true"`.

---
[Next: Security & Compliance](02-security-and-compliance.md) • [Back to Day 2 Index](README.md)
