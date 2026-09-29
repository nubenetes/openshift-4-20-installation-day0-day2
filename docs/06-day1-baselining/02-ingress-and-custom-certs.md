# Ingress Controller & Custom Wildcard Certificates

By default, OpenShift issues a self-signed ingress certificate (`*.apps.<cluster>.<baseDomain>`). This triggers browser security warnings and breaks automated API clients.

In OpenShift 4.20, platform teams can baseline ingress using two complementary architectural patterns:
1. **Classic IngressController**: Replacing the default HAProxy router certificate cluster-wide.
2. **Kubernetes Gateway API Standard (`gateway.networking.k8s.io`)**: Deploying an enterprise `Gateway` with automated TLS certificate rotation via **cert-manager** to support modern L7 routing, gRPC, and canary releases.

---

## End-to-End Step-by-Step Implementation Procedure

### Step 1: Obtain Enterprise Wildcard TLS Certificate
1. Generate a certificate signing request (CSR) for `*.apps.<cluster>.<baseDomain>`.
2. Have your enterprise internal PKI sign the CSR.
3. Bundle the certificate, intermediate CAs, and root CA in order:
   ```bash
   cat server.crt intermediate.crt root.crt > fullchain.pem
   ```

### Step 2: Create Ingress TLS Secret
1. Create a Kubernetes TLS secret in namespace `openshift-ingress`:
   ```bash
   oc create secret tls wildcard-apps-tls-cert      --cert=fullchain.pem      --key=privkey.key      -n openshift-ingress
   ```

### Step 3: Patch IngressController Custom Resource
1. Update the default IngressController to consume the new wildcard secret:
   ```bash
   oc patch ingresscontroller.operator default      --type=merge -p      '{"spec":{"defaultCertificate":{"name":"wildcard-apps-tls-cert"}}}'      -n openshift-ingress-operator
   ```

### Step 4: Monitor Ingress Router Pod Rolling Restart
1. Monitor the rolling update of HAProxy router pods in `openshift-ingress`:
   ```bash
   oc rollout status deployment/router-default -n openshift-ingress
   ```

### Step 5: Verify TLS Handshake & Expiry
1. Verify the certificate using `openssl`:
   ```bash
   echo | openssl s_client -connect console-openshift-console.apps.ocp420.corp.local:443      -servername console-openshift-console.apps.ocp420.corp.local 2>/dev/null | openssl x509 -noout -issuer -subject -dates
   ```
2. Confirm the issuer reflects your corporate CA and not `openshift-ingress`.

---

### Step 6: Modern Ingress Architecture: Transitioning to Kubernetes Gateway API

For advanced traffic management (canary weighted splits, gRPC AI streaming, and zero-trust policy attachment), deploy the enterprise **Gateway API** standard alongside classic Ingress:

1. Deploy the shared `GatewayClass` and `Gateway` resource with cert-manager automated TLS rotation:
   ```bash
   oc apply -f configs/gateway-api/gatewayclass-openshift.yaml
   oc apply -f configs/gateway-api/enterprise-gateway.yaml
   ```
2. Application developers can now attach declarative `HTTPRoute`, `GRPCRoute`, and `TLSRoute` resources without requiring cluster-admin privileges:
   ```bash
   oc apply -f configs/gateway-api/httproute-canary-split.yaml
   ```
3. For exhaustive details, reference the dedicated architecture guide: [`docs/03-network-and-connectivity/05-gateway-api-architecture.md`](../03-network-and-connectivity/05-gateway-api-architecture.md).

---
[Next: Identity Providers & RBAC](03-identity-providers-rbac.md) • [Back to Day 1 Index](README.md)
