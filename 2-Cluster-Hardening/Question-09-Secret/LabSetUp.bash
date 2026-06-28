#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace isolation --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace qa --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace that --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /home/cert_masters
cat << 'EOF_MOCK' > /home/cert_masters/frontend-pod.yaml
# Create the service accountkubectl create serviceaccount backend-qa -n qa # Create a Role that allows only pod access (no secret access)kubectl create role no-secret-access -n qa --verb=get,list --resource=pods # deny-secrets-role.yamlapiVersion: rbac.authorization.k8s.io/v1kind: Rolemetadata:  name: no-secret-access  namespace: qarules:  # Only allow access to pods  - apiGroups: [""]    resources: ["pods"]    verbs: ["get", "list"]
EOF_MOCK
mkdir -p /home/pod-manifest
cat << 'EOF_MOCK' > /home/pod-manifest/frontend-pod.yaml
# Create the service accountkubectl create serviceaccount backend-qa -n qa # Create a Role that allows only pod access (no secret access)kubectl create role no-secret-access -n qa --verb=get,list --resource=pods # deny-secrets-role.yamlapiVersion: rbac.authorization.k8s.io/v1kind: Rolemetadata:  name: no-secret-access  namespace: qarules:  # Only allow access to pods  - apiGroups: [""]    resources: ["pods"]    verbs: ["get", "list"]
EOF_MOCK
echo "[+] Lab Setup Complete."