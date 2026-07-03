#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating the ImagePolicyWebhook configuration under /etc/kubernetes/imgconfig ..."
mkdir -p /etc/kubernetes/imgconfig /root/16
cat > /etc/kubernetes/imgconfig/admission_configuration.yaml <<'EOF'
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
  configuration:
    imagePolicy:
      kubeConfigFile: /etc/kubernetes/imgconfig/kubeconfig.yaml
      allowTTL: 50
      denyTTL: 50
      retryBackoff: 500
      defaultAllow: false          # implicit deny
EOF
cat > /etc/kubernetes/imgconfig/kubeconfig.yaml <<'EOF'
apiVersion: v1
kind: Config
clusters:
- name: bouncer_webhook
  cluster:
    server: https://valhalla.local:8081/image_policy
    # certificate-authority: /etc/kubernetes/imgconfig/ca.crt
contexts:
- name: bouncer_validator
  context:
    cluster: bouncer_webhook
    user: api-server
current-context: bouncer_validator
users:
- name: api-server
  user: {}
EOF
cat > /root/16/vulnerable-resource.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: vulnerable-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
EOF
echo ""
echo "[i] Task: enable the ImagePolicyWebhook admission plugin (endpoint https://valhalla.local:8081/image_policy),"
echo "    enforce implicit deny, then test with /root/16/vulnerable-resource.yaml."
echo "[+] Lab Setup Complete."
