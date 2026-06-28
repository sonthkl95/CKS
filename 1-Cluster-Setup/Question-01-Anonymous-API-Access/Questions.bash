#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 1 - Question 4
=======================================================

The cluster's API server was temporarily configured to allow unauthenticated + unauthorized access (anonymous user had cluster-admin).

Re-secure the cluster so that only authenticated and authorized REST requests are allowed.

Requirements:
Use authorization mode Node,RBAC.

Use admission controller NodeRestriction.

Disable --anonymous-auth.

Remove ClusterRoleBinding that grants access to system:anonymous.

After the fix, use the original kubeconfig /etc/kubernetes/admin.conf for authenticated kubectl access.

=======================================================
EOF
