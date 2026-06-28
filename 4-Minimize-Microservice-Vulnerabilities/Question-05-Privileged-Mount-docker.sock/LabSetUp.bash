#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace dev-opskubectl --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace dev-ops --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Lab Setup Complete."