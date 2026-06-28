#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 4 - Question 7
=======================================================

Create a default-deny NetworkPolicy in the test namespace to prevent accidental exposure of pods.
The policy should block all ingress and egress traffic for every pod in the namespace.
You can find a skeleton manifests file at /home/policy/network-policy.yaml

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
name: deny-network
```

=======================================================
EOF
