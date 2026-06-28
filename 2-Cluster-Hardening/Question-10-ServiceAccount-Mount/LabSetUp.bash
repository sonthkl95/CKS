#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace qakubectl --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace qa --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /home/candidate/11
cat << 'EOF_MOCK' > /home/candidate/11/pod-manifest.yaml
apiVersion: v1kind: Podmetadata:  name: frontend  namespace: qa  labels:    run: frontendspec:  serviceAccountName: frontend-sa  automountServiceAccountToken: false  containers:  - name: frontend    image: nginx
EOF_MOCK
echo "[+] Lab Setup Complete."