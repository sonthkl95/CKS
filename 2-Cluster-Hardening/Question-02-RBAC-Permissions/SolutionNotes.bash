#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 3 - Question 14
=======================================================

Overly permissive roles can lead to security risks.
Restricting actions to the minimal required permissions least privilege ensures safer operation.
Existing Role is restricted to get on Pods, and a separate Role handles updates to StatefulSets.

Commands / Steps

```yaml
# Inspect existing RoleBindings for the ServiceAccount
kubectl get rolebindings -n database --output wide | grep test-sa
# Edit existing Role to limit it to 'get' on Pods
kubectl edit role test-role -n database
```

```yaml
rules:
- apiGroups: [""]
resources: ["pods"]
verbs: ["get"]
```

```yaml
# Create a new Role allowing 'update' only on StatefulSets
kubectl create role -n test-role-2 --verb=update --resource=statefulsets -n database
# OR
cat <<E O F | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
name: test-role-2
namespace: database
rules:
- apiGroups: ["apps"]
resources: ["statefulsets"]
verbs: ["update"]
E O F
```

```yaml
# Create a RoleBinding to bind the new Role to the ServiceAccount
kubectl create rolebinding test-role-2-bind --role=test-role-2 --serviceaccount=database:test-sa -n database
# OR
cat <<E O F | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
name: test-role-2-bind
namespace: database
subjects:
- kind: ServiceAccount
name: test-sa
namespace: database
roleRef:
kind: Role
name: test-role-2
apiGroup: rbac.authorization.k8s.io
E O F
```

Verification Step:

```yaml
# Verify existing Role is limited to get Pods
kubectl get role test-role -n database -o yaml
# Verify new Role and RoleBinding exist
kubectl get role test-role-2 -n database -o yaml
kubectl get rolebinding test-role-2-bind -n database -o yaml
```

'' Note:
Existing Role is restricted to get on Pods; no deletions are required.

New Role handles updates to StatefulSets.

Always follow principle of least privilege when modifying roles.

=======================================================
EOF
