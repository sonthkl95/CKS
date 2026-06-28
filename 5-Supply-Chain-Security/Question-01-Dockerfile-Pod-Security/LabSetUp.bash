#!/bin/bash
# LabSetUp.bash - Question 1: Dockerfile and Pod Security Hardening
set -e

echo "🔹 Creating working directory..."
mkdir -p /home/candidate/06

echo "🔹 Creating vulnerable Dockerfile..."
cat > /home/candidate/06/Dockerfile << 'EOF'
FROM ubuntu:latest
RUN apt-get update -y
RUN apt-get install nginx -y
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
USER ROOT
EOF

echo "🔹 Creating entrypoint.sh..."
cat > /home/candidate/06/entrypoint.sh << 'EOF'
#!/bin/bash
exec nginx -g "daemon off;"
EOF
chmod +x /home/candidate/06/entrypoint.sh

echo "🔹 Creating vulnerable Pod manifest..."
cat > /home/candidate/06/pod.yaml << 'EOF'
---
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo-2
  namespace: default
spec:
  securityContext:
    runAsUser: 1000
  containers:
  - name: security-context-demo-2
    image: gcr.io/google-samples/node-hello:1.0
    securityContext:
      runAsUser: 0
      privileged: true
      allowPrivilegeEscalation: false
EOF

echo ""
echo "✅ Lab setup complete!"
echo "📁 Files created:"
echo "   /home/candidate/06/Dockerfile  (has 2 security issues)"
echo "   /home/candidate/06/pod.yaml    (has 2 security issues)"
echo ""
echo "📋 Read Questions.bash for the task details."
