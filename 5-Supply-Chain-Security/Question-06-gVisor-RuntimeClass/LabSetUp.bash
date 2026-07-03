#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Preparing output directory /opt/course/7 ..."
mkdir -p /opt/course/7
echo ""
echo "[!] NOTE: this task requires the 'runsc' (gVisor) runtime handler configured in containerd,"
echo "    and a node named 'node-02'."
echo ""
echo "[i] Task: create RuntimeClass 'untrusted' (handler runsc), deploy Pod 'untrusted'"
echo "    (image alpine:3.18) on node-02, and save 'dmesg' output to /opt/course/7/untrusted-test-dmesg."
echo "[+] Lab Setup Complete."
