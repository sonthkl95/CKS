#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'staging'..."
kubectl create ns staging --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Deploying pods that listen on port 80 (and one that does not)..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata: { name: web-80, namespace: staging, labels: { app: web } }
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
    ports: [{ containerPort: 80 }]
---
apiVersion: v1
kind: Pod
metadata: { name: client, namespace: staging, labels: { app: client } }
spec:
  containers:
  - name: busybox
    image: busybox:1.36
    command: ["sleep", "infinity"]
EOF
echo ""
echo "[i] Task: create NetworkPolicy 'allow-np' allowing ns 'staging' pods to reach port 80"
echo "    of other pods in the same ns; deny other ports and cross-namespace traffic."
echo "[+] Lab Setup Complete."
