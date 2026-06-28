#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 2 - Question 2
=======================================================

Enable and configure Kubernetes audit logging with specific retention, size, and logging policies:
Store audit logs at /var/log/kubernetes-logs.log.

Retain logs for 12 days and keep a maximum of 8 old log files.

Rotate logs when they reach 200MB.

Extend the audit policy to log:
Namespace changes at RequestResponse level.

Request body of secret changes in the kube-system namespace.

All other resources in core and extensions at Request level.

"pods/portforward" and "services/proxy" at Metadata level.

Omit the stage RequestReceived.

Default all other requests at Metadata level.

=======================================================
EOF
