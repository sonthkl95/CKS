#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 2 - Question 1
=======================================================

AppArmor provides mandatory access control for processes, allowing you to restrict what a container can do. In this task, the nginx-deny profile denies all file writes. Depending on the Kubernetes version, AppArmor can be applied via annotations (<v1.30) or securityContext ('v1.30).

Commands / Steps:

```yaml
# SSH into the cluster node to deploy the AppArmor profile
ssh cluster-node01
# View the prepared AppArmor profile
head /etc/apparmor.d/nginx_apparmor
# profile example
`#include <tunables/global>
profile nginx-deny flags=(attach_disconnected) {
#include <abstractions/base>
file,
# Deny all file writes.
deny /** w,
}`
# Load the AppArmor profile
apparmor_parser -q /etc/apparmor.d/nginx_apparmor
# Check if the profile is loaded
aa-status | grep nginx-deny
# Exit the node
exit
```

```yaml
# Kubernetes Pod manifest for K8s -> 1.30
apiVersion: v1
kind: Pod
metadata:
name: nginx-pod
spec:
containers:
- name: nginx-pod
image: nginx:1.19.0
ports:
- containerPort: 80
securityContext:
appArmorProfile:
type: Localhost
localhostProfile: nginx-deny
```

```yaml
# Kubernetes Pod manifest for K8s < 1.30 (using annotations)
apiVersion: v1
kind: Pod
metadata:
name: nginx-pod
annotations:
container.apparmor.security.beta.kubernetes.io/nginx-pod: localhost/nginx-deny
spec:
containers:
- name: nginx-pod
image: nginx:1.19.0
ports:
- containerPort: 80
```

```yaml
# Apply the manifest (replace with correct filename)
kubectl apply -f nginx-pod.yaml
# Verify the Pod is running
kubectl get pods nginx-pod
# Test the restriction by attempting to write to a denied directory inside the Pod
kubectl exec -it nginx-pod -- /bin/sh
touch /restricted-directory/testfile
# The operation should fail due to AppArmor restrictions
exit
```

'' Note:
Prior to Kubernetes v1.30, AppArmor profiles were specified using annotations.

Container-level AppArmor profiles take precedence over pod-level profiles.

Always verify which K8s version you are using to apply the correct method.

=======================================================
EOF
