#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 2 - Question 4
=======================================================

Falco is a runtime security tool that monitors system calls and detects anomalous container behavior. This task configures Falco to log newly spawned processes into a structured incident file.

Commands / Steps:

```yaml
# SSH into the worker node
ssh node-01
# Switch to root
sudo -i
# Inspect Falco configuration directory
ls -l /etc/falco
# Edit custom Falco rules
vim /etc/falco/falco_rules.local.yaml
```

```yaml
# Example Falco rule to detect new executable creation in containers
- rule: Container Drift Detected
desc: New executable created in a container
condition: >
evt.type in (open,openat,creat) and evt.is_open_exec=true and container
and not runc_writing_exec_fifo
and not runc_var_lib_docker and not user_known_container_drift_activities
and evt.rawres>=0
output:
%evt.time,%user.uid,%proc.name
priority: ERROR
tags: [security]
```

```yaml
# Edit Falco main configuration for logging output
vim /etc/falco/falco.yaml
```

```yaml
# Example file output configuration
log_stderr: true
log_syslog: true
log_file: /opt/node-01/alerts/details
# Or on newer versions
file_output:
enabled: true
keep_alive: false
filename: /opt/node-01/alerts/details
```

```yaml
# Verify Falco configuration
grep -i log /etc/falco/falco.yaml
grep -i file_output -A 3 /etc/falco/falco.yaml
# Start or restart Falco service
systemctl status falco.service
systemctl start falco.service
# or if Falco installed as a binary
falco -U -r /etc/falco/falco_rules.local.yaml
falco -M 500 -r /etc/falco/falco_rules.local.yaml
# Exit the node
exit
```

Verification Step:
Monitor the incident file for detected events:

```yaml
tail -f /opt/node-01/alerts/details
```

Confirm that each line follows the format: timestamp,uid/username,processName

Ensure new container processes are detected within ~30 seconds of execution.

'' Note:
Falco rules can be customized to include or exclude specific containers or events.

Ensure Falco has sufficient permissions to monitor container processes.

File-based logging path must exist (/opt/node-01/alerts/) and be writable by Falco.

=======================================================
EOF
