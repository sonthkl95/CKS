#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating ServiceAccount 'psp-sa' in the 'default' namespace..."
kubectl create sa psp-sa -n default --dry-run=client -o yaml | kubectl apply -f -
echo ""
echo "[!] NOTE: PodSecurityPolicy was removed in Kubernetes v1.25. On newer clusters use"
echo "    Pod Security Admission or a policy engine for the same intent."
echo ""
echo "[i] Task: create PSP 'prevent-privileged-policy', ClusterRole 'prevent-role', and"
echo "    ClusterRoleBinding 'prevent-role-binding' -> psp-sa; verify a privileged Pod is blocked."
echo "[+] Lab Setup Complete."
