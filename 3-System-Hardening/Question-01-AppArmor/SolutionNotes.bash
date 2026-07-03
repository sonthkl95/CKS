#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 1, Question 1
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 1  ·  Question 1
===============================================================

AppArmor restricts container behavior for enhanced security. In this task, the profile `nginx-profile-2` denies all file writes. Depending on the Kubernetes version, the profile is applied via `securityContext` (≥v1.30) or annotations (<v1.30).

Commands / Steps:

```bash
# SSH into the worker node (if needed)
ssh node-01

# Switch to root
sudo -i

# View the prepared AppArmor profile
head /etc/apparmor.d/nginx_apparmor

# profile example
`#include <tunables/global>
profile nginx-profile-2 flags=(attach_disconnected) {
    #include <abstractions/base>
    file,
    # Deny all file writes.
    deny /** w,
}`

# Load the AppArmor profile
apparmor_parser -q /etc/apparmor.d/nginx_apparmor

# Verify that the profile is active
aa-status | grep -i nginx-profile-2

# Exit from the node
exit
```

```bash
# Pod manifest for Kubernetes ≥1.30
---
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  nodeName: node-01
  containers:
  - name: nginx-pod
    image: nginx:1.19.0
    ports:
    - containerPort: 80
    securityContext:
      appArmorProfile:
        type: Localhost
        localhostProfile: nginx-profile-2
```

```bash
# Pod manifest for Kubernetes <1.30 (using annotations)
---
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  annotations:
    container.apparmor.security.beta.kubernetes.io/nginx-pod: localhost/nginx-profile-2
spec:
  nodeName: node-01
  containers:
  - name: nginx-pod
    image: nginx:1.19.0
    ports:
    - containerPort: 80
```

```bash
# Apply the Pod manifest
kubectl create -f /home/candidate/nginx-pod.yaml
```

Verification Step:

Check that the Pod is running on node-01:

```bash
kubectl get pods -o wide | grep nginx-pod
```

Test that the AppArmor profile is enforced by attempting a restricted write:

```bash
kubectl exec -it nginx-pod -- /bin/sh
touch /restricted-directory/testfile
# The operation should fail due to AppArmor restrictions
exit
```

⚠️ Note:

Container-level AppArmor profiles override pod-level profiles.

Kubernetes ≥1.30 uses `securityContext.appArmorProfile`, while <1.30 uses annotations.

Ensure AppArmor is enabled on the node before applying the profile

===============================================================
CKS_SOLUTION_EOF
