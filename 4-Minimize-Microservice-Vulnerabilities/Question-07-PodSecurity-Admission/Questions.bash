#!/bin/bash
# Questions.bash  —  CKS Practice Test 1, Question 14
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 1  ·  Question 14
===============================================================

The namespace `secure-team` is configured with Pod Security Admission label enforcing `restricted` profile.

You are given a Deployment manifest `/home/masters/insecure-deployment.yaml` that fails to start because it violates the `restricted` Pod Security Standard.

Your task is to edit the YAML to fix each of these issues and get the Deployment running successfully in `secure-team` namespace.

===============================================================
CKS_TASK_EOF
