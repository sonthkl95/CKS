#!/bin/bash
echo "[+] Initializing Lab Environment..."
mkdir -p /etc/kubernetes/manifests
cat << 'EOF_MOCK' > /etc/kubernetes/manifests/kube-apiserver.yaml
---apiVersion: apiserver.config.k8s.io/v1kind: AdmissionConfigurationplugins:  - name: ImagePolicyWebhook    path: /etc/kubernetes/imgconfig/imgepolicyconfig.yaml ---# the path should be the absolute path not just imagepolicyconfig.yaml
EOF_MOCK
mkdir -p /etc/kubernetes/imgconfig
cat << 'EOF_MOCK' > /etc/kubernetes/imgconfig/imgepolicyconfig.yaml
---apiVersion: apiserver.config.k8s.io/v1kind: AdmissionConfigurationplugins:  - name: ImagePolicyWebhook    path: /etc/kubernetes/imgconfig/imgepolicyconfig.yaml ---# the path should be the absolute path not just imagepolicyconfig.yaml
EOF_MOCK
mkdir -p /root/16
cat << 'EOF_MOCK' > /root/16/vulnerable-resource.yaml
---apiVersion: apiserver.config.k8s.io/v1kind: AdmissionConfigurationplugins:  - name: ImagePolicyWebhook    path: /etc/kubernetes/imgconfig/imgepolicyconfig.yaml ---# the path should be the absolute path not just imagepolicyconfig.yaml
EOF_MOCK
mkdir -p /etc/kubernetes/imgconfig
cat << 'EOF_MOCK' > /etc/kubernetes/imgconfig/admission_configuration.yaml
---apiVersion: apiserver.config.k8s.io/v1kind: AdmissionConfigurationplugins:  - name: ImagePolicyWebhook    path: /etc/kubernetes/imgconfig/imgepolicyconfig.yaml ---# the path should be the absolute path not just imagepolicyconfig.yaml
EOF_MOCK
mkdir -p /etc/kubernetes/imgconfig
cat << 'EOF_MOCK' > /etc/kubernetes/imgconfig/kubeconfig.yaml
---apiVersion: apiserver.config.k8s.io/v1kind: AdmissionConfigurationplugins:  - name: ImagePolicyWebhook    path: /etc/kubernetes/imgconfig/imgepolicyconfig.yaml ---# the path should be the absolute path not just imagepolicyconfig.yaml
EOF_MOCK
echo "[+] Lab Setup Complete."