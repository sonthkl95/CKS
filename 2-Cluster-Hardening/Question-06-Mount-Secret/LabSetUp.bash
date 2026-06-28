#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace with --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace safe --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Lab Setup Complete."