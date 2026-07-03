#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'database'..."
kubectl create ns database --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating ServiceAccount 'test-sa'..."
kubectl create sa test-sa -n database --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating the existing (overly broad) Role 'test-role' bound to test-sa..."
kubectl apply -f - <<'EOF'
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: test-role
  namespace: database
rules:
- apiGroups: [""]
  resources: ["pods", "secrets", "configmaps"]
  verbs: ["get", "list", "watch", "create", "update", "delete"]
- apiGroups: ["apps"]
  resources: ["deployments", "statefulsets"]
  verbs: ["get", "list", "create", "update", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: test-role-bind
  namespace: database
subjects:
- kind: ServiceAccount
  name: test-sa
  namespace: database
roleRef:
  kind: Role
  name: test-role
  apiGroup: rbac.authorization.k8s.io
EOF
echo "[+] Creating Pod 'web-pod' that uses test-sa..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
  namespace: database
spec:
  serviceAccountName: test-sa
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF
echo ""
echo "[i] Task: restrict 'test-role' to only 'get' on Pods; create Role 'test-role-2'"
echo "    (update on StatefulSets) and RoleBinding 'test-role-2-bind' -> test-sa."
echo "[+] Lab Setup Complete."
