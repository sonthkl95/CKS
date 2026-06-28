#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace staging --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace can --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Lab Setup Complete."