#!/bin/bash
# Questions.bash  —  CKS Practice Test 3, Question 14
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 3  ·  Question 14
===============================================================

Adjust overly broad Role permissions assigned to a Pod's ServiceAccount.

You have an existing Pod named `web-pod` in the `database` namespace.

Modify existing Role

Edit the Role bound to the Pod’s ServiceAccount `test-sa`

Restrict it to only allow `get` actions on resources of type `Pods`.

Create a new Role

Name: `test-role-2`

Namespace: `database`

Permissions: only `update` actions on resources of type `StatefulSets`.

Create a RoleBinding

Name: `test-role-2-bind`

Bind the newly created Role to the same ServiceAccount `test-sa`.

Summary:
Limit the existing Role to `get` on Pods, create a new Role with `update` on StatefulSets, and bind it to the same ServiceAccount.

===============================================================
CKS_TASK_EOF
