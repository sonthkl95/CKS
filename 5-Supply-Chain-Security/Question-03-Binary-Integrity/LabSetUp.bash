#!/bin/bash
# LabSetUp.bash - Question 3: Binary Integrity
set -e

DIR="/opt/candidate/15/binaries"
mkdir -p "$DIR"

echo "🔹 Generating dummy binaries..."

# Valid kube-apiserver
echo "valid-kube-apiserver-content" > "$DIR/kube-apiserver"
# Overwrite with exact hash string requested (simulating it matching by just giving it a known hash,
# but to make it real, we'll just write something and update the Questions.bash hash manually if needed.
# Actually, the easiest way to mock this is to create a fake sha512sum check file.)

# Let's create files that match specific hashes
# Wait, we can't easily reverse-engineer a file to match a specific sha512 hash.
# So instead, let's create random files and provide their hashes in the instructions,
# EXCEPT one file which will be altered.

echo "Re-writing Question 3 hashes based on generated files..."

echo "data1" > "$DIR/kube-apiserver"
echo "data2" > "$DIR/kube-controller-manager"
echo "data3" > "$DIR/kube-proxy"
echo "data4" > "$DIR/kubelet"

HASH1=$(sha512sum "$DIR/kube-apiserver" | awk '{print $1}')
HASH2=$(sha512sum "$DIR/kube-controller-manager" | awk '{print $1}')
HASH3=$(sha512sum "$DIR/kube-proxy" | awk '{print $1}')
HASH4=$(sha512sum "$DIR/kubelet" | awk '{print $1}')

# Now tamper with one or two of them
echo "tampered-data" > "$DIR/kube-controller-manager"
echo "tampered-data" > "$DIR/kube-proxy"

# Update the Questions.bash file with the EXPECTED hashes
sed -i "s/a3b9e5c4f7d21e89bc317f0e91a7c845df1100d2fb8cc63dff9e40a9e5a2a3c6bb8aa4e4579de9b136d65b18b7d6eae4c3f26de982e537a0a4a1ef8bb1c27c5f/$HASH1/" ../Question-15-Binary-Integrity/Questions.bash
sed -i "s/b7a223f9918b94e5d6479fcf41da0cd2d93ce0fd102e5c770d1c9b6c82e1a2ad84cbbd54cdd7a4a98fd6133b0b5e6a981a45b0a9cbf24a93980f89ac56c9f47f/$HASH2/" ../Question-15-Binary-Integrity/Questions.bash
sed -i "s/4d9917ea90a3f8ccbe3a607f5c9aeeecb7113a9c02a8e55c5bda6f73dd6b5a7c1b928d0169ea3a8b2c5ddbc0285d54a9d76c9c36f7b8ab7b17d5d8f39d1444a2/$HASH3/" ../Question-15-Binary-Integrity/Questions.bash
sed -i "s/8f1c29d7c8b2f491d512accb04a6d028dcdb3fc6a5b7b890f432e77e3217a90d92c2b4a3d98c8d49e19d3f80ad29348db216d31cbf96f82d19976f3251d9b887/$HASH4/" ../Question-15-Binary-Integrity/Questions.bash

echo "✅ Lab setup complete!"
echo "📋 Binaries are ready in $DIR"
echo "📋 Two of them have been tampered with!"
