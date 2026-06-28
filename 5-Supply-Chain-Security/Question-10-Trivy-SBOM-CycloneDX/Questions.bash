#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 3 - Question 13
=======================================================

Generate Software Bill Of Materials (SBOM) documents for specific Kubernetes images and scan an existing SBOM for known vulnerabilities using bom and trivy.
Images / Files to generate:
Generate SPDX-JSON SBOM for registry.k8s.io/kube-apiserver:v1.32.0 and save to /opt/candidate/13/sbom1.json

Generate CycloneDX SBOM for registry.k8s.io/kube-controller-manager:v1.32.0 and save to /opt/candidate/13/sbom2.json

Scan the existing SPDX-JSON SBOM located at /opt/candidate/13/sbom_check.json for known vulnerabilities and save the scan result in JSON format to /opt/candidate/13/sbom_result.json

=======================================================
EOF
