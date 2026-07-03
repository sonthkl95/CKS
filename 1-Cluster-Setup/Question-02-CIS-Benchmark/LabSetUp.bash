#!/bin/bash
# LabSetUp.bash - Question 2: CIS Benchmark Fixes
set -e

echo "🔹 Installing kube-bench if not present..."
if ! command -v kube-bench &> /dev/null; then
  echo "   Downloading and installing kube-bench..."
  KUBE_BENCH_VERSION="0.6.17"
  cd /tmp
  curl -s -L -O "https://github.com/aquasecurity/kube-bench/releases/download/v${KUBE_BENCH_VERSION}/kube-bench_${KUBE_BENCH_VERSION}_linux_amd64.tar.gz"
  tar -xzf kube-bench_${KUBE_BENCH_VERSION}_linux_amd64.tar.gz
  sudo mv kube-bench /usr/local/bin/
  sudo mkdir -p /etc/kube-bench
  sudo cp -r cfg /etc/kube-bench/
  rm -f kube-bench_${KUBE_BENCH_VERSION}_linux_amd64.tar.gz
  cd - > /dev/null
  echo "✅ kube-bench installed successfully."
else
  echo "✅ kube-bench is already installed."
fi
echo ""

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
