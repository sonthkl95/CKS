#!/bin/bash
# Questions.bash  —  CKS Practice Test 3, Question 9
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 3  ·  Question 9
===============================================================

A development team needs to securely provide configuration data and credentials to their applications inside Kubernetes.

You are required to work with Kubernetes Secrets and ensure the data is mounted into a Pod for application usage.

Retrieve the CA certificate data from the existing secret `default-token-xxxxx` in the `dev` namespace and save it to a file named `ca.crt`.

Create a new secret `app-config-secret` in the `app` namespace with the following key-value pairs:

- `APP_USER=appadmin`

- `APP_PASS=Sup3rS3cret`

Deploy a Pod named `app-pod` using the `nginx` image that mounts the secret as a volume at `/etc/app-config`.

===============================================================
CKS_TASK_EOF
