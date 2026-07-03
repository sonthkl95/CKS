#!/bin/bash
# Questions.bash  —  CKS Practice Test 3, Question 12
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 3  ·  Question 12
===============================================================

Implement a PodSecurityPolicy that restricts Pod volumes and bind it to a ServiceAccount:

Create a PodSecurityPolicy named `prevent-volume-policy` that only allows `persistentVolumeClaim` volumes.

Create a ServiceAccount `psp-sa` in the `restricted` namespace.

Create a ClusterRole `psp-role` that grants access to the PodSecurityPolicy.

Create a ClusterRoleBinding `psp-role-binding` binding the ClusterRole to the ServiceAccount.

Verify the configuration by attempting to create a Pod with a Secret volume; it should fail.

===============================================================
CKS_TASK_EOF
