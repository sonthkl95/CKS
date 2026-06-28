#!/bin/bash
# LabSetUp.bash - Question 2: RBAC
set -e

echo "🔹 Creating namespace 'database'..."
kubectl create ns database --dry-run=client -o yaml | kubectl apply -f -

echo "🔹 Creating ServiceAccount 'db-sa'..."
kubectl create sa db-sa -n database --dry-run=client -o yaml | kubectl apply -f -

echo "🔹 Creating overly broad Role..."
kubectl apply -f - << 'EOF'
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: db-role
  namespace: database
rules:
- apiGroups: [""]
  resources: ["pods", "secrets", "configmaps"]
  verbs: ["*"]
EOF

echo "🔹 Binding Role to ServiceAccount..."
kubectl create rolebinding db-role-bind \
  --role=db-role \
  --serviceaccount=database:db-sa \
  -n database --dry-run=client -o yaml | kubectl apply -f -

echo "🔹 Deploying Pod..."
kubectl apply -f - << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: db-pod
  namespace: database
spec:
  serviceAccountName: db-sa
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF

echo ""
echo "✅ Lab setup complete!"
echo "📋 ServiceAccount 'db-sa' currently has full access to pods, secrets, configmaps."
echo "📋 Your task: Restrict 'db-role' to only 'get pods', and create a new Role for 'update statefulsets'."
