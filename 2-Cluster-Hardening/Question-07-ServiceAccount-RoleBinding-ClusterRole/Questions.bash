#!/bin/bash
# Questions.bash  —  CKS Practice Test 2, Question 14
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 2  ·  Question 14
===============================================================

Modify the existing `Role` bound to ServiceAccount `sa-dev-1` (used by Pod `web-pod` in namespace `security`) to allow only `watch` on `services`.

Create a new `ClusterRole` `role-2` to allow only `update` on `namespaces`.

Bind it via a `ClusterRoleBinding` named `role-2-binding` to the ServiceAccount `sa-dev-1`.

===============================================================
CKS_TASK_EOF
