#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 3 - Question 6
=======================================================

By creating a service account without secret permissions and binding it to the Pod, we ensure the Pod cannot read secrets while still being able to access its own Pod resources.

Commands / Steps

```yaml
# Create the service account
kubectl create serviceaccount backend-qa -n qa
# Create a Role that allows only pod access (no secret access)
kubectl create role no-secret-access -n qa --verb=get,list --resource=pods
# deny-secrets-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
name: no-secret-access
namespace: qa
rules:
# Only allow access to pods
- apiGroups: [""]
resources: ["pods"]
verbs: ["get", "list"]
```

```yaml
# Bind the Role to the service account
kubectl create rolebinding backend-qa-nosecret --role=no-secret-access --serviceaccount=qa:backend-qa -n qa
# Edit the frontend Pod manifest to use the new service account
vim /home/pod-manifest/frontend-pod.yaml
```

```yaml
# /home/cert_masters/frontend-pod.yaml
apiVersion: v1
kind: Pod
metadata:
name: frontend
namespace: qa
spec:
serviceAccountName: backend-qa       # Use the restricted service account
containers:
- name: frontend
image: nginx
```

```yaml
# Apply the updated Pod manifest
kubectl apply -f /home/cert_masters/frontend-pod.yaml
# Verify the service account is assigned
kubectl get pod frontend -n qa -o jsonpath='{.spec.serviceAccountName}'
# Test secret access for the service account (should be denied)
kubectl auth can-i list secrets --as=system:serviceaccount:qa:backend-qa -n qa
```

Verification Step:
The Pod should be running using the backend-qa service account.

The command kubectl auth can-i list secrets --as=system:serviceaccount:qa:backend-qa -n qa must return no

Ensures least privilege: backend-qa can only interact with Pods, no access to secrets.

Any existing RoleBindings that grant secret access to this service account must be removed.

This approach maintains namespace isolation while restricting sensitive operations.

=======================================================
EOF
