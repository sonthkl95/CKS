#!/bin/bash
# LabSetUp.bash - Question 1: AppArmor Profile Enforcement
set -e

echo "🔹 Creating namespace..."
kubectl create ns cks-q1 --dry-run=client -o yaml | kubectl apply -f -

echo "🔹 Creating AppArmor profile on node01..."
# SSH to node01 and install the AppArmor profile
# In Killercoda, node01 is accessible directly
ssh -o StrictHostKeyChecking=no node01 bash << 'REMOTE'
cat > /etc/apparmor.d/nginx-profile-2 << 'PROFILE'
#include <tunables/global>

profile nginx-profile-2 flags=(attach_disconnected) {
  #include <abstractions/base>

  network inet tcp,
  network inet udp,
  network inet icmp,

  deny network raw,
  deny network packet,

  file,
  umount,

  deny /bin/** wl,
  deny /boot/** wl,
  deny /dev/** wl,
  deny /etc/** wl,
  deny /home/** wl,
  deny /lib/** wl,
  deny /lib64/** wl,
  deny /media/** wl,
  deny /mnt/** wl,
  deny /opt/** wl,
  deny /proc/** wl,
  deny /root/** wl,
  deny /sbin/** wl,
  deny /srv/** wl,
  deny /tmp/** wl,
  deny /sys/** wl,
  deny /usr/** wl,

  # Allow nginx to run
  /usr/sbin/nginx mr,
  /etc/nginx/** r,
  /var/log/nginx/** rw,
  /var/www/** r,
  /run/nginx.pid rw,

  capability net_bind_service,
  capability setgid,
  capability setuid,
}
PROFILE
apparmor_parser -q /etc/apparmor.d/nginx-profile-2
echo "✅ AppArmor profile loaded on node01"
REMOTE

echo "🔹 Creating Pod manifest directory..."
mkdir -p /home/candidate/01

echo "🔹 Writing Pod manifest..."
cat > /home/candidate/01/pod.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: apparmor-pod
  namespace: cks-q1
  annotations:
    # TODO: Add AppArmor annotation here for container "nginx"
    # container.apparmor.security.beta.kubernetes.io/nginx: localhost/nginx-profile-2
spec:
  nodeName: node01
  containers:
  - name: nginx
    image: nginx:1.25-alpine
    ports:
    - containerPort: 80
EOF

echo ""
echo "✅ Lab setup complete!"
echo "📋 Read Questions.bash for the task details."
echo "📁 Pod manifest at: /home/candidate/01/pod.yaml"
