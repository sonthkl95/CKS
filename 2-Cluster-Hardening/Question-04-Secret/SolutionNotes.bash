#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 2 - Question 10
=======================================================

TLS Secrets allow Kubernetes Ingress to terminate SSL/TLS traffic. Annotations on the Ingress ensure HTTP traffic is redirected to HTTPS. The Pod is exposed via a Service to be reachable through the Ingress.

Commands / Steps:

```yaml
# Switch to root
sudo -i
# Create namespace
kubectl create namespace testing
# Create TLS secret
kubectl create secret tls bingo-tls --cert=bingo.crt --key=bingo.key -n testing
# Deploy Nginx Pod and expose port 80
kubectl run nginx-pod -n testing --image=nginx --expose=true --port=80
# Deploy NGINX Ingress Controller (example using cloud provider)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.0/deploy/static/provider/cloud/deploy.yaml
```

```yaml
# Generate ingress manifest with TLS and HTTP to HTTPS redirection
kubectl create ingress bingo-com \
--rule=bingo.com/=nginx-pod:80,tls=bingo-tls -n testing \
--annotation nginx.ingress.kubernetes.io/ssl-redirect="true" \
--annotation nginx.ingress.kubernetes.io/force-ssl-redirect="true" \
--dry-run=client -o yaml > bingo-ingress.yaml
# Edit ingress if necessary
vim bingo-ingress.yaml
```

```yaml
# bingo-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
name: bingo-com
namespace: testing
annotations:
nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
rules:
- host: bingo.com
http:
paths:
- path: /
pathType: Prefix
backend:
service:
name: nginx-pod
port:
number: 80
tls:
- hosts:
- bingo.com
secretName: bingo-tls
```

```yaml
# Apply the ingress
kubectl apply -f bingo-ingress.yaml
# Verify the service of the ingress controller
kubectl get svc -n ingress-nginx
```

Verification Step:
Confirm the Ingress is created and listening on TLS:

```yaml
kubectl get ingress -n testing
kubectl describe ingress bingo-com -n testing
```

Test redirection from HTTP to HTTPS:

```yaml
curl -I http://bingo.com
```

Verify TLS termination using the created Secret and that traffic reaches the nginx-pod.

=======================================================
EOF
