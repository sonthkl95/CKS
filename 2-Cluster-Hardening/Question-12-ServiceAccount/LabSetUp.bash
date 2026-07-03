#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] This task works in the 'default' namespace (already present)."
echo ""
echo "[i] Task: create SA 'backend-sa' that can list Pods, deploy Pod 'backend-pod'"
echo "    using it, and verify it can list all Pods in 'default'."
kubectl get ns default
echo "[+] Lab Setup Complete."
