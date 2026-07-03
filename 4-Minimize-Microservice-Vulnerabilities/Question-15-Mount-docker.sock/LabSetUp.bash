#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'sandbox'..."
kubectl create ns sandbox --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Deploying Deployment 'docker-admin' that mounts /var/run/docker.sock..."
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata: { name: docker-admin, namespace: sandbox }
spec:
  replicas: 1
  selector: { matchLabels: { app: docker-admin } }
  template:
    metadata: { labels: { app: docker-admin } }
    spec:
      containers:
      - name: docker-container
        image: docker:24
        command: ["sleep", "infinity"]
        volumeMounts:
        - { name: dockersock, mountPath: /var/run/docker.sock }
      volumes:
      - name: dockersock
        hostPath: { path: /var/run/docker.sock }
EOF
echo ""
echo "[i] Task: harden the Deployment — run as non-root, drop all capabilities,"
echo "    read-only root fs, and make the docker.sock mount read-only."
kubectl get deploy,pods -n sandbox
echo "[+] Lab Setup Complete."
