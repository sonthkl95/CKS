#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 2, Question 13
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 2  ·  Question 13
===============================================================

Port 389 typically belongs to an LDAP service (`slapd`). Using tools like `netstat`, `ss`, or `lsof`, you can find the PID. The `/proc/<PID>/fd` directory contains all open file descriptors. The binary path can be obtained from `/proc/<PID>/exe`.

Commands / Steps:

```bash
# Switch to root
sudo -i

# Find the PID of the process listening on port 389
netstat -tulpn | grep :389
# or
ss -tulpn | grep :389
# or
lsof -i :389
```

```bash
# Example output:
tcp   LISTEN  0  128  0.0.0.0:389   0.0.0.0:*  users:(("slapd",pid=1234,fd=9))
```

```bash
# List all open files for the process and save to file
ls -l /proc/1234/fd > /candidate/13/files.txt
# or with real file paths
ls -l /proc/1234/fd | awk '{print $NF}' > /candidate/13/files.txt
# or using readlink for absolute paths
readlink -f /proc/1234/fd/* > /candidate/13/files.txt

# Find the path to the executable binary
readlink -f /proc/1234/exe
# or
ls -l /proc/1234/exe
# or
ps -fp 1234

# Suppose the binary is /usr/sbin/slapd, stop and delete it
kill -9 1234
rm -f /usr/sbin/slapd
```

Verification Step:

Confirm the process is stopped and the binary is deleted:

```bash
top -p 1234
ps -p 1234
ls -l /usr/sbin/slapd
```

Check that /candidate/11/files.txt contains all previously opened files:

```bash
cat /candidate/13/files.txt
```

⚠️ Note:

Use caution when killing and deleting system binaries; this is destructive.

`/proc/<PID>/fd` contains symbolic links to all open file descriptors for the process.

Ensure you have sufficient privileges (`sudo`) to access `/proc` and remove binaries.

===============================================================
CKS_SOLUTION_EOF
