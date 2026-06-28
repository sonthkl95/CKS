#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace to --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace test --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /home/policy
cat << 'EOF_MOCK' > /home/policy/network-policy.yaml
apiVersion: networking.k8s.io/v1kind: NetworkPolicymetadata:  name: deny-network  namespace: testspec:  podSelector: {}  # Apply policy to all pods in the namespace  policyTypes:  - Ingress  - Egress
EOF_MOCK
echo "[+] Lab Setup Complete."