#!/bin/bash
# Questions.bash  —  CKS Practice Test 1, Question 10
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 1  ·  Question 10
===============================================================

The cluster uses containerd with `runc` as the default runtime.

It has been prepared to support an additional runtime handler, `runsc` (gVisor).

Create a `RuntimeClass` named `sandboxed` using `runsc`, and update all Pods in the `server` namespace to use this runtime.

`/home/candidate/10/runtime-class.yaml`

===============================================================
CKS_TASK_EOF
