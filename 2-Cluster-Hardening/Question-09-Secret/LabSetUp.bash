#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'qa'..."
kubectl create ns qa --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating the existing 'frontend' Pod in ns 'qa'..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  namespace: qa
  labels:
    app: frontend
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF
echo ""
echo "[i] Task: create SA 'backend-qa' (no secret access) in ns 'qa' and update the"
echo "    'frontend' Pod to use it."
echo "[+] Lab Setup Complete."
