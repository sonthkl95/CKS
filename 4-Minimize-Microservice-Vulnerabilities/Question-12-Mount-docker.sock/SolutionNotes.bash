#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 3, Question 3
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 3  ·  Question 3
===============================================================

Step 1: Inspect `docker.sock` permissions

```bash
kubectl exec -it <pod-name> -n ci-cd -- ls -l /var/run/docker.sock
# Example output:
# srw-rw---- 1 root docker 0 Aug 25 16:00 /var/run/docker.sock
```

Step 2: Adjust permissions and ownership inside Pod

```bash
kubectl exec -it <pod-name> -n ci-cd -- chown 65535:65535 /var/run/docker.sock
kubectl exec -it <pod-name> -n ci-cd -- chmod 0600 /var/run/docker.sock

# 65535:65535 → unprivileged user (nobody)
# 0600 → only owner can read/write
```

Step 3: Apply `securityContext` for the container

```bash
securityContext:
  runAsUser: 65535
  runAsGroup: 65535
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
  capabilities:
    drop: ["ALL"]
```

Step 4: Verify the changes

```bash
kubectl exec -it <pod-name> -n ci-cd -- ls -l /var/run/docker.sock
# srw------- 1 nobody nobody 0 Aug 21 16:15 /var/run/docker.sock

# Try running docker commands
kubectl exec -it <pod-name> -- docker ps   # should fail if not owner
```

Explanation

`/var/run/docker.sock` is a hostPath socket, granting full Docker access to anyone who can write to it.

Changing ownership to `unprivileged` user prevents rootless escalation through the socket.

Restricting chmod to 0600 ensures no other users in the container or host group can control Docker.

Combined with `runAsUser` and `drop: ALL capabilities`, this significantly reduces the attack surface.

⚠️ Note:

In real environments, it's better to avoid mounting host `docker.sock`. Consider remote Docker API with TLS or Docker-in-Docker.

===============================================================
CKS_SOLUTION_EOF
