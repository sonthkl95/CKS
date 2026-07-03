#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 1, Question 16
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 1  ·  Question 16
===============================================================

Commands / Steps

Create a custom Falco rule file `rule.yaml`:

```bash
- rule: read write below /dev/mem
  desc: An attempt to read or write to /dev/mem directory
  condition: >
    ((evt.is_open_read=true or evt.is_open_write=true) and fd.name contains /dev/mem)
  output: "Process %proc.name accessed /dev/mem (command=%proc.cmdline user=%user.name container=%container.id image=%container.image.repository pod_name=%k8s.pod.name namespace=%k8s.ns.name)"
  priority: WARNING
  tags: [security]
```

Run Falco `manually` with the `custom rule file`:

```bash
falco -r rule.yaml  | grep -i 'dev/mem'
```

Check Falco output/logs for alerts:

```bash
# Example alert:
23:15:42.567890: Warning Process evil-binary accessed /dev/mem (command=evil-binary user=root container=abc123 image=malicious/image pod_name=mem-hacker-7d89d9c7f8-xyz namespace=default)
```

```bash
→ Pod: mem-hacker-7d89d9c7f8-xyz
→ Namespace: default
→ Deployment: mem-hacker
```

Identify the Deployment that owns the container if only `container ID` is available, map it back to `Pod/Deployment`:

```bash
# Using crictl to find the container
crictl ps -id abc123
crictl pods -id <pod_id>
kubectl get pod -A | grep mem-hacker
```

Scale the Deployment replicas to `0`:

```bash
kubectl scale deployment mem-hacker --replicas=0 -n default
```

Verify scaling:

```bash
kubectl get deploy mem-hacker -n default
```

Expected output:

```bash
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
mem-hacker   0/0     0            0           1m
```

Explanation of Falco Rule:

Falco rules use system call fields to filter events. For /dev/mem monitoring:

`evt.is_open_read=true` → matches syscalls like `open`, `openat`, `openat2`, `open_by_handle_at` with read flag.

`evt.is_open_write=true` → same syscalls but with write flag.

Combined condition detects attempts to open `/dev/mem` with read or write permissions.

👉 If you also want to detect actual read/write operations:

```bash
((evt.is_open_read=true or evt.is_open_write=true) or evt.type in (read, write)) and fd.name contains /dev/mem
```

👉 If you want to monitor only open attempts:

```bash
(evt.is_open_read=true or evt.is_open_write=true) and fd.name contains /dev/mem
```

⚠️ Common mistake:

Writing something like:

```bash
evt.is_open_read=true and evt.type=read
```

will never match, because `evt.is_open_read` exists only for open-related syscalls, not for read/write syscalls.

⚠️ Note:

Created a Falco rule to detect `/dev/mem`access.

Ran Falco and caught the malicious Pod.

Identified the Deployment (`mem-hacker`).

Scaled replicas to 0 to stop the attack.

`open_by_handle_at`: this is a rare syscall used in advanced file APIs. Falco includes it so that rules reliably cover all ways a process might open a file.

===============================================================
CKS_SOLUTION_EOF
