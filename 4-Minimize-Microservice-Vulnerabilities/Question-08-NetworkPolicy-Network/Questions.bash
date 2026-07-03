#!/bin/bash
# Questions.bash  —  CKS Practice Test 2, Question 5
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 2  ·  Question 5
===============================================================

Create a NetworkPolicy named `restricted-policy` to restrict access to the Pod `products-service` in the `dev-team` namespace:

Only allow ingress traffic from:

Pods in the same namespace `dev-team`.

Pods with label `environment=testing` in any namespace.

===============================================================
CKS_TASK_EOF
