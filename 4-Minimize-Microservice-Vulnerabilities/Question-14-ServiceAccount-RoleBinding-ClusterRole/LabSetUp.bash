#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace restricted --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Lab Setup Complete."