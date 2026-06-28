#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 1 - Question 5
=======================================================

Audit logging in Kubernetes tracks requests to the API server. Custom policies allow selective logging and exclusion to reduce noise. Audit backend rotation ensures logs do not consume excessive disk space.

Commands / Steps:

```yaml
# Edit audit policy
vim /etc/audit/audit-policy.yaml
```

```yaml
# /etc/audit/audit-policy.yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
# 1. Log CronJobs changes at RequestResponse level
- level: RequestResponse
resources:
- group: "batch"
resources: ["cronjobs"]
# 2. Log request body of deployments changes in kube-system
- level: Request
namespaces: ["kube-system"]
resources:
- group: "apps"
resources: ["deployments"]
# 3. Log all other core and extensions resources at Request level
- level: Request
resources:
- group: ""
- group: "extensions"
# 4. Exclude watch requests by system:kube-proxy on endpoints/services
- level: None
users: ["system:kube-proxy"]
verbs: ["watch"]
resources:
- group: ""
resources: ["endpoints", "services"]
```

```yaml
# Update kube-apiserver manifest to enable audit logging
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

```yaml
# Relevant kube-apiserver spec snippet
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
- --audit-log-maxsize=100
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

```yaml
# Verify kube-apiserver is running with audit logs
ps aux | grep kube-apiserver | grep audit
# Test logging by creating a CronJob
kubectl create cronjob testjob --image=busybox --schedule="*/1 * * * *" -- /bin/sh -c 'date; echo Hello'
# Check audit logs for CronJob entries
cat /var/log/kubernetes-logs.log | grep cronjob
# Follow the log file
tail -f /var/log/kubernetes-logs.log
```

Verification Step:
Confirm the kube-apiserver is running with audit logging:

```yaml
ps aux | grep kube-apiserver | grep audit
```

Check that audit logs are being generated:

```yaml
cat /var/log/kubernetes-logs.log | grep cronjob
tail -f /var/log/kubernetes-logs.log
```

Verify CronJob requests appear with RequestResponse level.

Ensure other rules are applied correctly and system:kube-proxy watch requests are excluded.

Check log rotation and retention settings (maxsize, maxbackup, maxage).

'' Note:
Audit policies are applied per API server; manifest changes automatically restart kube-apiserver in static pod setup.

Use kubectl get cronjob to trigger API server events for testing logging.

Adjust logging levels to balance audit detail vs disk usage.

=======================================================
EOF
