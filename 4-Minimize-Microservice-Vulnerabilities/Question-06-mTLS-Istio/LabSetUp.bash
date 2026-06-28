#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace must --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace payments --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace inherit --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace before --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Lab Setup Complete."