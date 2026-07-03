#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'testing'..."
kubectl create ns testing --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Deploying a test Pod..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata: { name: app, namespace: testing, labels: { app: app } }
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF
echo ""
echo "[i] Task: create NetworkPolicy 'default-deny' in ns 'testing' blocking all Egress"
echo "    (optionally allow DNS egress)."
echo "[+] Lab Setup Complete."
