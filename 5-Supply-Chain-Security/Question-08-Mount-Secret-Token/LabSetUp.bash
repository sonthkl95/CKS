#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespaces 'dev' and 'app'..."
kubectl create ns dev --dry-run=client -o yaml | kubectl apply -f -
kubectl create ns app --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Ensuring a token-style secret exists in ns 'dev'..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: default-token-abcde
  namespace: dev
  annotations:
    kubernetes.io/service-account.name: default
type: kubernetes.io/service-account-token
EOF
echo ""
echo "[i] Task: extract ca.crt from the 'dev' token secret, create secret 'app-config-secret'"
echo "    (APP_USER=appadmin, APP_PASS=Sup3rS3cret) in ns 'app', and deploy Pod 'app-pod'"
echo "    (nginx) mounting the secret at /etc/app-config."
echo "[+] Lab Setup Complete."
