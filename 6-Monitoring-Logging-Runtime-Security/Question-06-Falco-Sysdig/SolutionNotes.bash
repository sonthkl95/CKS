#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 3 - Question 7
=======================================================

Falco and Sysdig can monitor container activity in real time.
Here, a custom Falco rule captures newly executed processes inside containers.
The incident file is stored on the worker node to comply with best practices and avoid moving sensitive data to the master.

Commands / Steps

Step 1: Connect to the worker node

```yaml
# Connect to the worker node
ssh node-01
sudo -i
# Edit Falco rules to detect container drift
vim /etc/falco/falco_rules.local.yaml
```

Step 2: Add the following rule

```yaml
- rule: Container Drift Detected
desc: New executable created in a container
condition: >
evt.type in (open,openat,creat) and evt.is_open_exec=true and container
and not runc_writing_exec_fifo and not runc_var_lib_docker
and not user_known_container_drift_activities and evt.rawres>=0
output:
[%evt.time],[%user.uid],[%proc.name]
priority: ERROR
tags: [security]
```

Step 3:  Check Falco service, PID and logs

```yaml
# Check Falco service and PID
systemctl cat falco.service
cat /var/run/falco.pid
# Reload Falco to pick up the new rules
kill -1 $(cat /var/run/falco.pid)
# Or restart the service
systemctl restart falco.service
systemctl status falco.service
# Check Falco logs
journalctl -f -u falco.service  | grep -oP '<incident format to match>'
```

Step 4: If installed as a binary, run falco manually against the local rules

```yaml
# Run falco manually against the local rules
falco -U -r /etc/falco/falco_rules.local.yaml
# Capture incidents and filter them for the report
falco -M 500 -r /etc/falco/falco_rules.local.yaml | grep -oP '<incident format to match>'
# Save the filtered output to the report file
vim /home/anomalous/report
```

Optional: Check or configure output file location

```yaml
grep -i log /etc/falco/falco.yaml
grep -i file_output -A 3 /etc/falco/falco.yaml
vim /etc/falco/falco.yaml
# Example configuration for file output
file_output:
enabled: true
keep_alive: false
filename: /opt/node-01/alerts/details
# Exit the worker node session
exit
```

'' Note:
Ensure Falco is installed and running on the worker node.

Adjust the falco rule conditions based on your specific requirements.

The rule captures newly executed processes inside containers only.

evt.rawres>=0 ensures only successful executions are captured

Output format [timestamp],[uid],[processName] must be preserved for the incident report

The -M 500 flag in falco -M 500 sets the maximum number of events to process per second.

This is useful for performance tuning, if your system generates a huge number of system calls, limiting the rate prevents Falco from being overwhelmed.

The -U flag in falco -U ensures Falco runs in unbuffered mode.

The -r flag in falco -r tells Falco which rules file to use. Here, /etc/falco/falco_rules.local.yaml is a custom rules file.

Falco evaluates system activity against these rules and triggers alerts when something matches.

Falco logs must remain on the worker node; do not transfer raw logs to master.

Sysdig can also be used to observe process activity but Falco provides more automated detection.

=======================================================
EOF
