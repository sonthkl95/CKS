#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Writing the Dockerfile and Deployment manifest at /home/candidate/10 ..."
mkdir -p /home/candidate/10
cat > /home/candidate/10/Dockerfile <<'EOF'
FROM ubuntu:latest
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends runit wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
COPY scripts/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["couchbase-server"]
EOF
cat > /home/candidate/10/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata: { name: couchbase, namespace: default }
spec:
  replicas: 1
  selector: { matchLabels: { app: couchbase } }
  template:
    metadata: { labels: { app: couchbase } }
    spec:
      containers:
      - name: couchbase
        image: couchbase:latest
        securityContext:
          privileged: true
          runAsUser: 0
EOF
echo ""
echo "[i] Task: fix TWO issues in each file (no adding/removing fields). Use user 'nobody' (UID 65535) where needed."
echo "[+] Lab Setup Complete."
