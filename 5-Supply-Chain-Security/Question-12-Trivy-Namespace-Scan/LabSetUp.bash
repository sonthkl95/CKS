#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'nato'..."
kubectl create ns nato --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Deploying Pods using a mix of clean and vulnerable image tags..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata: { name: nginx-1, namespace: nato }
spec: { containers: [ { name: c, image: nginx:1.25-alpine } ] }
---
apiVersion: v1
kind: Pod
metadata: { name: nginx-2, namespace: nato }
spec: { containers: [ { name: c, image: nginx:1.16 } ] }
---
apiVersion: v1
kind: Pod
metadata: { name: nginx-3, namespace: nato }
spec: { containers: [ { name: c, image: httpd:2.4.49 } ] }
EOF
echo ""
echo "[!] NOTE: requires the 'trivy' tool installed on the node."
echo "[i] Task: scan the images used by Pods in ns 'nato' for HIGH/CRITICAL vulnerabilities"
echo "    and delete any Pod running a severely vulnerable image."
kubectl get pods -n nato
echo "[+] Lab Setup Complete."
