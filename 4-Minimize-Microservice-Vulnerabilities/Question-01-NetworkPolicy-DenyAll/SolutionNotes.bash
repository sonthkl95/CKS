#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 1, Question 2
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 1  ·  Question 2
===============================================================

NetworkPolicy manifest

```bash
# netpol-deny-all.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: testing
spec:
  podSelector: {}  # selects all pods in the namespace
  policyTypes:
  - Ingress
  - Egress
```

```bash
kubectl apply -f netpol-deny-all.yaml
```

Verification Step:

Confirm the policy is applied and restricting traffic correctly:

```bash
kubectl get netpol -n testing
kubectl describe netpol deny-all -n testing
```

===============================================================
CKS_SOLUTION_EOF
