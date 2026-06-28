#!/bin/bash
# LabSetUp.bash - Question 2: CIS Benchmark Fixes
set -e

echo "🔹 Checking kubelet config location..."
KUBELET_CONFIG=""
if [ -f /var/lib/kubelet/config.yaml ]; then
  KUBELET_CONFIG=/var/lib/kubelet/config.yaml
elif [ -f /etc/kubernetes/kubelet.conf ]; then
  KUBELET_CONFIG=/etc/kubernetes/kubelet.conf
fi

echo "📋 Kubelet config found at: ${KUBELET_CONFIG:-NOT FOUND}"
echo ""

echo "🔹 Introducing CIS violations for practice..."

# Modify kubelet to allow anonymous auth (simulate violation)
if [ -n "$KUBELET_CONFIG" ]; then
  # Backup original
  cp "$KUBELET_CONFIG" "${KUBELET_CONFIG}.bak.q07"
  
  # Check if anonymous section exists and modify
  if grep -q "anonymous:" "$KUBELET_CONFIG"; then
    sed -i 's/enabled: false/enabled: true/' "$KUBELET_CONFIG"
  fi
  echo "⚠️  Kubelet config modified to allow anonymous auth (simulated violation)"
fi

echo ""
echo "✅ Lab setup complete!"
echo ""
echo "📋 Your task:"
echo "   Fix CIS Benchmark violations in:"
echo "   1. /etc/kubernetes/manifests/kube-apiserver.yaml"
echo "   2. ${KUBELET_CONFIG:-/var/lib/kubelet/config.yaml}"
echo "   3. /etc/kubernetes/manifests/etcd.yaml"
echo ""
echo "📝 Run kube-bench to see current violations:"
echo "   which kube-bench && kube-bench run --targets=master 2>/dev/null | head -60"
echo "   or: kube-bench master 2>/dev/null | grep -E 'FAIL|WARN'"
