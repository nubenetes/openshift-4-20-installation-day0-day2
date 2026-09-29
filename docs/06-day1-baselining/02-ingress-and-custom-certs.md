# Ingress Controller & Custom Wildcard Certificates

By default, OpenShift issues a self-signed ingress certificate (`*.apps.<cluster>.<baseDomain>`). This triggers browser security warnings and breaks automated API clients.

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
   oc create secret tls wildcard-apps-tls-cert       --cert=fullchain.pem       --key=privkey.key       -n openshift-ingress
   ```

### Step 3: Patch IngressController Custom Resource
1. Update the default IngressController to consume the new wildcard secret:
   ```bash
   oc patch ingresscontroller.operator default       --type=merge -p       '{"spec":{"defaultCertificate":{"name":"wildcard-apps-tls-cert"}}}'       -n openshift-ingress-operator
   ```

### Step 4: Monitor Ingress Router Pod Rolling Restart
1. Monitor the rolling update of HAProxy router pods in `openshift-ingress`:
   ```bash
   oc rollout status deployment/router-default -n openshift-ingress
   ```

### Step 5: Verify TLS Handshake & Expiry
1. Verify the certificate using `openssl`:
   ```bash
   echo | openssl s_client -connect console-openshift-console.apps.ocp420.corp.local:443        -servername console-openshift-console.apps.ocp420.corp.local 2>/dev/null | openssl x509 -noout -issuer -subject -dates
   ```
2. Confirm the issuer reflects your corporate CA and not `openshift-ingress`.

---
[Next: Identity Providers & RBAC](03-identity-providers-rbac.md) • [Back to Day 1 Index](README.md)
