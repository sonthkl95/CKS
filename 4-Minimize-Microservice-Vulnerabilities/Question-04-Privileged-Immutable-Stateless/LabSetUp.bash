#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace prodkubectl --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace follow --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace prod --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Lab Setup Complete."