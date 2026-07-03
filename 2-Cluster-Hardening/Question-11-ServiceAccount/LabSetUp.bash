#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'test-system'..."
kubectl create ns test-system --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating a dedicated ServiceAccount and the existing 'nginx-pod'..."
kubectl create sa app-sa -n test-system --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  namespace: test-system
spec:
  serviceAccountName: app-sa
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF
mkdir -p /candidate
echo ""
echo "[i] Task: save the Pod's SA name to /candidate/sa-name.txt, then create a Role"
echo "    (list/get/watch Deployments) and bind it to that ServiceAccount."
echo "[+] Lab Setup Complete."
