#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 2, Question 14
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 2  ·  Question 14
===============================================================

Step 1: Identify the Role bound to ServiceAccount

```bash
kubectl get rolebindings -n security -o yaml \
| grep sa-dev-1 -B 20 | grep -i roleref -A 3

kubectl get rolebindings -n security -o wide | grep sa-dev-1
```

Step 2: Edit the existing Role (example: role-1)

```bash
kubectl edit role role-1 -n security
```

```bash
rules:
- apiGroups: [""]
  resources: ["services"]
  verbs: ["watch"]
```

Step 3: Create a new ClusterRole

```bash
kubectl create clusterrole role-2 --verb=update --resource=namespaces
```

```bash
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: role-2
rules:
- apiGroups: [""]
  resources: ["namespaces"]
  verbs: ["update"]
```

Step 4: Create ClusterRoleBinding

```bash
kubectl create clusterrolebinding role-2-binding \
  --clusterrole=role-2 \
  --serviceaccount=security:sa-dev-1
```

```bash
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: role-2-binding
subjects:
- kind: ServiceAccount
  name: sa-dev-1
  namespace: security
roleRef:
  kind: ClusterRole
  name: role-2
  apiGroup: rbac.authorization.k8s.io
```

Verification Step:

```bash
# Check Role permissions
kubectl auth can-i watch services \
--as=system:serviceaccount:security:sa-dev-1 -n security

# Check ClusterRole permissions
kubectl auth can-i update namespaces \
--as=system:serviceaccount:security:sa-dev-1
```

Expected:

ServiceAccount `sa-dev-1` can `watch` services in namespace `security`.

ServiceAccount `sa-dev-1` can `update` namespaces `cluster-wide`.

===============================================================
CKS_SOLUTION_EOF
