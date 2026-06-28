#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 2 - Question 14
=======================================================

Step 1: Identify the Role bound to ServiceAccount

```yaml
kubectl get rolebindings -n security -o yaml \
| grep sa-dev-1 -B 20 | grep -i roleref -A 3
kubectl get rolebindings -n security -o wide | grep sa-dev-1
```

Step 2: Edit the existing Role (example: role-1)

```yaml
kubectl edit role role-1 -n security
```

```yaml
rules:
- apiGroups: [""]
resources: ["services"]
verbs: ["watch"]
```

Step 3: Create a new ClusterRole

```yaml
kubectl create clusterrole role-2 --verb=update --resource=namespaces
```

```yaml
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

```yaml
kubectl create clusterrolebinding role-2-binding \
--clusterrole=role-2 \
--serviceaccount=security:sa-dev-1
```

```yaml
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

```yaml
# Check Role permissions
kubectl auth can-i watch services \
--as=system:serviceaccount:security:sa-dev-1 -n security
# Check ClusterRole permissions
kubectl auth can-i update namespaces \
--as=system:serviceaccount:security:sa-dev-1
```

Expected:
ServiceAccount sa-dev-1 can watch services in namespace security.

ServiceAccount sa-dev-1 can update namespaces cluster-wide.

=======================================================
EOF
