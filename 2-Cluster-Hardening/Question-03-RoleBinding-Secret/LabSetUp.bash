#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'john'..."
kubectl create ns john --dry-run=client -o yaml | kubectl apply -f -
echo ""
echo "[i] You will create the user 'john' (openssl key + CSR), approve the CSR,"
echo "    then create Role 'john-role' and RoleBinding 'john-role-binding' in ns 'john'."
echo "[+] Lab Setup Complete."
