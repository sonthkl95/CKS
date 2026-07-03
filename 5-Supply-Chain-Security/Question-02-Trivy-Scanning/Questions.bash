#!/bin/bash
# Questions.bash  —  CKS Practice Test 2, Question 3
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 2  ·  Question 3
===============================================================

Scan two container images for high and critical vulnerabilities using Trivy and save the results:

Images to scan:

`ubuntu:18.04`

`registry.k8s.io/kube-apiserver:v1.24.0`

`registry.k8s.io/kube-scheduler:v1.23.0`

`postgres:12`

`httpd:2.4.49`

Only consider vulnerabilities with severity `HIGH` or `CRITICAL`.

Store the scan output in `/opt/trivy-vulnerable.txt`.

===============================================================
CKS_TASK_EOF
