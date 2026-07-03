#!/bin/bash
# Questions.bash  —  CKS Practice Test 2, Question 9
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 2  ·  Question 9
===============================================================

Create a new Kubernetes user, approve its certificate, and assign namespace-specific permissions:

Create a user `john` and generate a Certificate Signing Request (CSR).

Approve the CSR and retrieve the signed certificate.

Create a Role `john-role` in namespace `john` to allow `list`, `get`, `create`, and `delete` on `pods` and `secrets`.

Create a RoleBinding `john-role-binding` to attach the Role to user `john`.

Verify permissions using `kubectl auth can-i`.

===============================================================
CKS_TASK_EOF
