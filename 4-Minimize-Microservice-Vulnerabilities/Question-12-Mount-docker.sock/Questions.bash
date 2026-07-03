#!/bin/bash
# Questions.bash  —  CKS Practice Test 3, Question 3
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 3  ·  Question 3
===============================================================

A Pod in namespace `ci-cd` mounts `/var/run/docker.sock` from the host.
By default, the socket is owned by root:docker with permissions `0660`, allowing any user in group docker to control the Docker daemon.

Your task is to reduce the risk by restricting file permissions without breaking essential CI/CD jobs.
Specifically:

Change ownership and group of `docker.sock` inside the Pod.

Limit access using chmod so that only the intended user can access the socket.

Verify that the container cannot run arbitrary containers if not authorized.

===============================================================
CKS_TASK_EOF
