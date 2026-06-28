#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 4 - Question 4
=======================================================

To allow a Pod to list Pods, we need a Role with get and list permissions on the Pod resource, then bind it to the ServiceAccount via a RoleBinding.
Mount the ServiceAccount in the Pod to allow it to inherit these permissions.

Commands / Steps

```yaml
# Create the ServiceAccount
kubectl create serviceaccount backend-sa -n default
# Create a Role with permission to list/get Pods
kubectl create role pod-reader --verb=list,get --resource=pods -n default
# Bind the Role to the ServiceAccount
kubectl create rolebinding pod-reader-binding --role=pod-reader --serviceaccount=default:backend-sa -n default
```

```yaml
# role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
name: pod-reader
namespace: default
rules:
- apiGroups: [""]
resources: ["pods"]
verbs: ["get", "list"]
---
# rolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
name: pod-reader-binding
namespace: default
subjects:
- kind: ServiceAccount
name: backend-sa
namespace: default
roleRef:
kind: Role
name: pod-reader
apiGroup: rbac.authorization.k8s.io
```

```yaml
# pod.yaml
apiVersion: v1
kind: Pod
metadata:
name: backend-pod
namespace: default
spec:
serviceAccountName: backend-sa
containers:
- name: busybox
image: bitnami/kubectl:latest
command:
- /bin/sh
- -c
- "kubectl get pods --namespace=default && sleep 3600"
```

```yaml
# Deploy the Pod
kubectl apply -f pod.yaml
# Verify Pod is running
kubectl get pod backend-pod -n default
# Exec into the Pod to confirm it can list Pods
kubectl exec -it backend-pod -n default -- sh -c "kubectl get pods -n default"
```

Verification Step:

```yaml
# The above exec command should output a list of Pods in the default namespace.
```

'' Note:
Using bitnami/kubectl image allows running kubectl commands directly inside the Pod.

Role and RoleBinding are namespace-scoped; no cluster-wide permissions are granted.

The sleep 3600 command keeps the Pod running for testing purposes.

=======================================================
EOF
