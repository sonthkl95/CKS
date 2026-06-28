#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace 5 --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /etc/kubernetes/manifests
cat << 'EOF_MOCK' > /etc/kubernetes/manifests/kube-apiserver.yaml
# /var/lib/kubelet/config.yamlapiVersion: kubelet.config.k8s.io/v1beta1kind: KubeletConfigurationauthentication:  anonymous:    enabled: false          # '-> Disable anonymous auth  webhook:    enabled: true           # -> Enable API server webhook  x509:    clientCAFile: /etc/kubernetes/pki/ca.crtauthorization:  mode: Webhook             # '-> Use centralized authorization
EOF_MOCK
mkdir -p /var/lib/kubelet
cat << 'EOF_MOCK' > /var/lib/kubelet/config.yaml
# /var/lib/kubelet/config.yamlapiVersion: kubelet.config.k8s.io/v1beta1kind: KubeletConfigurationauthentication:  anonymous:    enabled: false          # '-> Disable anonymous auth  webhook:    enabled: true           # -> Enable API server webhook  x509:    clientCAFile: /etc/kubernetes/pki/ca.crtauthorization:  mode: Webhook             # '-> Use centralized authorization
EOF_MOCK
mkdir -p /etc/kubernetes/manifests
cat << 'EOF_MOCK' > /etc/kubernetes/manifests/etcd.yaml
# /var/lib/kubelet/config.yamlapiVersion: kubelet.config.k8s.io/v1beta1kind: KubeletConfigurationauthentication:  anonymous:    enabled: false          # '-> Disable anonymous auth  webhook:    enabled: true           # -> Enable API server webhook  x509:    clientCAFile: /etc/kubernetes/pki/ca.crtauthorization:  mode: Webhook             # '-> Use centralized authorization
EOF_MOCK
echo "[+] Lab Setup Complete."