#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Writing the Dockerfile and Deployment manifest at /home/manifests ..."
mkdir -p /home/manifests
cat > /home/manifests/Dockerfile <<'EOF'
FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY app /app
RUN chmod -R a+rX /app
USER root
CMD ["./start.sh"]
EOF
cat > /home/manifests/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kafka
  labels: { app: kafka }
spec:
  replicas: 1
  selector: { matchLabels: { app: kafka } }
  template:
    metadata: { labels: { app: kafka } }
    spec:
      containers:
      - name: kafka
        image: bitnami/kafka
        volumeMounts:
        - { mountPath: /opt/bitnami/kafka/bin, name: kafka-vol }
        securityContext:
          capabilities: { add: ["NET_ADMIN"], drop: ["ALL"] }
          privileged: true
          readOnlyRootFilesystem: false
          runAsUser: 0
        resources: {}
      volumes:
      - name: kafka-vol
        hostPath: { path: / }
EOF
echo ""
echo "[i] Task: fix TWO issues in each file (no adding/removing fields). Use user 'nobody' (UID 65535) where needed."
echo "[+] Lab Setup Complete."
