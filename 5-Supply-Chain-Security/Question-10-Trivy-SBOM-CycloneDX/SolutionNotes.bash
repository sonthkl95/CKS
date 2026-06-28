#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 3 - Question 13
=======================================================

A Software Bill Of Materials (SBOM) is a detailed inventory of all components (libraries, packages, dependencies) that exist inside a container image.
SPDX-JSON and CycloneDX are widely used industry-standard formats for SBOMs.

SBOMs allow security teams to analyze dependencies without pulling or rescanning the original image.

By generating SBOMs and scanning them with trivy, we can identify High and Critical vulnerabilities early and ensure compliance/security standards are met.

Commands / Steps

```yaml
# Generate SPDX-JSON SBOM for kube-apiserver
bom generate --image registry.k8s.io/kube-apiserver:v1.32.0 --format json --output /opt/candidate/13/sbom1.json
cat /opt/candidate/13/sbom1.json
# Generate CycloneDX SBOM for kube-controller-manager
trivy image --format cyclonedx --output /opt/candidate/13/sbom2.json registry.k8s.io/kube-controller-manager:v1.32.0
cat /opt/candidate/13/sbom2.json
# Scan existing SPDX-JSON SBOM for vulnerabilities using Trivy
trivy sbom --format json --output /opt/candidate/13/sbom_result.json /opt/candidate/13/sbom_check.json
cat /opt/candidate/13/sbom_result.json
```

Verification Step:

```yaml
# Verify generated SBOM files exist and contain expected JSON
ls -l /opt/candidate/13/sbom*.json
jq . /opt/candidate/13/sbom1.json
jq . /opt/candidate/13/sbom2.json
jq . /opt/candidate/13/sbom_result.json
```

'' Note:
bom is used for SPDX-JSON generation; Trivy supports multiple SBOM formats including CycloneDX.

Trivy does not require the image itself when scanning from an existing SBOM.

Ensure bom and trivy are installed on the cluster's master node (as stated in the task).

=======================================================
EOF
