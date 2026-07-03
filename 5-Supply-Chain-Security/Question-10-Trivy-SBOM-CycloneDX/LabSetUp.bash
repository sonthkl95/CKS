#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Preparing /opt/candidate/13 and a sample SBOM to scan..."
mkdir -p /opt/candidate/13
cat > /opt/candidate/13/sbom_check.json <<'EOF'
{ "spdxVersion": "SPDX-2.3", "name": "sample-sbom", "packages": [] }
EOF
echo ""
echo "[!] NOTE: requires the 'bom' and 'trivy' tools installed."
echo "[i] Task:"
echo "    - bom generate --format json --image registry.k8s.io/kube-apiserver:v1.32.0 -> /opt/candidate/13/sbom1.json (SPDX-JSON)"
echo "    - trivy image --format cyclonedx registry.k8s.io/kube-controller-manager:v1.32.0 -> /opt/candidate/13/sbom2.json"
echo "    - trivy sbom --format json /opt/candidate/13/sbom_check.json -> /opt/candidate/13/sbom_result.json"
echo "[+] Lab Setup Complete."
