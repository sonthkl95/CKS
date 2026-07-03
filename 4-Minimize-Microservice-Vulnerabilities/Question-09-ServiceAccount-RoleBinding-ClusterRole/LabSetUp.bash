#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'staging'..."
kubectl create ns staging --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating ServiceAccount 'psp-restrict-sa'..."
kubectl create sa psp-restrict-sa -n staging --dry-run=client -o yaml | kubectl apply -f -
echo ""
echo "[!] NOTE: PodSecurityPolicy was removed in Kubernetes v1.25. On newer clusters,"
echo "    implement the same intent with Pod Security Admission (enforce=restricted)."
echo ""
echo "[i] Task: create PSP 'prevent-psp-policy' (no privileged), ClusterRole 'restrict-access-role',"
echo "    and ClusterRoleBinding 'restrict-access-bind' -> psp-restrict-sa."
echo "[+] Lab Setup Complete."
