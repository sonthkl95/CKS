#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace and --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /etc/kubernetes/manifests
cat << 'EOF_MOCK' > /etc/kubernetes/manifests/kube-apiserver.yaml
---apiVersion: v1kind: ServiceAccountmetadata:  name: default  namespace: defaultautomountServiceAccountToken: false  # add this line
EOF_MOCK
echo "[+] Lab Setup Complete."