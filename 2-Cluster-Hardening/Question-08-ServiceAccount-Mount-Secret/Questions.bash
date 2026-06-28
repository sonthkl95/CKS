#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 2 - Question 15
=======================================================

A Pod token-demo is running in the default namespace and uses the default mounted token.

Modify the default ServiceAccount to disable automatic token mounting (automountServiceAccountToken: false).

Edit the Pod to:
Use this ServiceAccount.

Mount a projected volume with the ServiceAccount token manually at /var/run/secrets/tokens/token.jwt.

=======================================================
EOF
