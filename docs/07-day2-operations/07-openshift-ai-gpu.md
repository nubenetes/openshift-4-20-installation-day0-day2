# 07 - Red Hat OpenShift AI (RHOAI) & Accelerated GPU Computing

Generative AI, Large Language Model (LLM) fine-tuning, and high-throughput inference require specialized hardware acceleration, kernel-level NUMA alignment, and dedicated model-serving infrastructure. This guide covers the end-to-end architecture for **NVIDIA GPU acceleration** and **Red Hat OpenShift AI (RHOAI 2.16+)** on OpenShift 4.20.

---

## Architecture Overview

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                        OPENSHIFT AI (RHOAI) & ACCELERATION STACK                       │
└────────────────────────────────────────────────────────────────────────────────────────┘

    ┌────────────────────────────────────────────────────────────────────────────┐
    │                      APPLICATIONS & INFERENCE RUNTIMES                     │
    │        • KServe / vLLM (OpenAI-compatible endpoints)                       │
    │        • Distributed PyTorch / Ray Cluster Training                        │
    └─────────────────────────────────────┬──────────────────────────────────────┘
                                          │
                                          ▼
    ┌────────────────────────────────────────────────────────────────────────────┐
    │                  RED HAT OPENSHIFT AI (RHOAI 2.16+)                        │
    │        • DataScienceCluster CR (KServe, Ray, Pipelines, Dashboard)         │
    │        • Kueue Gang-Scheduling & Quota Management                          │
    └─────────────────────────────────────┬──────────────────────────────────────┘
                                          │
                                          ▼
    ┌────────────────────────────────────────────────────────────────────────────┐
    │                     NVIDIA GPU OPERATOR (v24.9+)                           │
    │        • Automated Open Kernel Module Driver Compilation                   │
    │        • NVIDIA Container Toolkit & CUDA Runtime Injection                 │
    │        • Data Center GPU Manager (DCGM) & Prometheus Metrics               │
    │        • Multi-Instance GPU (MIG) & Time-Slicing Device Plugins            │
    └─────────────────────────────────────┬──────────────────────────────────────┘
                                          │
                                          ▼
    ┌────────────────────────────────────────────────────────────────────────────┐
    │                     PHYSICAL INFRASTRUCTURE (DAY 0)                        │
    │   • NVIDIA H100 / H200 / L40S PCIe / SXM GPUs                              │
    │   • 1GB HugePages (`default_hugepagesz=1G`) & NUMA Pinning                 │
    │   • 100/200/400GbE RoCE v2 / InfiniBand Fabrics (MTU 9000 Jumbo Frames)    │
    └────────────────────────────────────────────────────────────────────────────┘
```

---

## 1. Day 0 Hardware & Node Tuning Pre-requisites

For physical bare-metal GPU worker nodes, low-latency AI performance requires specific kernel tuning applied via a dedicated `MachineConfig`:

```yaml
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  labels:
    machineconfiguration.openshift.io/role: worker-gpu
  name: 99-worker-gpu-tuning
spec:
  config:
    ignition:
      version: 3.4.0
  kernelArguments:
    - "intel_iommu=on"
    - "iommu=pt"
    - "default_hugepagesz=1G"
    - "hugepagesz=1G"
    - "hugepages=32"
```

---

## 2. NVIDIA GPU Operator Deployment

The NVIDIA GPU Operator automates the management of all software components needed to provision GPUs:

1. **Subscribe to GPU Operator**:
   Apply [`configs/ai/gpu-operator-clusterpolicy.yaml`](../../configs/ai/gpu-operator-clusterpolicy.yaml).

2. **ClusterPolicy Configuration**:
   The `ClusterPolicy` custom resource configures the entire GPU lifecycle:
   - Automated driver container deployment (`useOpenKernelModules: true`).
   - DCGM Exporter delivering GPU utilization, memory bandwidth, and temperature metrics to OpenShift User Workload Monitoring.
   - MIG (Multi-Instance GPU) mode for partitioning a physical H100/A100 into up to 7 isolated GPU hardware instances.

---

## 3. Red Hat OpenShift AI (RHOAI) Stack Activation

1. **Deploy DataScienceCluster Custom Resource**:
   Apply [`configs/ai/rhoai-datasciencecluster.yaml`](../../configs/ai/rhoai-datasciencecluster.yaml).

2. **Core Components Enabled**:
   - **KServe**: Cloud-native model serving with auto-scaling down to zero and GPU acceleration.
   - **Kueue**: Multi-tenant gang-scheduling and fair-sharing for GPU training jobs.
   - **Ray**: Distributed compute framework for scaling Python and AI workloads.

---

## 4. Deploying Local High-Throughput LLM Inference (vLLM)

vLLM provides state-of-the-art LLM serving throughput via **PagedAttention**:

1. **Deploy vLLM ServingRuntime**:
   Apply [`configs/ai/vllm-serving-runtime.yaml`](../../configs/ai/vllm-serving-runtime.yaml).

2. **Instantiate Inference Service (`InferenceService`)**:
   ```yaml
   apiVersion: serving.kserve.io/v1beta1
   kind: InferenceService
   metadata:
     name: deepseek-coder-llm
     namespace: production-ai
   spec:
     predictor:
       model:
         modelFormat:
           name: pytorch
         storageUri: "pvc://model-storage-pvc/deepseek-coder-33b"
         runtime: vllm-runtime
         resources:
           limits:
             nvidia.com/gpu: "2"
   ```

3. **Query OpenAI-Compatible REST API**:
   ```bash
   curl -k https://deepseek-coder-llm-production-ai.apps.ocp-prod.corp.local/v1/chat/completions \
     -H "Content-Type: application/json" \
     -d '{
       "model": "deepseek-coder-33b",
       "messages": [{"role": "user", "content": "Write a Kubernetes NetworkPolicy for OpenShift"}]
     }'
   ```

---

## Verification & Monitoring Commands

```bash
# Check GPU node detection and allocatable resources
oc describe node -l feature.node.kubernetes.io/pci-10de.present=true | grep "nvidia.com/gpu"

# Verify NVIDIA DCGM Prometheus metrics
oc exec -n openshift-monitoring -c prometheus prometheus-k8s-0 -- curl -s 'http://localhost:9090/api/v1/query?query=DCGM_FI_DEV_GPU_UTIL'

# Inspect RHOAI DataScienceCluster health
oc get datasciencecluster default-dsc -o jsonpath='{.status.conditions[*].message}'
```

---
[Back to Day 2 Operations Index](README.md) • [Next: Disaster Recovery & Backup](../08-backup-dr-and-rebuild/README.md)
