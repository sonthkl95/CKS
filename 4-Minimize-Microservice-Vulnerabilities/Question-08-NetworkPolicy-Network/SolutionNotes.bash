#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 2 - Question 5
=======================================================

Kubernetes NetworkPolicies control traffic to Pods. Here, we define an ingress policy that restricts access to products-service pods, while allowing only specific Pods from the same namespace or Pods with a specific label from any namespace.

Commands / Steps:

```yaml
# Check namespace labels
kubectl get ns dev-team --show-labels
# Check pod labels in dev-team namespace
kubectl get po -n dev-team --show-labels
# Create the NetworkPolicy manifest
vim netpol-restricted-policy.yaml
```

```yaml
# netpol-restricted-policy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
name: restricted-policy
namespace: dev-team
spec:
podSelector:
matchLabels:
environment: dev    # selects products-service pods
policyTypes:
- Ingress
ingress:
# 1. Allow all pods in dev-team namespace
- from:
- podSelector: {}   # all pods in dev-team
# 2. Allow pods with label environment=testing in any namespace
- from:
- namespaceSelector: {}   # all namespaces
podSelector:
matchLabels:
environment: testing
```

```yaml
# Apply the NetworkPolicy
kubectl create -f netpol-restricted-policy.yaml
# Describe the applied NetworkPolicy
kubectl describe netpol -n dev-team restricted-policy
```

Verification Step:
Confirm the policy is applied and restricting traffic correctly:

```yaml
kubectl get netpol -n dev-team
kubectl describe netpol -n dev-team restricted-policy
```

Pods in dev-team should connect to products-service

Pods with label environment=testing from other namespaces should connect.

All other Pods should be denied.

=======================================================
EOF
