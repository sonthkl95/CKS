#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 1 - Question 12
=======================================================

A Pod in the namespace dev-ops is mounting /var/run/docker.sock from the host.
This gives the container privileged access to the host's Docker daemon, which is a serious security risk.
Identify the Pod(s) mounting docker.sock and update their Deployment(s) to remove the volume mount.
Verify that the containers can no longer access /var/run/docker.sock.

=======================================================
EOF
