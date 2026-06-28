#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 2 - Question 8
=======================================================

Admission Controler PodSecurityPolicy must be enabled.
PodSecurityPolicy (PSP) allows administrators to enforce security restrictions at the cluster level. In this task, the PSP is configured to prevent privileged Pods from running. The associated RBAC rules ensure that only the defined ServiceAccount in the staging namespace can use this policy.
'' Note: PSP is deprecated as of Kubernetes v1.25; for newer versions, Pod Security Admission, Kyverno, or OPA/Gatekeeper should be used.

Commands / Steps:

```yaml
# Apply the PodSecurityPolicy
kubectl create -f prevent-psp-policy.yaml
```

```yaml
# prevent-psp-policy.yaml
apiVersion: policy/v1beta1
kind: PodSecurityPolicy
metadata:
name: prevent-psp-policy
spec:
privileged: false                # -> privileged containers running prohibition
allowPrivilegeEscalation: false
requiredDropCapabilities:
- ALL
volumes:
- configMap
- emptyDir
- projected
- secret
- downwardAPI
- persistentVolumeClaim
runAsUser:
rule: MustRunAsNonRoot
seLinux:
rule: RunAsAny
supplementalGroups:
rule: RunAsAny
fsGroup:
rule: RunAsAny
readOnlyRootFilesystem: true
```

```yaml
# Create a ClusterRole that provides access to this PSP
kubectl create clusterrole restrict-access-role \
--verb=use \
--resource=podsecuritypolicies.policy \
--resource-name=prevent-psp-policy \
--dry-run=client -o yaml | kubectl apply -f -
```

```yaml
# ClusterRole definition
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
name: restrict-access-role
rules:
- apiGroups: ["policy"]
resources: ["podsecuritypolicies"]
verbs: ["use"]
resourceNames: ["prevent-psp-policy"]
```

```yaml
# Create a ServiceAccount in the staging namespace
kubectl create serviceaccount psp-restrict-sa -n staging
```

```yaml
# ServiceAccount definition
apiVersion: v1
kind: ServiceAccount
metadata:
name: psp-restrict-sa
namespace: staging
```

```yaml
# Create a ClusterRoleBinding to bind the ServiceAccount to the ClusterRole
kubectl create clusterrolebinding restrict-access-bind \
--clusterrole=restrict-access-role \
--serviceaccount=staging:psp-restrict-sa \
--dry-run=client -o yaml | kubectl apply -f -
```

```yaml
# ClusterRoleBinding definition
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
name: restrict-access-bind
roleRef:
apiGroup: rbac.authorization.k8s.io
kind: ClusterRole
name: restrict-access-role
subjects:
- kind: ServiceAccount
name: psp-restrict-sa
namespace: staging
```

=======================================================
EOF
