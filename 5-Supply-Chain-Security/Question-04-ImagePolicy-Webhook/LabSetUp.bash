#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating the (incomplete) ImagePolicy webhook config in /etc/kubernetes/confcontrol ..."
mkdir -p /etc/kubernetes/confcontrol
cat > /etc/kubernetes/confcontrol/admission_configuration.yaml <<'EOF'
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
  configuration:
    imagePolicy:
      kubeConfigFile: /etc/kubernetes/confcontrol/kubeconfig.yaml
      allowTTL: 50
      denyTTL: 50
      retryBackoff: 500
      defaultAllow: true          # <-- INCOMPLETE: must become false (implicit deny)
EOF
cat > /etc/kubernetes/confcontrol/kubeconfig.yaml <<'EOF'
apiVersion: v1
kind: Config
clusters:
- name: image-bouncer-webhook
  cluster:
    server: https://127.0.0.1:8081/image_policy
    # certificate-authority: /etc/kubernetes/confcontrol/ca.crt
contexts:
- name: image-bouncer-webhook
  context:
    cluster: image-bouncer-webhook
    user: api-server
current-context: image-bouncer-webhook
users:
- name: api-server
  user: {}
EOF
echo "[+] Writing a test Pod that uses the 'latest' image tag..."
mkdir -p /root/16
cat > /root/16/test-pod.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: test-latest
spec:
  containers:
  - name: nginx
    image: nginx:latest
EOF
echo ""
echo "[i] Task: enable the ImagePolicy admission plugin on kube-apiserver, set implicit"
echo "    deny (defaultAllow: false), then try to deploy /root/16/test-pod.yaml (latest tag)."
echo "[+] Lab Setup Complete."
