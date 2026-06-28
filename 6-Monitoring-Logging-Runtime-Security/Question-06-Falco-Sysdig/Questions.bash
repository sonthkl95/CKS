#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 3 - Question 7
=======================================================

Use Falco or Sysdig to monitor a single-container Pod named tomcat for anomalous process activity.
Detect processes that spawn or execute unusual commands over a period of at least 40 seconds.
Store detected incidents on the worker node in /home/anomalous/report with the format [timestamp],[uid],[processName].

=======================================================
EOF
