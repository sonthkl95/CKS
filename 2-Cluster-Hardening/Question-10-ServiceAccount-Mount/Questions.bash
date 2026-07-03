#!/bin/bash
# Questions.bash  —  CKS Practice Test 3, Question 11
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 3  ·  Question 11
===============================================================

Organization’s security policy requires:

ServiceAccounts must not automount API credentials.

ServiceAccount names must end with `-sa`.

The Pod defined in `/home/candidate/11/pod-manifest.yaml` fails to schedule due to an incorrect ServiceAccount.

Tasks:

Create a new ServiceAccount named `frontend-sa` in namespace `qa`, ensuring it does not automount credentials.

Update and apply the Pod manifest to use this ServiceAccount.

Clean up unused ServiceAccounts in `qa` namespace.

===============================================================
CKS_TASK_EOF
