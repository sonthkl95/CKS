#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 1, Question 13
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 1  ·  Question 13
===============================================================

Step 1: Verify automatic Sidecar Injection

Istio sidecar injection should be enabled for the namespace before enforcing `mTLS`:

```bash
kubectl get namespace payments --show-labels
# Check for label: istio-injection=enabled
```

If not present, enable it:

```bash
kubectl label namespace payments istio-injection=enabled --overwrite
kubectl get namespace payments --show-labels
```

⚠️ Important:

If Pods were created before the label was added, they do not have sidecars.

In that case, you must restart/recreate the Pods so that sidecars are injected (e.g., `kubectl rollout restart deployment -n payments`).

If Pods already had sidecars, no restart is required.

Step 2: Enforce `mTLS` in `STRICT` mode

```bash
kubectl get pod -n payments
```

Create a `PeerAuthentication` resource for the namespace:

```bash
# payments-mtls.yaml
apiVersion: security.istio.io/v1
kind: PeerAuthentication
metadata:
  name: payments-mtls-strict
  namespace: payments
spec:
  mtls:
    mode: STRICT
```

```bash
kubectl apply -f payments-mtls.yaml
```

Step 3: Verify `mTLS` enforcement

```bash
# List PeerAuthentication policies
kubectl get peerauthentication -n payments

# Confirm sidecar containers in all pods
kubectl get pods -n payments -o jsonpath='{range .items[*]}{.metadata.name}{" - "}{.spec.containers[*].name}{"\n"}{end}'  # optional

# Test mTLS enforcement between Pods
kubectl exec -it <pod1> -n payments -- curl -v http://<pod2>.<payments>.svc.cluster.local
```

Explanation

`Sidecar Injection`: Istio mTLS requires the Envoy sidecar in each Pod to handle certificate-based encryption.

`PeerAuthentication STRICT mode`: All traffic within the namespace must use mTLS. Any plain text connections are denied.

`Validation`: Ensures both the sidecar is present and that the PeerAuthentication policy is applied.

⚠️ Notes:

`mTLS STRICT` will reject any Pod traffic without a sidecar or without valid Istio certificates.

Always verify that new workloads in the namespace inherit sidecar injection.

===============================================================
CKS_SOLUTION_EOF
