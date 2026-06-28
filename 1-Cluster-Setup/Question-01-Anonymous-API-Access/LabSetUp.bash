#!/bin/bash
# LabSetUp.bash - Question 1: Anonymous API Server Access
set -e

echo "🔹 Creating anonymous ClusterRoleBinding (simulates misconfiguration)..."
kubectl apply -f - << 'EOF'
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: anonymous-cluster-admin
subjects:
- kind: User
  name: system:anonymous
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
EOF

echo ""
echo "⚠️  IMPORTANT: To fully simulate the misconfiguration, you would also"
echo "   add '--anonymous-auth=true' to the API server manifest."
echo "   However, since that requires restarting the API server,"
echo "   in this lab we only create the insecure ClusterRoleBinding."
echo ""
echo "📋 Your task:"
echo "   1. Check and fix kube-apiserver.yaml (authorization-mode, anonymous-auth)"
echo "   2. Delete the 'anonymous-cluster-admin' ClusterRoleBinding"
echo ""
echo "✅ Lab setup complete - ClusterRoleBinding created."
kubectl get clusterrolebinding anonymous-cluster-admin
