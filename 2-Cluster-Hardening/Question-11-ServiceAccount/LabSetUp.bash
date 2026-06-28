#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace and --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace test-system --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace that --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Lab Setup Complete."