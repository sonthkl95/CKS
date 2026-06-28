#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 4 - Question 5
=======================================================

Create a NetworkPolicy named allow-np that:
Allows Pods in namespace staging to connect to port 80 of other Pods in the same namespace.

Denies traffic to Pods not listening on port 80.

Denies traffic from Pods outside of staging namespace.

=======================================================
EOF
