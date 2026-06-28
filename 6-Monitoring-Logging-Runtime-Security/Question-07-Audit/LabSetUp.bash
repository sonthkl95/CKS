#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace including --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace with --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace frontend --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace only --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /etc/kubernetes/manifests
cat << 'EOF_MOCK' > /etc/kubernetes/manifests/kube-apiserver.yaml
# /etc/audit/audit-policy.yamlapiVersion: audit.k8s.io/v1kind: Policyrules:  # 1. Log Node changes at RequestResponse level  - level: RequestResponse    resources:    - group: ""       # core API group      resources: ["nodes"]   # 2. Log PVC changes in 'frontend' namespace with request body  - level: Request    namespaces: ["frontend"]    resources:    - group: ""       # core API group      resources: ["persistentvolumeclaims"]   # Default rule from base policy -> do not log other requests  - level: None
EOF_MOCK
mkdir -p /etc/audit
cat << 'EOF_MOCK' > /etc/audit/audit-policy.yaml
# /etc/audit/audit-policy.yamlapiVersion: audit.k8s.io/v1kind: Policyrules:  # 1. Log Node changes at RequestResponse level  - level: RequestResponse    resources:    - group: ""       # core API group      resources: ["nodes"]   # 2. Log PVC changes in 'frontend' namespace with request body  - level: Request    namespaces: ["frontend"]    resources:    - group: ""       # core API group      resources: ["persistentvolumeclaims"]   # Default rule from base policy -> do not log other requests  - level: None
EOF_MOCK
echo "[+] Lab Setup Complete."