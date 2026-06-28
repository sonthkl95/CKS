#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace with --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace app --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace and --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace appkubectl --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Lab Setup Complete."