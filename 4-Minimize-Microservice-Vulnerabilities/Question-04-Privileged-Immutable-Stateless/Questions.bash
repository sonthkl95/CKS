#!/bin/bash
# Questions.bash  —  CKS Practice Test 1, Question 9
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 1  ·  Question 9
===============================================================

Ensure that all Pods in the `prod` namespace follow the best practices of being stateless and immutable. Identify and delete any Pods that store data in container volumes (stateful) or are configured as `privileged`/with `writable root filesystems` (not immutable).

===============================================================
CKS_TASK_EOF
