#!/bin/bash
# Questions.bash  —  CKS Practice Test 1, Question 8
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 1  ·  Question 8
===============================================================

By default, Kubernetes stores Secrets in etcd in plaintext, which is insecure.

Your task is to enable encryption at rest for Secrets using an `EncryptionConfiguration` manifest with `AES-CBC` and `identity` providers, ensuring that all secrets are encrypted in etcd.

===============================================================
CKS_TASK_EOF
