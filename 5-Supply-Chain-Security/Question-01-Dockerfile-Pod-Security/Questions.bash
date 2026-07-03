#!/bin/bash
# Questions.bash  —  CKS Practice Test 1, Question 6
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 1  ·  Question 6
===============================================================

You are given a Dockerfile and a Pod manifest. Both contain security best practice violations that need fixing.

Rules:

Fix two issues in the Dockerfile.

Fix two issues in the Pod manifest.

Do not add or remove fields — only edit existing ones.

When a non-root user is needed, use `test-user` with UID `5375`.

Given Files

Dockerfile:

```bash
FROM ubuntu:latest
RUN apt-get update -y
RUN apt-get install nginx -y
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
USER ROOT
```

Pod manifest:

```bash
---
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo-2
spec:
  securityContext:
    runAsUser: 1000
  containers:
  - name: security-context-demo-2
    image: gcr.io/google-samples/node-hello:1.0
    securityContext:
      runAsUser: 0
      privileged: true
      allowPrivilegeEscalation: false
```

===============================================================
CKS_TASK_EOF
