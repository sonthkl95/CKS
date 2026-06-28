#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 1 - Question 3
=======================================================

A Pod nginx-pod is running in the default namespace and uses a token by default.

Modify the default ServiceAccount to disable automatic token mounting.

Create a Secret of type kubernetes.io/service-account-token that references the default ServiceAccount.

Edit the Pod to:
Use the default ServiceAccount.

Mount the token from the Secret at /var/run/secrets/kubernetes.io/serviceaccount/token.

=======================================================
EOF
