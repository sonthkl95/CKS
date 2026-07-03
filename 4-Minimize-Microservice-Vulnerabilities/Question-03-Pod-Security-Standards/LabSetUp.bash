#!/bin/bash
# LabSetUp.bash - Question 3: Pod Security Standards
set -e

echo "🔹 Creating namespace 'team-blue'..."
kubectl create ns team-blue --dry-run=client -o yaml | kubectl apply -f -

echo "🔹 Deploying privileged-runner Deployment (violates PSA restricted)..."
kubectl apply -f - << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: privileged-runner
  namespace: team-blue
spec:
  replicas: 1
  selector:
    matchLabels:
      app: privileged-runner
  template:
    metadata:
      labels:
        app: privileged-runner
    spec:
      containers:
      - name: runner
        image: ubuntu:22.04
        command: ["sleep", "infinity"]
        securityContext:
          privileged: true         # ← This will violate PSA restricted
          runAsUser: 0
EOF

echo "🔹 Creating output directory..."
mkdir -p /opt/candidate/16

echo ""
echo "✅ Lab setup complete!"
kubectl get pods -n team-blue
echo ""
echo "📋 Your task:"
echo "   1. Label namespace 'team-blue' to enforce PSA 'restricted'"
echo "   2. Delete the pod from 'privileged-runner' Deployment"
echo "   3. Observe events showing pod cannot be recreated"
echo "   4. Write events to /opt/candidate/16/logs"
