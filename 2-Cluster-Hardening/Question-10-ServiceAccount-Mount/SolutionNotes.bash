#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 3 - Question 11
=======================================================

Commands/Steps

Step 1: Create ServiceAccount

```yaml
kubectl create sa frontend-sa -n qa
kubectl patch sa frontend-sa -n qa -p '{"automountServiceAccountToken": false}'
```

Step 2: Update and apply the Pod manifest
Edit /home/candidate/11/pod-manifest.yaml:

```yaml
apiVersion: v1
kind: Pod
metadata:
name: frontend
namespace: qa
labels:
run: frontend
spec:
serviceAccountName: frontend-sa
automountServiceAccountToken: false
containers:
- name: frontend
image: nginx
```

```yaml
kubectl apply -f /home/candidate/11/pod-manifest.yaml
```

Step 3: Clean up unused ServiceAccounts

```yaml
kubectl get sa -n qa
kubectl delete sa <unused-sa> -n qa
```

'' Note:
Security policy is satisfied because frontend-sa ends with -sa and has automountServiceAccountToken: false.

Pod now uses the correct ServiceAccount and schedules successfully.

Cleanup ensures no non-compliant ServiceAccounts remain in namespace qa.

=======================================================
EOF
