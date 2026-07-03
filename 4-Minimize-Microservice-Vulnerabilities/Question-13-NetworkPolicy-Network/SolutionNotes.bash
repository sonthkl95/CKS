#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 3, Question 5
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 3  ·  Question 5
===============================================================

By applying a default-deny Egress NetworkPolicy with an empty `podSelector`, all Pods in the namespace are restricted from initiating outbound connections.
Specific exceptions like DNS can be allowed by adding `egress` rules.

Commands / Steps

```bash
# default-deny-np.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: testing
spec:
  podSelector: {}       # Applies to all pods in the testing namespace
  policyTypes:
  - Egress
  # No rules in egress list blocks all egress traffic
```

`Optional`:  Allow DNS `egress`

```bash
# Optional: allow DNS egress to kube-system namespace
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: testing
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          name: kube-system
    ports:
    - protocol: UDP
      port: 53
```

```bash
# You can also allow egress to DNS at all (into any direction)
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
  namespace: testing
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - to: []           # allow egress into any direction
    ports:
    - protocol: UDP
      port: 53
```

```bash
# Apply the default-deny NetworkPolicy
kubectl apply -f default-deny-np.yaml
```

Verification Step:

```bash
# Ensure all Pods are restricted from egress
kubectl get networkpolicy -n testing
kubectl describe networkpolicy default-deny -n testing
```

⚠️ Note:

NetworkPolicy with empty `podSelector` applies to all Pods in the namespace.

By default, an empty `egress` array `[]` blocks all egress traffic.

Allowing DNS (`UDP 53`) is optional depending on cluster requirements.

Ensure the NetworkPolicy name in the `apply` command matches the file name.

===============================================================
CKS_SOLUTION_EOF
