#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 4 - Question 1
=======================================================

A Deployment docker-admin in namespace sandbox mounts /var/run/docker.sock from the host.
This gives the container full control over the Docker daemon, which allows privilege escalation.
Instead of removing the Pod entirely, your task is to reduce the risk by restricting its permissions using Kubernetes security mechanisms.
Specifically, you should:
Ensure the Pod does not run as root.

Drop all Linux capabilities except those required.

Enforce read-only filesystem where possible.

=======================================================
EOF
