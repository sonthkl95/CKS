#!/bin/bash
# Questions.bash  —  CKS Practice Test 1, Question 11
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 1  ·  Question 11
===============================================================

The cluster has a container image scanner webhook but its configuration is incomplete.

Current configuration is in `/etc/kubernetes/confcontrol` directory.

Enable the ImagePolicy admission plugin, set it to deny all non-compliant images (implicit deny), and test the configuration by attempting to deploy a Pod using the `latest` image tag.

===============================================================
CKS_TASK_EOF
