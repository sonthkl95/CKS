#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'safe'..."
kubectl create ns safe --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating the existing secret 'admin' in ns 'safe'..."
kubectl create secret generic admin -n safe \
  --from-literal=username=admin --from-literal=password=admin-pass-123 \
  --dry-run=client -o yaml | kubectl apply -f -
echo ""
echo "[i] Task: read 'admin' fields into /home/cert-masters/{username,password}.txt,"
echo "    create secret 'newsecret' (dbadmin/moresecurepas), and a Pod mounting it."
kubectl get secret admin -n safe
echo "[+] Lab Setup Complete."
