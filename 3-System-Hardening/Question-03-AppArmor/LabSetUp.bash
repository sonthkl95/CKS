#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Loading the 'nginx-deny' AppArmor profile on the worker node..."
ssh -o StrictHostKeyChecking=no node01 bash <<'REMOTE' 2>/dev/null || echo "    (load the profile manually on the worker node if SSH is unavailable)"
cat > /etc/apparmor.d/nginx-deny <<'PROFILE'
#include <tunables/global>
profile nginx-deny flags=(attach_disconnected) {
  #include <abstractions/base>
  file,
  # Deny all file writes.
  deny /** w,
}
PROFILE
apparmor_parser -q /etc/apparmor.d/nginx-deny
echo "nginx-deny profile loaded"
REMOTE
echo "[+] Writing the Pod manifest..."
mkdir -p /home/candidate/apparmor
cat > /home/candidate/apparmor/pod.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: apparmor-deny-pod
  # TODO: add container.apparmor.security.beta.kubernetes.io/<container>: localhost/nginx-deny
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF
echo ""
echo "[i] Task: reference profile 'localhost/nginx-deny' on the Pod, deploy it, and"
echo "    verify that file writes are denied."
echo "[+] Lab Setup Complete."
