#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Writing the Pod manifest to scan (kubesec-test.yaml)..."
mkdir -p /root/kubesec 2>/dev/null; cd /root/kubesec 2>/dev/null || cd "$HOME"
cat > kubesec-test.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: kubesec-demo
spec:
  containers:
  - name: kubesec-demo
    image: gcr.io/google-samples/node-hello:1.0
    securityContext:
      readOnlyRootFilesystem: false
EOF
echo "    created $(pwd)/kubesec-test.yaml"
echo ""
echo "[i] Task: scan with the KubeSec docker image and apply fixes to reach a score >= 4, e.g.:"
echo "    docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < kubesec-test.yaml"
echo "[+] Lab Setup Complete."
