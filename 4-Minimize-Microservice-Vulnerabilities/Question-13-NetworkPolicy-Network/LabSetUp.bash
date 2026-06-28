#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace are --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace testingkubectl --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace testing --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace that --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Lab Setup Complete."