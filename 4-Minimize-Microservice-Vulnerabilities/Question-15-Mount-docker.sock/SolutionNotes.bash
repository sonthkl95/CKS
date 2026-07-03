#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 4, Question 1
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 4  ·  Question 1
===============================================================

Commands/Steps

Step 1: Inspect the Pod for `docker.sock`mount

```bash
kubectl get pods -n sandbox -o yaml | grep -A 3 "docker.sock"
kubectl describe pod <pod-name> -n sandbox
```

Step 2: Edit `Deployment`to apply `securityContext`

```bash
kubectl edit deploy docker-admin -n sandbox
```

Modify the `spec.template.spec.containers.securityContext` section:

```bash
spec:
  template:
    spec:
      containers:
      - name: docker-container
        image: docker:20.10
        securityContext:
          runAsUser: 65535           # run as unprivileged user
          runAsGroup: 65535
          readOnlyRootFilesystem: true
          allowPrivilegeEscalation: false
          capabilities:
            drop: ["ALL"]             # drop all Linux capabilities
```

Step 3: Optionally, restrict hostPath mount

If `docker.sock` must be present for functionality, mark it read-only:

```bash
spec:
  template:
    spec:
      containers:
      - name: docker-container
        image: docker:20.10
        volumeMounts:
        - name: dockersock
          mountPath: /var/run/docker.sock
          readOnly: true
```

Step 4: Verify the changes

```bash
# Confirm the Pod is recreated
kubectl rollout status deploy/docker-admin -n sandbox
# Confirm securityContext applied
kubectl get pod -n sandbox <pod-name> -o jsonpath='{.spec.containers[0].securityContext}'

# Confirm read-only filesystem
kubectl exec -it <pod-name> -- touch /tmp/testfile   # should fail

# Confirm Docker socket read-only
kubectl exec -it <pod-name> -- docker ps            # should work
kubectl exec -it <pod-name> -- docker run ...       # should fail if read-only mount
```

Explanation

`runAsUser / runAsGroup`: prevents the container from running as root, limiting access to host resources.

`readOnlyRootFilesystem`: prevents write access to the container filesystem.

`allowPrivilegeEscalation: false`: ensures the container cannot gain more privileges than its initial UID.

`Drop ALL capabilities`: prevents direct kernel-level operations; only minimal capabilities remain.

`docker.sock read-only`: limits ability to modify containers, still allows reading logs or status.

⚠️ Note:

Even with these mitigations, mounting `docker.sock` is inherently risky. In real environments, prefer Docker-in-Docker or remote API with TLS, not host socket.

===============================================================
CKS_SOLUTION_EOF
