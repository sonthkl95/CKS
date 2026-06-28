#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 2 - Question 6
=======================================================

KubeSec evaluates Kubernetes manifests for security best practices. It checks fields such as running as non-root, capabilities, privilege escalation, and read-only root filesystem. Adjusting the manifest according to KubeSec suggestions improves security posture.

Commands / Steps:

```yaml
# Scan the Pod manifest using KubeSec Docker image
docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < kubesec-test.yaml
# Scan the Pod manifest using KubeSec binary
kubesec scan kubesec-test.yaml
```

```yaml
# Original kubesec-test.yaml
apiVersion: v1
kind: Pod
metadata:
name: kubesec-demo
spec:
containers:
- name: kubesec-demo
image: gcr.io/google-samples/node-hello:1.0
securityContext:
readOnlyRootFilesystem: true
allowPrivilegeEscalation: true
capabilities:
add:
- SYS_ADMIN
```

Example result (simplified):

```yaml
[
{
"object": "Pod/kubesec-demo.default",
"valid": true,
"message": "Failed with a score of -30 points",
"score": -30,
"scoring": {
"critical": [
{
"selector": "containers[] .securityContext .runAsNonRoot == true",
"reason": "Force the running image to run as a non-root user to ensure least privilege"
},
{
"selector": "containers[] .securityContext .capabilities .add == SYS_ADMIN",
"reason": "CAP_SYS_ADMIN is the most privileged capability and should always be avoided"
}
]
}
}
]
```

KubeSec suggests the following changes:
runAsNonRoot: true

runAsUser: 1000

allowPrivilegeEscalation: false

capabilities.drop: ["ALL"]

readOnlyRootFilesystem: true (already present)

```yaml
# Edit the Pod manifest to apply KubeSec recommendations
vim kubesec-test.yaml
```

```yaml
# Updated kubesec-test.yaml
apiVersion: v1
kind: Pod
metadata:
name: kubesec-demo
spec:
containers:
- name: kubesec-demo
image: gcr.io/google-samples/node-hello:1.0
securityContext:
runAsUser: 1000
runAsNonRoot: true
allowPrivilegeEscalation: false
readOnlyRootFilesystem: true
capabilities:
drop:
- ALL
```

```yaml
# Re-scan the updated manifest to verify improvements
docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < kubesec-test.yaml
```

Verification Step:
Confirm that the manifest passes KubeSec scoring with a positive score ('4)

Ensure the following security constraints are enforced:
Container runs as non-root (runAsNonRoot: true, runAsUser: 1000)

No privilege escalation (allowPrivilegeEscalation: false)

All additional Linux capabilities are dropped (capabilities.drop: ["ALL"])

Root filesystem is read-only (readOnlyRootFilesystem: true)

'' Note:
KubeSec provides detailed scoring for each security field.

Using the Docker image ensures no local installation of KubeSec is required.

Always review and apply recommendations for production manifests to enforce security best practices.

=======================================================
EOF
