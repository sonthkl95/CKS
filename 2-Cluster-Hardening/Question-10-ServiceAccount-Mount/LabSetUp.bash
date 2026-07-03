#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'qa'..."
kubectl create ns qa --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating some unused ServiceAccounts to clean up later..."
for sa in old-sa temp-sa frontend; do
  kubectl create sa "$sa" -n qa --dry-run=client -o yaml | kubectl apply -f -
done
echo "[+] Writing the Pod manifest at /home/candidate/11/pod-manifest.yaml..."
mkdir -p /home/candidate/11
cat > /home/candidate/11/pod-manifest.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  namespace: qa
  labels:
    run: frontend
spec:
  serviceAccountName: frontend-sa   # <-- does not exist yet
  containers:
  - name: frontend
    image: nginx:1.25-alpine
EOF
echo ""
echo "[i] Task: create SA 'frontend-sa' (automount off) in ns 'qa', apply the manifest,"
echo "    and delete unused ServiceAccounts."
echo "[+] Lab Setup Complete."
