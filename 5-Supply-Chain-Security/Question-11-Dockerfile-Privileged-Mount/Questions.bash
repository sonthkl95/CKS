#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 4 - Question 3
=======================================================

Review a Dockerfile based on ubuntu:20.04 and a Kubernetes Deployment manifest.
Fix two prominent security/best-practice issues in each file at /home/manifests without adding or removing other configuration.
Use an unprivileged user nobody with UID 65535 where needed.

Given files

Dockerfile

```yaml
FROM ubuntu:latest
RUN apt-get update && \
apt-get install -y --no-install-recommends ca-certificates curl && \
rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY app /app
RUN chmod -R a+rX /app
USER root
CMD ["./start.sh"]
```

Deployment manifest

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
labels:
app: kafka
name: kafka
spec:
replicas: 1
selector:
matchLabels:
app: kafka
template:
metadata:
labels:
app: kafka
spec:
containers:
- image: bitnami/kafka
name: kafka
volumeMounts:
- mountPath: /opt/bitnami/kafka/bin
name: kafka-vol
securityContext:
capabilities:
add: ["NET_ADMIN"]
drop: ["ALL"]
privileged: true
readOnlyRootFilesystem: false
runAsUser: 0
resources: {}
volumes:
- name: kafka-vol
hostPath:
path: /
```

=======================================================
EOF
