#!/bin/bash
# Questions.bash  —  CKS Practice Test 2, Question 1
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 2  ·  Question 1
===============================================================

Enforce a prepared AppArmor profile on a Kubernetes Pod:

Apply the `nginx-deny` AppArmor profile on a worker node.

Modify the Pod manifest to use this profile.

Deploy the Pod and verify that the profile restricts file write operations.

===============================================================
CKS_TASK_EOF
