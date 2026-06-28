#!/bin/bash
# LabSetUp.bash - Question 2: Falco Runtime Threat Detection
set -e

echo "🔹 Creating namespace 'monitoring'..."
kubectl create ns monitoring --dry-run=client -o yaml | kubectl apply -f -

echo "🔹 Deploying a 'malicious' pod that accesses /dev/mem..."
kubectl apply -f - << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: evil-miner
  namespace: monitoring
  labels:
    app: evil-miner
spec:
  replicas: 1
  selector:
    matchLabels:
      app: evil-miner
  template:
    metadata:
      labels:
        app: evil-miner
    spec:
      containers:
      - name: evil-container
        image: ubuntu:22.04
        command:
        - /bin/sh
        - -c
        - |
          while true; do
            # Simulate /dev/mem access attempt
            cat /dev/mem 2>/dev/null || true
            sleep 10
          done
        securityContext:
          privileged: true
EOF

echo "🔹 Deploying some legitimate Pods too..."
kubectl apply -f - << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-frontend
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:1.25-alpine
EOF

echo ""
echo "⚠️  FALCO NOTE: Falco may not be pre-installed in Killercoda."
echo "   If Falco is available: falco &"
echo "   Alternative: use sysdig or audit logs to detect /dev/mem access."
echo ""
echo "✅ Lab setup complete!"
kubectl get pods -n monitoring
echo ""
echo "📋 Your task: Identify which Deployment is accessing /dev/mem and scale it to 0."
