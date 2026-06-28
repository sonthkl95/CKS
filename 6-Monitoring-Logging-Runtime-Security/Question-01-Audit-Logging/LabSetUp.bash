#!/bin/bash
# LabSetUp.bash - Question 1: Audit Logging
set -e

echo "🔹 Creating audit log directory..."
mkdir -p /var/log

echo "🔹 Creating audit policy directory..."
mkdir -p /etc/kubernetes

echo "🔹 Writing a BASIC existing audit policy (to extend)..."
cat > /etc/kubernetes/audit-policy.yaml << 'EOF'
apiVersion: audit.k8s.io/v1
kind: Policy
# Base policy - do not log these noisy events
omitStages:
  - "RequestReceived"
rules:
  # Do not log read-only requests to kube-system endpoints
  - level: None
    users: ["system:kube-scheduler", "system:kube-controller-manager"]
    resources:
    - group: ""
      resources: ["endpoints", "configmaps"]
    namespaces: ["kube-system"]
  
  # TODO: Add your rules here:
  # 1. CronJob at RequestResponse
  # 2. Deployments in kube-system at Request
  # 3. Core/extensions at Request
  # 4. system:kube-proxy watch on endpoints/services at None
  # 5. Default catch-all at Metadata
EOF

echo ""
echo "✅ Lab setup complete!"
echo ""
echo "📋 Current state:"
echo "   - /etc/kubernetes/audit-policy.yaml  (base policy, needs extending)"
echo "   - /var/log/ directory exists for log output"
echo ""
echo "📋 Your tasks:"
echo "   1. Edit /etc/kubernetes/audit-policy.yaml to add required rules"
echo "   2. Edit /etc/kubernetes/manifests/kube-apiserver.yaml to enable audit logging"
echo ""
echo "Hint - Add these flags to kube-apiserver.yaml:"
echo "   - --audit-log-path=/var/log/kubernetes-logs.log"
echo "   - --audit-log-maxage=5"
echo "   - --audit-log-maxbackup=10"
echo "   - --audit-log-maxsize=100"
echo "   - --audit-policy-file=/etc/kubernetes/audit-policy.yaml"
