#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'test'..."
kubectl create ns test --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Writing the skeleton NetworkPolicy at /home/policy/network-policy.yaml..."
mkdir -p /home/policy
cat > /home/policy/network-policy.yaml <<'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-network
  namespace: test
spec:
  podSelector: {}
  # TODO: add policyTypes Ingress + Egress to block all traffic
EOF
echo ""
echo "[i] Task: complete the policy so it denies all ingress and egress for every pod in ns 'test'."
echo "[+] Lab Setup Complete."
