#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 2 - Question 3
=======================================================

Trivy is a vulnerability scanner for container images. This task scans specific images for serious security issues and consolidates the findings into a single file for review.

Commands / Steps:

```yaml
# Display Trivy help (optional)
trivy image --help
# Scan ubuntu:18.04 for HIGH and CRITICAL vulnerabilities and save output
trivy image --severity HIGH,CRITICAL \
--output /opt/trivy-vulnerable.txt ubuntu:18.04
# Scan kube-apiserver image and append output to the same file
trivy image --severity HIGH,CRITICAL registry.k8s.io/kube-apiserver:v1.24.0 \
>> /opt/trivy-vulnerable.txt
# Scan kube-scheduler image and append output to the same file
trivy image --severity HIGH,CRITICAL registry.k8s.io/kube-scheduler:v1.23.0 \
>> /opt/trivy-vulnerable.txt
# Scan postgres image and append output to the same file
trivy image --severity HIGH,CRITICAL postgres:12 >> /opt/trivy-vulnerable.txt
# Scan apache httpd image and append output to the same file
trivy image --severity HIGH,CRITICAL httpd:2.4.49 >> /opt/trivy-vulnerable.txt
```

Verification Step:
Confirm that only HIGH or CRITICAL severity vulnerabilities are listed:

```yaml
tail -f /opt/trivy-vulnerable.txt
```

'' Note:
Additional options like --format json can be used for structured outputs if needed

=======================================================
EOF
