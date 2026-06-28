#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 3 - Question 9
=======================================================

Commands/Steps

Step 1: Retrieve existing CA certificate

```yaml
kubectl get secret default-token-xxxxx -n dev -o jsonpath='{.data.token}' | base64 -d > ca.crt
```

Step 2: Create new secret

```yaml
kubectl create secret generic app-config-secret \
--from-literal=APP_USER=appadmin \
--from-literal=APP_PASS=Sup3rS3cret \
-n app
```

Step 3: Deploy Pod

```yaml
# app-pod.yaml
apiVersion: v1
kind: Pod
metadata:
name: app-pod
namespace: app
spec:
containers:
- name: nginx
image: nginx
volumeMounts:
- name: app-config
mountPath: /etc/app-config
readOnly: true
volumes:
- name: app-config
secret:
secretName: app-config-secret
```

```yaml
kubectl apply -f app-pod.yaml
```

Verification Step:

```yaml
kubectl get pod app-pod -n app
kubectl describe pod app-pod -n app
kubectl exec -n app app-pod -- ls /etc/app-config
kubectl exec -n app app-pod -- cat /etc/app-config/APP_USER
kubectl exec -n app app-pod -- cat /etc/app-config/APP_PASS
```

'' Note:
Secrets are base64-encoded by default in Kubernetes. Treat the ca.crt file and credential data as sensitive information.

=======================================================
EOF
