#!/bin/bash
# LabSetUp.bash - Question 3: Encryption at Rest
set -e

echo "🔹 Creating a test Secret (currently stored plaintext)..."
kubectl create secret generic test-secret \
  --from-literal=password=super-secret-password \
  --from-literal=username=admin \
  -n default --dry-run=client -o yaml | kubectl apply -f -

echo "🔹 Creating encryption config directory..."
mkdir -p /etc/kubernetes/enc

echo ""
echo "✅ Lab setup complete!"
echo ""
echo "📋 Current state:"
kubectl get secret test-secret -n default
echo ""
echo "⚠️  Verify secret is currently stored in plaintext in etcd:"
echo ""
echo "  ETCDCTL_API=3 etcdctl \\"
echo "    --cert /etc/kubernetes/pki/apiserver-etcd-client.crt \\"
echo "    --key /etc/kubernetes/pki/apiserver-etcd-client.key \\"
echo "    --cacert /etc/kubernetes/pki/etcd/ca.crt \\"
echo "    get /registry/secrets/default/test-secret | strings"
echo ""
echo "  (You should see 'super-secret-password' in plaintext)"
echo ""
echo "📋 Your task: Enable encryption at rest so this is no longer visible!"
