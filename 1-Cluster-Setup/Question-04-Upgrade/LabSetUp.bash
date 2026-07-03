#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Scenario: worker node 'worker-1' runs v1.32.0, control plane is on v1.33.0."
echo "[+] This task requires a real 2-node kubeadm cluster (control-plane + worker-1)."
echo ""
kubectl get nodes -o wide 2>/dev/null || echo "    (run on a cluster to see node versions)"
echo ""
echo "[i] Nothing to pre-create. You will drain, upgrade kubeadm/kubelet/kubectl on worker-1,"
echo "    then uncordon it to match the control-plane version."
echo "[+] Lab Setup Complete."
