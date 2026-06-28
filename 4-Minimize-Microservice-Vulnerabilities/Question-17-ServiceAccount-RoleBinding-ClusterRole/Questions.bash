#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 4 - Question 6
=======================================================

Prevent privileged pods from being created in the default namespace using a PodSecurityPolicy (PSP):
Create a PSP prevent-privileged-policy that forbids privileged pods.

Create a ServiceAccount psp-sa in default.

Create a ClusterRole prevent-role that allows using the PSP.

Bind the ClusterRole to the ServiceAccount with a ClusterRoleBinding prevent-role-binding.

Verify the PSP by attempting to create a privileged pod.

=======================================================
EOF
