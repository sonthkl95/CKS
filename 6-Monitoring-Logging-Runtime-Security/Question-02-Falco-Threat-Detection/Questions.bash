#!/bin/bash
# Questions.bash  —  CKS Practice Test 1, Question 16
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 1  ·  Question 16
===============================================================

Cluster security monitoring revealed that a malicious container is attempting to access `/dev/mem`, which represents direct access to physical memory.

Such activity is highly dangerous as it may lead to privilege escalation or kernel bypass.

Use Falco (or sysdig) to detect the malicious Pod and its Deployment, then scale the Deployment replicas to `0` to stop the workload.

===============================================================
CKS_TASK_EOF
