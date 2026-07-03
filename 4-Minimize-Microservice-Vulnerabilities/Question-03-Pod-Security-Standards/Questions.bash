#!/bin/bash
# Questions.bash  —  CKS Practice Test 3, Question 16
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 3  ·  Question 16
===============================================================

In the namespace `team-blue`, developers deployed a Pod running in privileged mode, which violates the `restricted` Pod Security Standard.

You must configure the namespace to enforce the `restricted` profile so that insecure Pods cannot be recreated.

Then delete the running Pod from the Deployment and capture the ReplicaSet events showing why the Pod fails to restart.

- Configure the namespace `team-blue` to enforce the `restricted` Pod Security Standard (via labels).

- Delete the Pod from Deployment privileged-runner in `team-blue`.

- Observe ReplicaSet events to confirm that the Pod fails to be recreated due to Pod Security violations.

- Write the event/log lines showing the failure reason into `/opt/candidate/16/logs` on `cks-node`.

===============================================================
CKS_TASK_EOF
