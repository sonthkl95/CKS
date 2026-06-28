#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 4 - Question 6
=======================================================

PodSecurityPolicy can enforce security restrictions such as disallowing privileged containers, host networking, and escalations.
ServiceAccounts with RBAC can be granted access to specific PSPs.

Commands / Steps:

```yaml
# Edit PSP manifest
vim psp.yaml
```

```yaml
# psp.yaml
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
name: prevent-privileged-policy
spec:
privileged: false          # Prevents privileged pods
allowPrivilegeEscalation: false
requiredDropCapabilities:
- ALL
volumes:
- '*'
runAsUser:
rule: 'RunAsAny'
seLinux:
rule: 'RunAsAny'
supplementalGroups:
rule: 'RunAsAny'
fsGroup:
rule: 'RunAsAny'
hostNetwork: false
hostIPC: false
hostPID: false
```

```yaml
# Apply PSP
kubectl apply -f psp.yaml
```

```yaml
# Create ClusterRole for PSP access
kubectl create clusterrole prevent-role \
--verb=use \
--resource=podsecuritypolicies.policy \
--resource-name=prevent-privileged-policy \
--dry-run=client -o yaml
```

```yaml
# Generated ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
name: prevent-role
rules:
- apiGroups: ['policy']
resources: ['podsecuritypolicies']
verbs: ['use']
resourceNames: ['prevent-privileged-policy']
```

```yaml
# Create ServiceAccount in default namespace
kubectl create sa psp-sa -n default
```

```yaml
# ServiceAccount manifest
apiVersion: v1
kind: ServiceAccount
metadata:
name: psp-sa
namespace: default
```

```yaml
# Bind the PSP ClusterRole to the ServiceAccount
kubectl create clusterrolebinding prevent-role-binding \
--clusterrole=prevent-role \
--serviceaccount=default:psp-sa \
--dry-run=client -o yaml
```

```yaml
# ClusterRoleBinding manifest
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
name: prevent-role-binding
roleRef:
apiGroup: rbac.authorization.k8s.io
kind: ClusterRole
name: prevent-role
subjects:
- kind: ServiceAccount
name: psp-sa
namespace: default
```

```yaml
# Attempt to create a privileged pod
vim privileged-pod.yaml
```

```yaml
# privileged-pod.yaml
apiVersion: v1
kind: Pod
metadata:
name: privileged-pod
spec:
serviceAccountName: psp-sa
containers:
- name: nginx
image: nginx
securityContext:
privileged: true   # Should fail due to PSP
```

```yaml
# Apply the pod manifest
kubectl apply -f privileged-pod.yaml
# Verify PSP enforcement via RBAC
kubectl auth can-i use podsecuritypolicy/prevent-privileged-policy \
--as=system:serviceaccount:default:psp-sa
```

Verification Step:
Creating the privileged pod should fail:

```yaml
kubectl get pod privileged-pod -n default
```

Verifying PSP enforcement via RBAC:

```yaml
kubectl auth can-i use podsecuritypolicy/prevent-privileged-policy \
--as=system:serviceaccount:default:psp-sa
```

'' Note:
PSPs are deprecated in Kubernetes '1.25; for newer clusters, use Pod Security Admission or OPA/Gatekeeper.

Always test the PSP with a pod that violates the policy to confirm enforcement.

=======================================================
EOF
