#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'team-dev'..."
kubectl create ns team-dev --dry-run=client -o yaml | kubectl apply -f -
echo ""
echo "[!] NOTE: this task requires a cluster with Cilium as the CNI (CiliumNetworkPolicy CRD)."
echo "[+] Creating the existing 'default-allow' CiliumNetworkPolicy (if the CRD exists)..."
kubectl apply -f - <<'EOF' 2>/dev/null || echo "    (CiliumNetworkPolicy CRD not present — install Cilium)"
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: default-allow
  namespace: team-dev
spec:
  endpointSelector: {}
  ingress:
  - fromEndpoints: [{}]
  egress:
  - toEndpoints: [{}]
  - toEndpoints:
    - matchLabels:
        k8s:io.kubernetes.pod.namespace: kube-system
        k8s-app: kube-dns
EOF
echo ""
echo "[i] Task: create CiliumNetworkPolicies 'team-dev' (mutual auth db->api-service) and"
echo "    'team-dev-2' (deny ICMP egress from Deployment 'stuff' to Service 'backend')."
echo "[+] Lab Setup Complete."
