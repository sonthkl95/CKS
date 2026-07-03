#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'secure-team' with Pod Security Admission = restricted..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Namespace
metadata:
  name: secure-team
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/enforce-version: latest
EOF
echo "[+] Writing the failing Deployment manifest at /home/masters/insecure-deployment.yaml..."
mkdir -p /home/masters
cat > /home/masters/insecure-deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  namespace: secure-team
spec:
  replicas: 1
  selector: { matchLabels: { app: webapp } }
  template:
    metadata: { labels: { app: webapp } }
    spec:
      containers:
      - name: webapp
        image: nginx:1.23
        ports: [{ containerPort: 80 }]
        securityContext:
          privileged: true
          runAsUser: 0
          capabilities:
            add: ["NET_ADMIN"]
        volumeMounts:
        - { mountPath: /data, name: host-data }
      volumes:
      - name: host-data
        hostPath: { path: /tmp }
EOF
echo ""
echo "[i] Task: edit the manifest so it satisfies the 'restricted' PSS and runs in 'secure-team'."
echo "[+] Lab Setup Complete."
