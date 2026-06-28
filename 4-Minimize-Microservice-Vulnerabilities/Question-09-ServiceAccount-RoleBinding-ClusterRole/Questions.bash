#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 2 - Question 8
=======================================================

Create a PodSecurityPolicy that blocks privileged Pods within a specific namespace.
Define a PodSecurityPolicy named prevent-psp-policy that disallows privileged containers.

Set up a ClusterRole restrict-access-role that grants access to this policy.

Add a ServiceAccount psp-restrict-sa inside the staging namespace.

Bind the ClusterRole to the ServiceAccount using a ClusterRoleBinding restrict-access-bind.

=======================================================
EOF
