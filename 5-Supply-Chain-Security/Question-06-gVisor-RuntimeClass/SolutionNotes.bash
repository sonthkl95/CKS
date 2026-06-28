#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 2 - Question 7
=======================================================

RuntimeClasses allow running Pods with different container runtimes such as gVisor for additional isolation. This task sets up a Pod with gVisor, ensuring it runs securely and verifies runtime logs via dmesg.

Commands / Steps:

```yaml
# Create RuntimeClass manifest
vim untrusted-rc.yaml
```

```yaml
# untrusted-rc.yaml
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
name: untrusted
handler: runsc
```

```yaml
# Apply the RuntimeClass
kubectl create -f untrusted-rc.yaml
# Generate Pod manifest using dry-run
kubectl run untrusted --image=alpine:3.18 --dry-run=client \
-o yaml > untrusted-po.yaml --command -- /bin/sh -c "sleep 3600"
# Edit Pod manifest to set nodeName and runtimeClassName
vim untrusted-po.yaml
```

```yaml
# untrusted-po.yaml
apiVersion: v1
kind: Pod
metadata:
name: untrusted
labels:
run: untrusted
spec:
nodeName: node-02
runtimeClassName: untrusted
containers:
- name: untrusted
image: alpine:3.18
command:
- /bin/sh
- -c
- sleep 3600
resources: {}
```

```yaml
# Create the Pod
kubectl create -f untrusted-po.yaml
# Capture dmesg output from the running Pod
kubectl exec untrusted > /opt/course/7/untrusted-test-dmesg -- dmesg
```

Verification Step:
Confirm the Pod is running on the correct node and runtime class:

```yaml
kubectl get pod untrusted -o wide
kubectl get pod untrusted -o jsonpath='{.spec.runtimeClassName}'
```

Verify that /opt/course/7/untrusted-test-dmesg contains the dmesg output:

```yaml
tail -f /opt/course/7/untrusted-test-dmesg
```

'' Note:
Ensure gVisor (runsc) is installed and the RuntimeClass is supported on the cluster.

runtimeClassName in the Pod spec determines which container runtime the Pod uses.

dmesg output provides kernel-level messages useful for verifying runtime isolation.

=======================================================
EOF
