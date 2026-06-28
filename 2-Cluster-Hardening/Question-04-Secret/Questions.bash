#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 2 - Question 10
=======================================================

Deploy an Nginx Pod with TLS-enabled ingress in the testing namespace:
Create a TLS Secret from bingo.crt and bingo.key.

Deploy a Pod named nginx-pod in the testing namespace.

Expose the Pod with a Service.

Create an Ingress using TLS (bingo-tls) with host bingo.com.

Redirect all HTTP traffic to HTTPS.

=======================================================
EOF
