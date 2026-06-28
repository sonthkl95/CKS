#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace ingress-nginx --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace testingkubectl --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace testing --dry-run=client -o yaml | kubectl apply -f -
mkdir -p //raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.0/deploy/static/provider/cloud
cat << 'EOF_MOCK' > //raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.0/deploy/static/provider/cloud/deploy.yaml
# bingo-ingress.yamlapiVersion: networking.k8s.io/v1kind: Ingressmetadata:  name: bingo-com  namespace: testing  annotations:    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"    nginx.ingress.kubernetes.io/ssl-redirect: "true"spec:  rules:  - host: bingo.com    http:      paths:      - path: /        pathType: Prefix        backend:          service:            name: nginx-pod            port:              number: 80  tls:  - hosts:    - bingo.com    secretName: bingo-tls
EOF_MOCK
echo "[+] Lab Setup Complete."