#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 3 - Question 15
=======================================================

The sha512sum --check command validates a file against a known checksum.

Any mismatch indicates the file is tampered or corrupted.

Only files matching their expected checksum should remain; others must be deleted.

Commands / Steps

```yaml
# Move into directory with binaries
cd /opt/candidate/47/binaries
# Verify kube-apiserver
echo "a3b9e5c4f7d21e89bc317f0e91a7c845df1100d2fb8cc63dff9e40a9e5a2a3c6bb8aa4e4579de9b136d65b18b7d6eae4c3f26de982e537a0a4a1ef8bb1c27c5f  kube-apiserver" | sha512sum --check
# Verify kube-controller-manager
echo "b7a223f9918b94e5d6479fcf41da0cd2d93ce0fd102e5c770d1c9b6c82e1a2ad84cbbd54cdd7a4a98fd6133b0b5e6a981a45b0a9cbf24a93980f89ac56c9f47f  kube-controller-manager" | sha512sum --check
# Verify kube-proxy
echo "4d9917ea90a3f8ccbe3a607f5c9aeeecb7113a9c02a8e55c5bda6f73dd6b5a7c1b928d0169ea3a8b2c5ddbc0285d54a9d76c9c36f7b8ab7b17d5d8f39d1444a2  kube-proxy" | sha512sum --check
# Verify kubelet
echo "8f1c29d7c8b2f491d512accb04a6d028dcdb3fc6a5b7b890f432e77e3217a90d92c2b4a3d98c8d49e19d3f80ad29348db216d31cbf96f82d19976f3251d9b887  kubelet" | sha512sum --check
# Remove binaries that FAILED integrity check
rm -f kube-controller-manager kubelet
```

Verification Step:

```yaml
# Confirm that only valid binaries remain
ls -l /opt/candidate/47/binaries
# Double-check valid ones
sha512sum kube-apiserver kube-proxy
```

'' Note:
The kube-apiserver and kube-proxy passed verification.

The kube-controller-manager and kubelet failed and were removed.

=======================================================
EOF
