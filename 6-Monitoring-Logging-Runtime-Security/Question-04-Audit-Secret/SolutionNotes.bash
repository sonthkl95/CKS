#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 2 - Question 2
=======================================================

Kubernetes audit logging allows tracking API requests for security and compliance. This task configures the audit backend to store logs on disk with rotation and retention settings, while specifying detailed rules for different resource types and namespaces.

Commands / Steps:

```yaml
# Edit the audit policy file
vim /etc/audit/audit-policy.yaml
```

```yaml
# /etc/audit/audit-policy.yaml
apiVersion: audit.k8s.io/v1
kind: Policy
omitStages:
- "RequestReceived"
rules:
# 1. Log namespace changes at RequestResponse level
- level: RequestResponse
resources:
- group: ""   # core API group
resources: ["namespaces"]
# 2. Log request body of secret changes in kube-system
- level: Request
namespaces: ["kube-system"]
resources:
- group: ""
resources: ["secrets"]
# 3. Log all other core and extensions resources at Request level
- level: Request
resources:
- group: ""           # core
- group: "extensions" # deprecated API group
# 4. Log pods/portforward, services/proxy at Metadata level
- level: Metadata
resources:
- group: ""
resources: ["pods/portforward", "services/proxy"]
# 5. Default: all other requests at Metadata level
- level: Metadata
```

```yaml
# Edit the kube-apiserver manifest to enable audit logging
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

```yaml
# kube-apiserver.yaml snippet
spec:
containers:
- name: kube-apiserver
image: k8s.gcr.io/kube-apiserver:v1.30.0
command:
- kube-apiserver
- --audit-policy-file=/etc/audit/audit-policy.yaml
- --audit-log-path=/var/log/kubernetes-logs.log
- --audit-log-maxage=12
- --audit-log-maxbackup=8
- --audit-log-maxsize=200
volumeMounts:
- mountPath: /etc/audit/audit-policy.yaml
name: audit
readOnly: true
- mountPath: /var/log/
name: audit-log
readOnly: false
volumes:
- name: audit
hostPath:
path: /etc/audit/audit-policy.yaml
type: File
- name: audit-log
hostPath:
path: /var/log/
type: DirectoryOrCreate
```

Verification Step:
Verify that audit logs are being generated:

```yaml
tail -f /var/log/kubernetes-logs.log
```

'' Note:
Ensure that the kube-apiserver Pod is restarted after modifying its manifest to pick up the new audit configuration.

The extensions API group is deprecated; it is included here for backward compatibility.

Audit policy stages and levels (RequestResponse, Request, Metadata) define the verbosity of the logged information

=======================================================
EOF
