#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 1, Question 12
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 1  ·  Question 12
===============================================================

Step 1: Identify Pods mounting `/var/run/docker.sock`

```bash
kubectl get pods -n dev-ops -o jsonpath='{range .items[*]}{.metadata.name}{" - "}{.spec.containers[*].name}{"\n"}{end}'
kubectl get pods -n dev-ops -o yaml | grep -A 3 "hostPath.*docker.sock"
```

Example output:

```bash
docker-hacker-7d9f8   container1
# volumeMounts:
# - mountPath: /var/run/docker.sock
#   name: dockersock
```

Step 2: Identify the Deployment managing the Pod

```bash
kubectl get deploy -n dev-ops
kubectl describe pod docker-hacker-7d9f8 -n dev-ops
# Look for OwnerReferences -> Deployment
```

Step 3: Edit Deployment to remove `/var/run/docker.sock` mount

```bash
kubectl edit deploy docker-hacker -n dev-ops
```

Modify the spec.template.spec.containers.volumeMounts section:

```bash
volumeMounts:
  # remove the entry:
  # - mountPath: /var/run/docker.sock
  #   name: dockersock
```

Also remove the corresponding volumes entry:

```bash
volumes:
  # remove the entry:
  # - name: dockersock
  #   hostPath:
  #     path: /var/run/docker.sock
```

Step 4: Verify the Pod is recreated without `/var/run/docker.sock`

```bash
kubectl rollout status deploy/docker-hacker -n dev-ops
kubectl get pods -n dev-ops -o yaml | grep -A 3 "docker.sock"
```

Expected: No Pod should have `/var/run/docker.sock` mounted.

Step 5: Optional validation inside container

```bash
kubectl exec -it <pod-name> -n dev-ops -- ls -l /var/run/docker.sock
# Expected: ls: cannot access '/var/run/docker.sock': No such file or directory
```

Explanation

Mounting `/var/run/docker.sock` allows a container to control the Docker daemon on the host, including creating or deleting containers and modifying the host filesystem.

Removing the volume mount mitigates this privilege escalation risk.

Always ensure sensitive host paths like `/var/run/docker.sock` are not mounted into untrusted Pods.

⚠️ Note:

In real environments, consider using Pod Security `Policies / Pod Security Admission / seccomp` to prevent hostPath mounts like `docker.sock.`

Any container that truly requires Docker access should run on a dedicated, isolated host.

===============================================================
CKS_SOLUTION_EOF
