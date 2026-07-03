#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating Pod 'token-demo' in the 'default' namespace (uses default SA token)..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: token-demo
  namespace: default
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF
echo ""
echo "[i] Task: set 'automountServiceAccountToken: false' on the default SA, then edit"
echo "    the Pod to mount a projected SA token at /var/run/secrets/tokens/token.jwt."
kubectl get sa default -o yaml | grep -i automount || echo "    (default SA currently auto-mounts the token)"
echo "[+] Lab Setup Complete."
