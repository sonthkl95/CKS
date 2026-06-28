#!/bin/bash
# LabSetUp.bash - Question 2: RuntimeClass with gVisor
set -e

echo "🔹 Creating namespace 'server'..."
kubectl create ns server --dry-run=client -o yaml | kubectl apply -f -

echo "🔹 Deploying Pods in 'server' namespace..."
kubectl apply -f - << 'EOF'
---
apiVersion: v1
kind: Pod
metadata:
  name: api-pod
  namespace: server
  labels:
    app: api
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
---
apiVersion: v1
kind: Pod
metadata:
  name: worker-pod
  namespace: server
  labels:
    app: worker
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF

echo "🔹 Creating manifest directory..."
mkdir -p /home/candidate/10

echo ""
echo "⚠️  NOTE: gVisor (runsc) may not be installed in this Killercoda environment."
echo "   If 'runsc' is not available, this is a manifest-only exercise."
echo ""
echo "✅ Lab setup complete!"
echo ""
kubectl get pods -n server
echo ""
echo "📋 Your task:"
echo "   1. Create /home/candidate/10/runtime-class.yaml with RuntimeClass 'sandboxed'"
echo "   2. Apply it: kubectl apply -f /home/candidate/10/runtime-class.yaml"
echo "   3. Update all Pods in 'server' namespace to use runtimeClassName: sandboxed"
