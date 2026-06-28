#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 3 - Question 2
=======================================================

Step 1: Create a custom Seccomp profile

Save the profile as /opt/course/2/seccomp-profile.json:

```yaml
{
"defaultAction": "SCMP_ACT_ERRNO",
"architectures": [
"SCMP_ARCH_X86_64",
"SCMP_ARCH_X86",
"SCMP_ARCH_X32"
],
"syscalls": [
{
"names": ["read", "write", "exit", "sigreturn"],
"action": "SCMP_ACT_ALLOW"
}
]
}
```

```yaml
mv /opt/course/2/seccomp-profile.json /var/lib/kubelet/seccomp/profiles/
```

Step 2: Apply the Seccomp profile to the Deployment

Edit the Deployment webapp in secure-app namespace:

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
name: webapp
namespace: secure-app
spec:
replicas: 2
selector:
matchLabels:
app: webapp
template:
metadata:
labels:
app: webapp
spec:
containers:
- name: webapp
image: nginx:latest
securityContext:
seccompProfile:
type: Localhost
localhostProfile: profiles/seccomp-profile.json
```

```yaml
kubectl apply -f /opt/course/2/webapp.yaml
```

Step 3: Verify the Seccomp profile enforcement

```yaml
# Check Pods
kubectl get pod -n secure-app
# Describe a Pod to see Seccomp profile applied
kubectl describe pod <pod-name> -n secure-app | grep -i seccomp
# Test that disallowed syscalls fail
kubectl exec -it <pod-name> -n secure-app -- sh -c "exec /bin/bash"
# Should fail due to Seccomp restrictions
# Example: attempt a disallowed syscall (e.g., execve of /bin/bash)
```

Explanation
Seccomp (Secure Computing Mode) restricts the system calls a container can make, limiting kernel-level attack surface.

SCMP_ACT_ERRNO denies all syscalls by default.

Localhost profile type allows using a custom JSON Seccomp file stored locally on the node.

By restricting to only read, write, exit, and sigreturn, the container can perform basic I/O without executing potentially dangerous syscalls

'' Notes:
Ensure the seccomp-profile.json file exists on each node under the correct path referenced in the Deployment.

Custom Seccomp profiles enhance container security by preventing kernel exploitation through syscalls.

=======================================================
EOF
