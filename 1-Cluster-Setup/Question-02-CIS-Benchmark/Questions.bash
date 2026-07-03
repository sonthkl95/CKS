#!/bin/bash
# Questions.bash  —  CKS Practice Test 2, Question 11
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 2  ·  Question 11
===============================================================

A CIS Benchmark scan revealed multiple violations on the API server, Kubelet, and etcd. Fix all findings by updating configuration files and restarting affected components.

Violations to fix:

API Server

`authorization-mode` must not be `AlwaysAllow`.

Must include `Node`.

Must include `RBAC`.

Kubelet

Anonymous authentication must be disabled.

Authorization mode must not be `AlwaysAllow`; should use `Webhook`.

etcd

`--client-cert-auth` must be enabled.

`--auto-tls` must not be enabled.

Use valid TLS certificates (not self-signed).

===============================================================
CKS_TASK_EOF
