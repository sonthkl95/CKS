#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'dev-team'..."
kubectl create ns dev-team --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Deploying the 'products-service' Pod and a client Pod..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: products-service
  namespace: dev-team
  labels: { app: products-service }
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
---
apiVersion: v1
kind: Pod
metadata:
  name: client
  namespace: dev-team
  labels: { app: client }
spec:
  containers:
  - name: busybox
    image: busybox:1.36
    command: ["sleep", "infinity"]
EOF
echo ""
echo "[i] Task: create NetworkPolicy 'restricted-policy' allowing ingress to 'products-service'"
echo "    only from ns 'dev-team' pods and from pods labelled environment=testing in any ns."
echo "[+] Lab Setup Complete."
