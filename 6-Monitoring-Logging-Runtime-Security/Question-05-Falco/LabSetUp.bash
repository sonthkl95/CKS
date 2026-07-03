#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Deploying the single-container Pod 'tomcat' to monitor..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata: { name: tomcat, namespace: default }
spec:
  containers:
  - name: tomcat
    image: tomcat:9.0
EOF
echo "[+] Preparing the report directory /home/anomalous ..."
mkdir -p /home/anomalous
echo ""
echo "[!] NOTE: requires Falco (or sysdig) on the worker node."
echo "[i] Task: monitor the 'tomcat' Pod for >=40s and write incidents to"
echo "    /home/anomalous/report as: [timestamp],[uid],[processName]"
echo "[+] Lab Setup Complete."
