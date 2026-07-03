#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'restricted'..."
kubectl create ns restricted --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating ServiceAccount 'psp-sa'..."
kubectl create sa psp-sa -n restricted --dry-run=client -o yaml | kubectl apply -f -
echo ""
echo "[!] NOTE: PodSecurityPolicy was removed in Kubernetes v1.25. On newer clusters use"
echo "    Pod Security Admission or a policy engine (Kyverno/Gatekeeper) for the same intent."
echo ""
echo "[i] Task: create PSP 'prevent-volume-policy' (only persistentVolumeClaim volumes),"
echo "    ClusterRole 'psp-role', and ClusterRoleBinding 'psp-role-binding' -> psp-sa."
echo "[+] Lab Setup Complete."
