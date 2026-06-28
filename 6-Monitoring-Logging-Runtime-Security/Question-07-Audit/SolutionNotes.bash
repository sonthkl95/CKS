#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 3 - Question 8
=======================================================

Audit logging is configured via the kube-apiserver. The policy file defines which requests to log and at which level. Logs can be rotated and retained using backend flags.

Commands / Steps

Step 1:  Edit the audit policy file

```yaml
vim /etc/audit/audit-policy.yaml
```

```yaml
# /etc/audit/audit-policy.yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
# 1. Log Node changes at RequestResponse level
- level: RequestResponse
resources:
- group: ""       # core API group
resources: ["nodes"]
# 2. Log PVC changes in 'frontend' namespace with request body
- level: Request
namespaces: ["frontend"]
resources:
- group: ""       # core API group
resources: ["persistentvolumeclaims"]
# Default rule from base policy -> do not log other requests
- level: None
```

Step 2: Edit kube-apiserver static pod manifest

```yaml
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

```yaml
# /etc/kubernetes/manifests/kube-apiserver.yaml (relevant section)
spec:
containers:
- name: kube-apiserver
image: k8s.gcr.io/kube-apiserver:v1.30.0
command:
- kube-apiserver
- --audit-policy-file=/etc/audit/audit-policy.yaml
- --audit-log-path=/var/log/kubernetes-logs.log
- --audit-log-maxage=5
- --audit-log-maxbackup=10
- --audit-log-maxsize=100   # Max size in MB before rotation
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
Verify kube-apiserver has audit flags enabled

```yaml
ps aux | grep kube-apiserver | grep audit
```

Trigger a Node change:

```yaml
kubectl delete node <node-name>
```

Trigger a PVC change in frontend namespace:

```yaml
vim pvc.yaml
```

```yaml
# pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
name: test-pvc
spec:
accessModes:
- ReadWriteOnce
resources:
requests:
storage: 1Gi
```

```yaml
kubectl apply -f pvc.yaml --namespace frontend
```

Check the logs:

```yaml
sudo tail -f /var/log/kubernetes-logs.log | grep "nodes"
sudo tail -f /var/log/kubernetes-logs.log | grep "persistentvolumeclaims"
```

'' Note:
The RequestResponse level captures both metadata and request/response body.

The PVC rule is scoped to the frontend namespace only.

Audit log rotation ensures files don't grow indefinitely and are managed automatically

=======================================================
EOF
