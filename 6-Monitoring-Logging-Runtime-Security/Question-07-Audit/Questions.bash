#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 3 - Question 8
=======================================================

Enable audit logging in the cluster. Configure log backend with the following requirements:
Logs are stored at /var/log/kubernetes-logs.log.

Logs are retained for 5 days.

Up to 10 old log files are retained.

A base policy exists at /etc/audit/audit-policy.yaml (only specifies what not to log). Extend it to:
Log Node changes at RequestResponse level.

Log PersistentVolumeClaim (PVC) changes in the frontend namespace including the request body.

=======================================================
EOF
