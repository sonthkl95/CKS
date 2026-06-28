#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace and --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace team-dev --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Lab Setup Complete."