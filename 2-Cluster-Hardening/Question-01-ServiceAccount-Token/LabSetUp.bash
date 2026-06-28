#!/bin/bash
# LabSetUp.bash - Question 1: ServiceAccount Token Security
set -e

echo "🔹 Creating nginx-pod in default namespace..."
kubectl apply -f - << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  namespace: default
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF

echo "🔹 Creating manifest directory..."
mkdir -p /home/candidate/03

echo "🔹 Writing initial Pod manifest..."
cat > /home/candidate/03/nginx-pod.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  namespace: default
spec:
  serviceAccountName: default
  # TODO: Set automountServiceAccountToken: false
  containers:
  - name: nginx
    image: nginx:1.25-alpine
    # TODO: Add volumeMount for the SA token Secret
EOF

echo ""
echo "✅ Lab setup complete!"
echo "📋 Pod 'nginx-pod' is running in 'default' namespace."
echo "📁 Manifest at: /home/candidate/03/nginx-pod.yaml"
echo ""
echo "Verify default SA auto-mount is currently ON:"
kubectl get serviceaccount default -o yaml | grep automount
