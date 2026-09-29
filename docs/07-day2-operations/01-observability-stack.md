# Enterprise Observability Stack

OpenShift 4.20 provides a unified observability plane incorporating metrics, distributed tracing, and centralized logging.

---

## 1. User Workload Monitoring (UWM)
Cluster monitoring monitors core OpenShift components by default. Enable User Workload Monitoring to scrape application metrics:

```yaml
# In openshift-monitoring/cluster-monitoring-config ConfigMap
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-monitoring-config
  namespace: openshift-monitoring
data:
  config.yaml: |
    enableUserWorkload: true
```

---

## 2. Distributed Tracing & OpenTelemetry (Tempo & OTel)
- Deploy Red Hat OpenShift distributed tracing platform based on **Grafana Tempo**.
- Deploy Red Hat build of OpenTelemetry to instrument microservices without modifying application code via auto-instrumentation injection.

---

## 3. High-Density Logging (LokiStack & Vector)
- OpenShift Logging 5.x/6.x utilizes **Vector** as the high-throughput collector and **LokiStack** for multi-tenant log aggregation backed by S3/ODF object storage.

---
[Next: Security & Compliance](02-security-and-compliance.md) • [Back to Day 2 Index](README.md)
