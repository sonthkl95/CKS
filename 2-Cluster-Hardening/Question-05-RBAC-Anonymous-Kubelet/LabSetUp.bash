#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] This task fixes kube-bench (CIS) findings on the control-plane node."
echo "[+] Installing kube-bench (if missing)..."
if ! command -v kube-bench >/dev/null 2>&1; then
  VER="0.6.17"
  ( cd /tmp && curl -sL -O "https://github.com/aquasecurity/kube-bench/releases/download/v${VER}/kube-bench_${VER}_linux_amd64.tar.gz" \
    && tar -xzf "kube-bench_${VER}_linux_amd64.tar.gz" && sudo mv kube-bench /usr/local/bin/ \
    && sudo mkdir -p /etc/kube-bench && sudo cp -r cfg /etc/kube-bench/ ) 2>/dev/null \
    && echo "    kube-bench installed" || echo "    (could not auto-install kube-bench)"
else
  echo "    kube-bench already installed"
fi
echo ""
echo "[i] Fix findings in:"
echo "    - /etc/kubernetes/manifests/kube-apiserver.yaml  (RotateKubeletServerCertificate, PodSecurityPolicy, --kubelet-certificate-authority)"
echo "    - /var/lib/kubelet/config.yaml                   (anonymous auth off, authorization Webhook)"
echo "    - /etc/kubernetes/manifests/etcd.yaml            (--auto-tls=false, --peer-auto-tls=false)"
echo "[+] Lab Setup Complete."
