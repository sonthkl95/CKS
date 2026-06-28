#!/bin/bash
# LabSetUp.bash - Question 4: ImagePolicy Webhook
set -e

echo "🔹 Creating directories..."
mkdir -p /etc/kubernetes/admission
mkdir -p /root/16

echo "🔹 Creating webhook kubeconfig..."
cat > /etc/kubernetes/admission/webhook.yaml << 'EOF'
apiVersion: v1
kind: Config
clusters:
- cluster:
    server: https://127.0.0.1:8081/image_policy
    # certificate-authority-data: ...
  name: bouncer_webhook
contexts:
- context:
    cluster: bouncer_webhook
    user: api-server
  name: bouncer_validator
current-context: bouncer_validator
preferences: {}
users:
- name: api-server
  user:
    # client-certificate-data: ...
    # client-key-data: ...
EOF

echo "🔹 Creating admission config..."
cat > /etc/kubernetes/admission/admission_config.yaml << 'EOF'
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
  configuration:
    imagePolicy:
      kubeConfigFile: /etc/kubernetes/admission/webhook.yaml
      allowTTL: 50
      denyTTL: 50
      retryBackoff: 500
      defaultAllow: false
EOF

echo "🔹 Creating vulnerable pod manifest..."
cat > /root/16/vulnerable-pod.yaml << 'EOF'
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
echo "✅ Lab setup complete!"
echo "📋 Your task:"
echo "   1. Enable ImagePolicyWebhook admission plugin in kube-apiserver.yaml"
echo "   2. Provide the admission configuration file to the API server"
echo "   3. Try to apply /root/16/vulnerable-pod.yaml"
