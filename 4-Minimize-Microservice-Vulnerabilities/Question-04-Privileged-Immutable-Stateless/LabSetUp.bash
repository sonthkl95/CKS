#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'prod'..."
kubectl create ns prod --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Deploying a mix of compliant and non-compliant Pods..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata: { name: clean-app, namespace: prod }
spec:
  containers:
  - name: c
    image: nginx:1.25-alpine
    securityContext: { readOnlyRootFilesystem: true }
---
apiVersion: v1
kind: Pod
metadata: { name: stateful-app, namespace: prod }   # violates: stores data in a volume
spec:
  containers:
  - name: c
    image: nginx:1.25-alpine
    volumeMounts: [{ name: data, mountPath: /data }]
  volumes: [{ name: data, emptyDir: {} }]
---
apiVersion: v1
kind: Pod
metadata: { name: privileged-app, namespace: prod }  # violates: privileged
spec:
  containers:
  - name: c
    image: nginx:1.25-alpine
    securityContext: { privileged: true }
---
apiVersion: v1
kind: Pod
metadata: { name: writable-app, namespace: prod }    # violates: writable root fs
spec:
  containers:
  - name: c
    image: nginx:1.25-alpine
    securityContext: { readOnlyRootFilesystem: false }
EOF
echo ""
echo "[i] Task: delete Pods in 'prod' that are stateful (volumes), privileged, or have a writable root fs."
kubectl get pods -n prod
echo "[+] Lab Setup Complete."
