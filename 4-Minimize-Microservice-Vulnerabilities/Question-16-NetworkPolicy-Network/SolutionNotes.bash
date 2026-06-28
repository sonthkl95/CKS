#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 4 - Question 5
=======================================================

Create manifest

```yaml
vim allow-np.yaml
```

```yaml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
name: allow-np
namespace: staging
spec:
podSelector: {}                 # applies to all pods in the namespace
policyTypes:
- Ingress
ingress:
- from:
- podSelector: {}             # only pods within the same namespace
ports:
- protocol: TCP
port: 80                    # allow only traffic on port 80
```

```yaml
kubectl apply -f allow-np.yaml
```

Verification Step:

```yaml
# Check the policy was created
kubectl get networkpolicy -n staging
# Describe to verify rules
kubectl describe networkpolicy allow-np -n staging
```

'' Note:
By default, once a NetworkPolicy is applied, all other traffic is denied unless explicitly allowed.

podSelector: {} applies the policy to all pods in the namespace.

If the CNI plugin used in the cluster does not support NetworkPolicy (e.g., basic flannel), this configuration will not take effect.

=======================================================
EOF
