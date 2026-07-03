#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Preparing audit log directory and a BASE audit policy to extend..."
mkdir -p /var/log /etc/kubernetes
cat > /etc/kubernetes/audit-policy.yaml <<'EOF'
apiVersion: audit.k8s.io/v1
kind: Policy
omitStages:
  - "RequestReceived"
rules:
  # TODO (extend):
  # 1. namespaces -> RequestResponse
  # 2. secrets in kube-system -> Request (request body)
  # 3. all other core + extensions -> Request
  # 4. pods/portforward, services/proxy -> Metadata
  # 5. default catch-all -> Metadata
EOF
echo ""
echo "[i] Task: extend the audit policy as above and enable audit logging on kube-apiserver"
echo "    (path /var/log/kubernetes-logs.log, retain 12 days, 8 backups, rotate at 200MB)."
echo "[+] Lab Setup Complete."
