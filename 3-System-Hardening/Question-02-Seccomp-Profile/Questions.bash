#!/bin/bash
# Questions.bash  —  CKS Practice Test 3, Question 2
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 3  ·  Question 2
===============================================================

For security hardening, enforce a Seccomp profile on Pods in Namespace `secure-app`.

Create a custom Seccomp profile that allows only basic system calls (`read`, `write`, `exit`, `sigreturn`).

Apply the Seccomp profile to the Deployment `webapp` to restrict system calls for its containers.

Verify that the Pod is running and that the Seccomp profile is enforced.

===============================================================
CKS_TASK_EOF
