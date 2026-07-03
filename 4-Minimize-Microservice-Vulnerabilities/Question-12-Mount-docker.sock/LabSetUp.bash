#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'ci-cd'..."
kubectl create ns ci-cd --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Deploying a Pod that mounts /var/run/docker.sock..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata: { name: ci-runner, namespace: ci-cd }
spec:
  containers:
  - name: runner
    image: docker:24
    command: ["sleep", "infinity"]
    volumeMounts:
    - { name: docker-sock, mountPath: /var/run/docker.sock }
  volumes:
  - name: docker-sock
    hostPath: { path: /var/run/docker.sock }
EOF
echo ""
echo "[i] Task: restrict access to docker.sock (ownership + chmod) without breaking CI jobs."
kubectl get pods -n ci-cd
echo "[+] Lab Setup Complete."
