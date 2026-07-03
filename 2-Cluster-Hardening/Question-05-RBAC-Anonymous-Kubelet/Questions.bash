#!/bin/bash
# Questions.bash  —  CKS Practice Test 1, Question 7
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 1  ·  Question 7
===============================================================

Fix multiple security violations identified by `kube-bench`.

API Server:

Enable `RotateKubeletServerCertificate`.

Enable admission plugin `PodSecurityPolicy`.

Set `--kubelet-certificate-authority` argument.

Kubelet:

Disable anonymous authentication.

Set `authorization-mode` to `Webhook`.

ETCD:

Ensure `--auto-tls` is not `true`.

Ensure `--peer-auto-tls` is not `true`.

===============================================================
CKS_TASK_EOF
