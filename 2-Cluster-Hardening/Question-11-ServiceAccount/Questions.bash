#!/bin/bash
# Questions.bash  —  CKS Practice Test 4, Question 2
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 4  ·  Question 2
===============================================================

You have an existing Pod named `nginx-pod` in the `test-system` namespace.

Fetch its ServiceAccount name and save it to a file `/candidate/sa-name.txt`.

Then, create a Role in the same namespace that can list, get, and watch Deployments, and bind it to the Pod's ServiceAccount.

===============================================================
CKS_TASK_EOF
