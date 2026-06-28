#!/bin/bash
cat << 'EOF'
=======================================================
  CKS Practice Test 2 - Question 4
=======================================================

Monitor container behavior on a worker node using Falco or any similar tool to detect newly spawning and executing processes:
Analyze containers for at least 30 seconds using process execution filters.

Store detected incidents in /opt/node-01/alerts/details in the format: timestamp,uid/username,processName.

Example of a properly formatted incident file:

```yaml
2025-08-10T17:45:17.123Z,root,init
2025-08-10T17:45:20.124Z,1001,bash
2025-08-10T17:45:25.125Z,1002,sleep
2025-08-10T17:45:30.125Z,1010,curl
```

=======================================================
EOF
