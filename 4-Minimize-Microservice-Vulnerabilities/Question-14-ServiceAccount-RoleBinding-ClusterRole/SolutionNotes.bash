#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 3 - Question 12
=======================================================

PodSecurityPolicies control security settings for Pods, including allowed volume types.
This policy ensures that only PVC volumes can be used.
The ServiceAccount with proper RBAC binding is needed to enforce the policy.

Commands / Steps:

```yaml
# Create the PSP, ServiceAccount, ClusterRole, and ClusterRoleBinding
vim psp.yaml
```

```yaml
# psp.yaml
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
name: prevent-volume-policy
spec:
privileged: false
allowPrivilegeEscalation: false
volumes:
- persistentVolumeClaim   # Only PVC allowed
runAsUser:
rule: RunAsAny
seLinux:
rule: RunAsAny
fsGroup:
rule: RunAsAny
supplementalGroups:
rule: RunAsAny
readOnlyRootFilesystem: false
---
apiVersion: v1
kind: ServiceAccount
metadata:
name: psp-sa
namespace: restricted
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
name: psp-role
rules:
- apiGroups:
- policy
resources:
- podsecuritypolicies
resourceNames:
- prevent-volume-policy
verbs:
- use
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
name: psp-role-binding
roleRef:
apiGroup: rbac.authorization.k8s.io
kind: ClusterRole
name: psp-role
subjects:
- kind: ServiceAccount
name: psp-sa
namespace: restricted
```

```yaml
# Apply the PSP, ServiceAccount, ClusterRole, and ClusterRoleBinding
kubectl create -f psp.yaml
```

```yaml
# Example Pod that should fail due to Secret volume
apiVersion: v1
kind: Pod
metadata:
name: secret-volume-test
namespace: restricted
spec:
serviceAccountName: psp-sa
containers:
- name: test
image: busybox
command: ["sleep", "3600"]
volumeMounts:
- mountPath: "/etc/secret"
name: mysecret
volumes:
- name: mysecret
secret:
secretName: mysecret
```

Verification Step:
Check that the Pod is running on node-01:

```yaml
kubectl create -f secret-volume-test.yaml
```

It should fail because the PSP only allows persistentVolumeClaim volumes.

Confirm the PSP is applied to the ServiceAccount:

```yaml
kubectl get psp prevent-volume-policy -o yaml
kubectl get sa psp-sa -n restricted -o yaml
kubectl get clusterrolebinding psp-role-binding -o yaml
```

'' Note:
PodSecurityPolicy is deprecated in Kubernetes '1.25; for newer clusters, consider Pod Security Admission or tools like Kyverno/OPA.

Testing with a Pod using a forbidden volume type validates the PSP enforcement.

Ensure the ServiceAccount is used in the Pod spec to enforce the PSP rules.

=======================================================
EOF
