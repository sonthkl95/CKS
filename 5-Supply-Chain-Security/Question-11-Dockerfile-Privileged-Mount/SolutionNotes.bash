#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 4 - Question 3
=======================================================

Commands / Steps

Edit Dockerfile

```yaml
vim /home/manifests/Dockerfile
```

```yaml
FROM ubuntu:20.04      # -> Fixed: use specific version instead of latest
RUN apt-get update && \
apt-get install -y --no-install-recommends ca-certificates curl && \
rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY app /app
RUN chmod -R a+rX /app
USER root              # -> Fixed: run container as unprivileged user
CMD ["./start.sh"]
```

Edit Deployment manifest

```yaml
vim /home/manifests/deployment.yaml
```

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
privileged: false            # -> Fixed: avoid privileged container
readOnlyRootFilesystem: true # -> Fixed: enforce read-only FS
runAsUser: 65535             # -> Fixed: run as unprivileged user
resources: {}
volumes:
- name: kafka-vol
hostPath:
path: /
```

Verification Step:

```yaml
# Check container user in Dockerfile
docker build -t test-app /home/manifests
docker run --rm -it test-app id
# Check Deployment securityContext
kubectl get deploy kafka -o yaml | grep -A 5 securityContext
```

=======================================================
EOF
