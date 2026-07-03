#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 3, Question 16
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 3  ·  Question 16
===============================================================

- The `restricted` profile blocks privileged containers, host networking, and other unsafe configurations.

- By labeling the namespace, the Pod Security Admission controller enforces this policy automatically.

- Once enforced, any attempt to recreate Pods with privileged settings will fail.

- ReplicaSet events will contain details about the violation.

Commands / Steps

```bash
# Label the namespace with restricted PodSecurity enforcement
kubectl label ns team-blue pod-security.kubernetes.io/enforce=restricted

# Verify labels
kubectl get ns team-blue --show-labels

# Delete the running Pod from the Deployment
kubectl -n team-blue delete pod privileged-runner-7c9f5c4b8b-kz2jd --force --grace-period=0

# Inspect ReplicaSet events to see failure reason
kubectl -n team-blue describe rs privileged-runner-7c9f5c4b8b | grep -i "FailedCreate"

# Save failure logs into required file
kubectl -n team-blue describe rs privileged-runner-7c9f5c4b8b \
  | grep -i "FailedCreate" > /opt/candidate/16/logs
```

Verification Step:

```bash
# Confirm Pod is not recreated
kubectl -n team-blue get pods

# Confirm logs file contains expected error message
cat /opt/candidate/16/logs
```

⚠️ Note:

The `restricted` profile forbids privileged containers.

The ReplicaSet will fail to recreate the Pod with error similar to:
`violates PodSecurity "restricted:latest": privileged containers are not allowed`.

===============================================================
CKS_SOLUTION_EOF
