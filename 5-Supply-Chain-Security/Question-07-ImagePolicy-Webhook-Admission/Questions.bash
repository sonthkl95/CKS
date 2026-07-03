#!/bin/bash
# Questions.bash  —  CKS Practice Test 2, Question 16
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 2  ·  Question 16
===============================================================

Integrate the cluster’s container image scanner to reject vulnerable images.

Configure the ImagePolicyWebhook admission plugin with HTTPS endpoint `https://valhalla.local:8081/image_policy`.

Enforce implicit deny for images not explicitly allowed.

Test using `/root/16/vulnerable-resource.yaml`.

File path to the webhook configuration: `/etc/kubernetes/imgconfig/`.

===============================================================
CKS_TASK_EOF
