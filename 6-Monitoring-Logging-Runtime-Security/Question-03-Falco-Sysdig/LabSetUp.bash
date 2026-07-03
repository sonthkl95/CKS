#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Preparing the incidents output directory /opt/node-01/alerts ..."
mkdir -p /opt/node-01/alerts
echo "[+] Deploying a Pod that spawns processes to be detected..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata: { name: noisy-app, namespace: default }
spec:
  containers:
  - name: app
    image: ubuntu:22.04
    command: ["/bin/sh","-c","while true; do id; sleep 2; curl -s localhost || true; sleep 3; done"]
EOF
echo ""
echo "[!] NOTE: requires Falco (or sysdig) on the worker node."
echo "[i] Task: watch process-exec events for >=30s and write incidents to"
echo "    /opt/node-01/alerts/details as: timestamp,uid/username,processName"
echo "[+] Lab Setup Complete."
