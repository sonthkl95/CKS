#!/bin/bash
# LabSetUp.bash - Question 2: Seccomp Profile Enforcement
set -e

echo "🔹 Creating namespace 'secure-app'..."
kubectl create ns secure-app --dry-run=client -o yaml | kubectl apply -f -

echo "🔹 Creating webapp Deployment in secure-app namespace..."
kubectl apply -f - << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  namespace: secure-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      # TODO: Add seccompProfile here under securityContext
      containers:
      - name: nginx
        image: nginx:1.25-alpine
        ports:
        - containerPort: 80
EOF

echo "🔹 Creating seccomp profiles directory on node..."
mkdir -p /var/lib/kubelet/seccomp/profiles

echo ""
echo "✅ Lab setup complete!"
kubectl get pods -n secure-app
echo ""
echo "📋 Your task:"
echo "   1. Create /var/lib/kubelet/seccomp/profiles/custom-profile.json"
echo "   2. Edit the Deployment 'webapp' to use this Seccomp profile"
echo ""
echo "💡 Hint - Seccomp JSON structure:"
echo '   {"defaultAction":"SCMP_ACT_ERRNO","syscalls":[{"names":["read","write","exit","sigreturn"],"action":"SCMP_ACT_ALLOW"}]}'
