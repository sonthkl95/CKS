#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace dev-teamkubectl --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace dev-team --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace labelskubectl --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace or --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Lab Setup Complete."