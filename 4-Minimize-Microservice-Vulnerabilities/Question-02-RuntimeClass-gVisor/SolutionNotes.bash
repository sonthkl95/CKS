#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 1, Question 10
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 1  ·  Question 10
===============================================================

Commands / Steps

```bash
# Create the RuntimeClass
vim /home/candidate/10/runtime-class.yaml
```

```bash
# runtime-class.yaml
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: "sandboxed"
handler: "runsc"
```

```bash
# Apply the RuntimeClass
kubectl create -f /home/candidate/10/runtime-class.yaml

# List all deployments in the server namespace
kubectl get deployments -n server

# List all Pods in the server namespace
kubectl get pods -n server

# Edit each deployment to add the runtimeClassName
kubectl edit deploy -n server workload1
```

```bash
# Within spec.template.spec of workload1 deployment
runtimeClassName: sandboxed
```

```bash
# Repeat for other deployments
kubectl edit deploy -n server workload2
kubectl edit deploy -n server workload3

# Verify the change
kubectl get deploy -n server workload1 -o yaml | grep runtimeClassName
kubectl get deploy -n server workload2 -o yaml | grep runtimeClassName
kubectl get deploy -n server workload3 -o yaml | grep runtimeClassName

# Pods should now use the 'sandboxed' RuntimeClass
kubectl get pods -n server -o jsonpath="{range .items[*]}{.metadata.name}{': '}{.spec.runtimeClassName}{'\n'}{end}"
```

⚠️ Note:

`runtimeClassName` is added under `spec.template.spec` in Deployments.

Pods will be recreated automatically after updating the Deployment to use the new RuntimeClass.

gVisor (`runsc`) provides extra security by sandboxing containers but may have performance trade-offs.

===============================================================
CKS_SOLUTION_EOF
