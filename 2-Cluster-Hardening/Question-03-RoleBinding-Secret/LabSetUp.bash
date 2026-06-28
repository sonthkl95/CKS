#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace for --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace RBAC --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace johnkubectl --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace john --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Lab Setup Complete."