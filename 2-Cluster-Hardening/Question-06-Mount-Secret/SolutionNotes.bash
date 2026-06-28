#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 2 - Question 12
=======================================================

1. Extract existing secret values

```yaml
# Extract username into file
kubectl get secret admin -n safe \
-o jsonpath='{.data.username}' | base64 -d \
> /home/cert-masters/username.txt
# Extract password into file
kubectl get secret admin -n safe \
-o jsonpath='{.data.password}' | base64 -d \
> /home/cert-masters/password.txt
```

2. Create new secret

```yaml
kubectl create secret generic newsecret \
--from-literal=username=dbadmin \
--from-literal=password=moresecurepas \
-n safe
# Verify secret
kubectl get secret newsecret -n safe -o yaml
```

3. Create Pod manifest using the secret

```yaml
# pod-secret.yaml
apiVersion: v1
kind: Pod
metadata:
name: mysecret-pod
namespace: safe
spec:
containers:
- name: db-container
image: redis
volumeMounts:
- name: secret-vol
mountPath: /etc/mysecret
readOnly: true
volumes:
- name: secret-vol
secret:
secretName: newsecret
```

```yaml
kubectl apply -f pod-secret.yaml
```

Verification Step:
Check created files

```yaml
cat /home/cert-masters/username.txt
cat /home/cert-masters/password.txt
```

Check pod status

```yaml
kubectl get pods -n safe
```

Check mounted secret

```yaml
kubectl exec -it mysecret-pod -n safe -- ls /etc/mysecret
kubectl exec -it mysecret-pod -n safe -- cat /etc/mysecret/username
kubectl exec -it mysecret-pod -n safe -- cat /etc/mysecret/password
```

=======================================================
EOF
