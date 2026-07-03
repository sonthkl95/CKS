#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'payments'..."
kubectl create ns payments --dry-run=client -o yaml | kubectl apply -f -
echo ""
echo "[i] This task requires Istio to be installed in the cluster."
echo "    1. Verify/enable sidecar injection: kubectl label ns payments istio-injection=enabled"
echo "    2. Apply a PeerAuthentication with mtls.mode: STRICT in ns 'payments'."
kubectl get ns payments --show-labels
echo "[+] Lab Setup Complete."
