#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 1 - Question 3
=======================================================

Step 1: Disable auto-mount for the default ServiceAccount

```yaml
kubectl patch sa default -n default -p '{"automountServiceAccountToken": false}'
```

Or edit directly

```yaml
kubectl edit sa default -n default
```

```yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
name: default
namespace: default
automountServiceAccountToken: false  # add this line
```

Step 2: Create a Secret of type kubernetes.io/service-account-token that references the default ServiceAccount

```yaml
# default-sa-token.yaml
---
apiVersion: v1
kind: Secret
metadata:
name: default-sa-token
annotations:
kubernetes.io/service-account.name: "default"
type: kubernetes.io/service-account-token
```

```yaml
kubectl apply -f default-sa-token.yaml
```

```yaml
# Check that Kubernetes automatically injects the token
kubectl get secret default-sa-token -o jsonpath='{.data.token}' | base64 -d -w 0
```

Step 3: Edit the Pod to mount the Secret

```yaml
---
apiVersion: v1
kind: Pod
metadata:
name: nginx-pod
namespace: default
spec:
serviceAccountName: default
automountServiceAccountToken: false
containers:
- name: nginx
image: nginx
volumeMounts:
- name: token-vol
mountPath: /var/run/secrets/kubernetes.io/serviceaccount/
readOnly: true
volumes:
- name: token-vol
secret:
secretName: default-sa-token
```

Step 4: Verify inside the Pod

```yaml
kubectl exec -it nginx-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
```

Explanation:
ServiceAccount default is disabled from auto-mounting tokens (automountServiceAccountToken: false)

Created a Secret of type kubernetes.io/service-account-token that references the default ServiceAccount, auto-populated by kubelet

Pod nginx-pod manually mounts token from Secret instead of projected volume

Token type kubernetes.io/service-account-token is a long-lived legacy token (unlike projected tokens which are short-lived)

=======================================================
EOF
