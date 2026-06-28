#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 1 - Question 9
=======================================================

Stateless Pods should not store persistent data inside containers, and immutable Pods should not run as privileged and must have readOnlyRootFilesystem: true.
Any Pod violating these rules should be deleted to maintain cluster security and best practices.

Commands / Steps

```yaml
# Inspect Pods for security context settings
kubectl get pod/app -n prod -o yaml | grep -E 'privileged|readOnlyRootFilesystem'
kubectl get pod/frontend -n prod -o yaml | grep -E 'privileged|readOnlyRootFilesystem'
kubectl get pod/gcc -n prod -o yaml | grep -E 'privileged|readOnlyRootFilesystem'
# Check which Pods have volumes attached (potentially stateful)
kubectl get pods -n prod -o jsonpath="{range .items[*]}{.metadata.name}{': '}{.spec.volumes[*].name}{'\n'}{end}"
# Inspect volumeMounts for a specific Pod
kubectl get pod/frontend -n prod -o yaml | grep volumeMounts -A 5
# Delete Pods that are either stateful or not immutable
kubectl delete --grace-period=0 --force pod app -n prod
kubectl delete --grace-period=0 --force pod gcc -n prod
```

Verification Step:

```yaml
# Verify remaining Pods follow stateless and immutable principles
kubectl get pods -n prod -o yaml | grep -E 'privileged|readOnlyRootFilesystem'
kubectl get pods -n prod -o jsonpath="{range .items[*]}{.metadata.name}{': '}{.spec.volumes[*].name}{'\n'}{end}"
kubectl get pod/frontend -n prod -o yaml | grep volumeMounts -A 5
```

'' Note:
Stateless: Pods should not persist data inside hostPath or persistentVolumeClaim volumes. emptyDir is considered stateless since its content is ephemeral.

Immutable: Pods should not run as privileged and must have readOnlyRootFilesystem: true. Must have readOnlyRootFilesystem: true and privileged: false

ConfigMap/Secret Volumes: May introduce state if the container can modify the mounted files.

Always verify both securityContext and mounted volumes when evaluating Pod immutability and statelessness.

=======================================================
EOF
