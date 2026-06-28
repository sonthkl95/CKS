#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace changes --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /etc/kubernetes/manifests
cat << 'EOF_MOCK' > /etc/kubernetes/manifests/kube-apiserver.yaml
# /etc/audit/audit-policy.yamlapiVersion: audit.k8s.io/v1kind: PolicyomitStages:  - "RequestReceived"rules:  # 1. Log namespace changes at RequestResponse level  - level: RequestResponse    resources:      - group: ""   # core API group        resources: ["namespaces"]   # 2. Log request body of secret changes in kube-system  - level: Request    namespaces: ["kube-system"]    resources:      - group: ""        resources: ["secrets"]   # 3. Log all other core and extensions resources at Request level  - level: Request    resources:      - group: ""           # core      - group: "extensions" # deprecated API group   # 4. Log pods/portforward, services/proxy at Metadata level  - level: Metadata    resources:      - group: ""         resources: ["pods/portforward", "services/proxy"]   # 5. Default: all other requests at Metadata level  - level: Metadata
EOF_MOCK
mkdir -p /etc/audit
cat << 'EOF_MOCK' > /etc/audit/audit-policy.yaml
# /etc/audit/audit-policy.yamlapiVersion: audit.k8s.io/v1kind: PolicyomitStages:  - "RequestReceived"rules:  # 1. Log namespace changes at RequestResponse level  - level: RequestResponse    resources:      - group: ""   # core API group        resources: ["namespaces"]   # 2. Log request body of secret changes in kube-system  - level: Request    namespaces: ["kube-system"]    resources:      - group: ""        resources: ["secrets"]   # 3. Log all other core and extensions resources at Request level  - level: Request    resources:      - group: ""           # core      - group: "extensions" # deprecated API group   # 4. Log pods/portforward, services/proxy at Metadata level  - level: Metadata    resources:      - group: ""         resources: ["pods/portforward", "services/proxy"]   # 5. Default: all other requests at Metadata level  - level: Metadata
EOF_MOCK
echo "[+] Lab Setup Complete."