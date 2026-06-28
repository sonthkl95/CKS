#!/bin/bash
# LabSetUp.bash - Question 1: NetworkPolicy - Deny All
set -e

echo "🔹 Creating namespace 'testing'..."
kubectl create ns testing --dry-run=client -o yaml | kubectl apply -f -

echo "🔹 Deploying test Pods..."
kubectl apply -f - << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  namespace: testing
  labels:
    app: frontend
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
---
apiVersion: v1
kind: Pod
metadata:
  name: backend
  namespace: testing
  labels:
    app: backend
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF

echo "🔹 Creating manifest directory..."
mkdir -p /home/candidate/02

echo ""
echo "✅ Lab setup complete! Two pods are running in 'testing' namespace."
echo "   - frontend"
echo "   - backend"
echo ""
echo "📋 Your task: Create a NetworkPolicy 'deny-all' that isolates all Pods."
echo "📁 Save manifest at: /home/candidate/02/deny-all.yaml"
