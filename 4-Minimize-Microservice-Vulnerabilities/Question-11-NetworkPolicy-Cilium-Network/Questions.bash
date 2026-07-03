#!/bin/bash
# Questions.bash  —  CKS Practice Test 3, Question 1
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 3  ·  Question 1
===============================================================

In Namespace `team-dev`, there is an existing CiliumNetworkPolicy `default-allow` which allows all namespace-internal traffic and cluster DNS.
The task is to create two new Layer 3 and Layer 4 CiliumNetworkPolicy named `team-dev` and `team-dev-2` that:

Enables `Mutual Authentication` for outgoing traffic from Pods with label `role=database` to Pods with label `role=api-service`.

Denies outgoing ICMP traffic from Pods of Deployment `stuff` to Pods behind Service `backend`.

===============================================================
CKS_TASK_EOF
