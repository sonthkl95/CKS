#!/bin/bash
# Questions.bash  —  CKS Practice Test 2, Question 7
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 2  ·  Question 7
===============================================================

Deploy a Pod using a custom RuntimeClass:

Create a RuntimeClass named `untrusted` using the prepared runtime handler `runsc` (gVisor).

Deploy a Pod named `untrusted` with image `alpine:3.18` in the `default` namespace.

Ensure the Pod runs on `node-02` using the `untrusted` RuntimeClass.

Capture the output of `dmesg` from the running Pod into `/opt/course/7/untrusted-test-dmesg`.

===============================================================
CKS_TASK_EOF
