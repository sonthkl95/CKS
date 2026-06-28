#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace using --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Lab Setup Complete."