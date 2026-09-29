# Ingress Controller & Custom Wildcard Certificates

By default, OpenShift issues a self-signed ingress certificate (`*.apps.<cluster>.<baseDomain>`). This triggers browser security warnings and breaks automated API clients.

---

## Replacing the Wildcard Certificate

1. **Prepare Certificate and Private Key**:
   - Ensure the certificate contains `CN=*.apps.<cluster>.<baseDomain>` and all intermediate certificates up to the root CA.
2. **Create Secret in `openshift-ingress`**:
   ```bash
   oc create secret tls wildcard-apps-tls-cert       --cert=fullchain.pem       --key=privkey.pem       -n openshift-ingress
   ```
3. **Patch the IngressController**:
   ```bash
   oc patch ingresscontroller.operator default       --type=merge -p       '{"spec":{"defaultCertificate":{"name":"wildcard-apps-tls-cert"}}}'       -n openshift-ingress-operator
   ```
4. **Verification**:
   ```bash
   echo | openssl s_client -connect console-openshift-console.apps.<cluster>.<baseDomain>:443 -servername console-openshift-console.apps.<cluster>.<baseDomain> 2>/dev/null | openssl x509 -noout -issuer -subject -dates
   ```

---
[Next: Identity Providers & RBAC](03-identity-providers-rbac.md) • [Back to Day 1 Index](README.md)
