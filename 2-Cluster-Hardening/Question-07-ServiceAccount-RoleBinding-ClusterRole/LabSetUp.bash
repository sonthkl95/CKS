#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'security'..."
kubectl create ns security --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating ServiceAccount 'sa-dev-1'..."
kubectl create sa sa-dev-1 -n security --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating the existing (overly broad) Role + RoleBinding for sa-dev-1..."
kubectl apply -f - <<'EOF'
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: role-1
  namespace: security
rules:
- apiGroups: [""]
  resources: ["services", "pods", "secrets"]
  verbs: ["get", "list", "watch", "create", "update", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: role-1-binding
  namespace: security
subjects:
- kind: ServiceAccount
  name: sa-dev-1
  namespace: security
roleRef:
  kind: Role
  name: role-1
  apiGroup: rbac.authorization.k8s.io
EOF
echo "[+] Creating Pod 'web-pod' that uses sa-dev-1..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
  namespace: security
spec:
  serviceAccountName: sa-dev-1
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF
echo ""
echo "[i] Task: restrict role-1 to only 'watch' on services; create ClusterRole 'role-2'"
echo "    (update on namespaces) and ClusterRoleBinding 'role-2-binding' -> sa-dev-1."
echo "[+] Lab Setup Complete."
