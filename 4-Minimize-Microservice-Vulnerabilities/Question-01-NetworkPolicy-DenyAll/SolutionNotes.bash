#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 4 - Question 7
=======================================================

Commands / Steps:

```yaml
vim /home/policy/network-policy.yaml
```

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
name: deny-network
namespace: test
spec:
podSelector: {}  # Apply policy to all pods in the namespace
policyTypes:
- Ingress
- Egress
```

```yaml
kubectl apply -f /home/policy/network-policy.yaml
```

Verification Step:

```yaml
# Check that the network policy exists
kubectl get networkpolicy -n test
# Describe to see that all traffic is denied
kubectl describe networkpolicy deny-network -n test
# Check that no traffic is allowed
kubectl run test-pod -n test --image=nginx -- sleep 3600
kubectl exec -n test test-pod -- curl -s http://localhost:80
```

'' Note:
Applying a default-deny NetworkPolicy ensures that pods are not accidentally reachable from other pods or external sources.

In namespaces without any other NetworkPolicies, this effectively isolates all pods until other policies explicitly allow traffic.

=======================================================
EOF
