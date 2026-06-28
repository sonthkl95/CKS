#!/bin/bash
# LabSetUp.bash - Question 2: Trivy Image Scanning
set -e

echo "🔹 Checking if Trivy is installed..."
if ! command -v trivy &>/dev/null; then
  echo "📦 Installing Trivy..."
  # Install trivy for Ubuntu/Debian
  apt-get update -qq && apt-get install -y wget apt-transport-https gnupg lsb-release
  wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | apt-key add -
  echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | \
    tee /etc/apt/sources.list.d/trivy.list
  apt-get update -qq && apt-get install -y trivy
  echo "✅ Trivy installed: $(trivy --version)"
else
  echo "✅ Trivy already installed: $(trivy --version | head -1)"
fi

echo ""
echo "🔹 Updating Trivy vulnerability database..."
trivy image --download-db-only 2>/dev/null || echo "(DB will auto-update on first scan)"

echo ""
echo "🔹 Creating output directory..."
mkdir -p /opt

echo ""
echo "✅ Lab setup complete!"
echo ""
echo "📋 Your task: Scan these images with severity HIGH,CRITICAL:"
echo "   - ubuntu:18.04"
echo "   - registry.k8s.io/kube-apiserver:v1.24.0"
echo "   - registry.k8s.io/kube-scheduler:v1.23.0"
echo "   - postgres:12"
echo "   - httpd:2.4.49"
echo ""
echo "💾 Save all results to: /opt/trivy-vulnerable.txt"
