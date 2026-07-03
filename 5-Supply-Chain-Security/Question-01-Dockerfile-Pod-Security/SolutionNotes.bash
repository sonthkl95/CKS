#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 1, Question 6
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 1  ·  Question 6
===============================================================

Step 1: Fixed Dockerfile

```bash
FROM ubuntu:20.04           # ✅ use fixed, stable version instead of 'latest'
RUN apt-get update -y
RUN apt-get install nginx -y
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
USER test-user              # ✅ run as unprivileged user (test-user, UID 5375)
```

Step 2: Fixed Pod manifest

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
      runAsUser: 5375         # ✅ avoid running as root (use test-user UID 5375)
      privileged: false       # ✅ disable privileged mode
      allowPrivilegeEscalation: false
```

Issues Fixed:

Dockerfile

`FROM ubuntu:latest` → `FROM ubuntu:20.04` → avoids unpredictability and vulnerabilities from `latest`.

`USER ROOT` → `USER 5375` → prevents running as root (principle of least privilege).

Manifest

`runAsUser: 0` → `runAsUser: 5375` → avoid root user inside container.

`privileged: true` → `privileged: false` → prevents host-level privileges.

===============================================================
CKS_SOLUTION_EOF
