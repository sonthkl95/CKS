#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 3, Question 4
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 3  ·  Question 4
===============================================================

Commands / Steps

```bash
# List all images used by Pods in the nato namespace
kubectl get po -n nato -o yaml | grep -oP 'image:.*'

# Check Trivy usage
trivy image --help

# Scan each image for HIGH or CRITICAL vulnerabilities
trivy image --severity HIGH,CRITICAL nginx:1.19
trivy image --severity HIGH,CRITICAL nginx:latest
trivy image --severity HIGH,CRITICAL nginx:1.16

# Delete Pods using vulnerable images
kubectl delete --force po -n nato nginx-2 --grace-period 0
kubectl delete --force po -n nato nginx-3 --grace-period 0

# Verify remaining Pods
kubectl get po -n nato
```

Verification Step:

```bash
# Ensure no Pods are running images with high or critical vulnerabilities
kubectl get po -n nato -o wide
```

⚠️ Note:

Trivy scans container images for vulnerabilities must be installed on the master node where these commands are executed.

`--severity HIGH,CRITICAL` filters results to only show high and critical severity issues.

`--force` flag forces deletion of the Pod.

`--grace-period 0` ensures immediate deletion without waiting for the Pod to be terminated.

Always scan images before deployment in production for continuous security.

===============================================================
CKS_SOLUTION_EOF
