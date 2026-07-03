#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Creating namespace 'frontend'..."
kubectl create ns frontend --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Preparing audit log dir and a BASE policy (only says what NOT to log) to extend..."
mkdir -p /var/log /etc/audit
cat > /etc/audit/audit-policy.yaml <<'EOF'
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
  # TODO (extend):
  # 1. nodes -> RequestResponse
  # 2. persistentvolumeclaims in ns 'frontend' -> Request (request body)
  # Base: do not log anything else
  - level: None
EOF
echo ""
echo "[i] Task: extend the audit policy as above and enable audit logging on kube-apiserver"
echo "    (path /var/log/kubernetes-logs.log, retain 5 days, keep 10 old files)."
echo "[+] Lab Setup Complete."
