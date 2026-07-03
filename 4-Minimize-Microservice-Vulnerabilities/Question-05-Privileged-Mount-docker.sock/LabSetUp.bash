#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'dev-ops'..."
kubectl create ns dev-ops --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Deploying a Deployment that mounts /var/run/docker.sock..."
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata: { name: docker-app, namespace: dev-ops }
spec:
  replicas: 1
  selector: { matchLabels: { app: docker-app } }
  template:
    metadata: { labels: { app: docker-app } }
    spec:
      containers:
      - name: app
        image: docker:24
        command: ["sleep", "infinity"]
        volumeMounts:
        - { name: docker-sock, mountPath: /var/run/docker.sock }
      volumes:
      - name: docker-sock
        hostPath: { path: /var/run/docker.sock }
EOF
echo ""
echo "[i] Task: find the Pod(s) mounting docker.sock and remove the volume mount from the Deployment."
kubectl get deploy,pods -n dev-ops
echo "[+] Lab Setup Complete."
