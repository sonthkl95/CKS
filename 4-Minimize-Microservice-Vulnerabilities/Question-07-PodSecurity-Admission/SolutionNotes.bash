#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 1, Question 14
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 1  ·  Question 14
===============================================================

Commands / Steps

```bash
kubectl get ns secure-team --show-labels
# secure-team   pod-security.kubernetes.io/enforce=restricted
```

```bash
kubectl apply -f /home/masters/insecure-deployment.yaml
```

During each failed attempt while applying the YAML manifest of the given Deployment, the error message in the terminal explicitly indicates which `securityContext` property is non-compliant, making it easy to fix:

```bash
Error: pods "webapp-5c7f6d5c7f-xyz" is forbidden: violates PodSecurity "restricted:latest": spec.containers[0].securityContext.privileged = true
Error: pods "webapp-5c7f6d5c7f-xyz" is forbidden: violates PodSecurity "restricted:latest": spec.containers[0].securityContext.runAsUser = 0
Error: pods "webapp-5c7f6d5c7f-xyz" is forbidden: violates PodSecurity "restricted:latest": spec.volumes[0].hostPath = /tmp
Error: pods "webapp-5c7f6d5c7f-xyz" is forbidden: violates PodSecurity "restricted:latest": spec.containers[0].securityContext.capabilities.add = ["NET_ADMIN"]
```

Inspect the Deployment YAML

```bash
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  namespace: secure-team
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: nginx:1.23
        ports:
        - containerPort: 80
        securityContext:
          privileged: true        # ❌ triggers: .securityContext.privileged=true
          runAsUser: 0            # ❌ triggers: .securityContext.runAsUser=0
          capabilities:
            add: ["NET_ADMIN"]    # ❌ triggers: .capabilities.add=["NET_ADMIN"]
        volumeMounts:
        - mountPath: /data
          name: host-data         # ❌ triggers: spec.volumes[0].hostPath = /tmp
      volumes:
      - name: host-data
        hostPath:
          path: /tmp
```

Modify Deployment to comply with `restricted` profile

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  namespace: secure-team
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: nginx:1.23
        ports:
        - containerPort: 80
        securityContext:
          runAsNonRoot: true
          runAsUser: 65535
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
          capabilities:
            drop: ["ALL"]
        volumeMounts:
        - mountPath: /data
          name: empty-vol
      volumes:
      - name: empty-vol
        emptyDir: {}
```

Apply the modified Deployment

```bash
kubectl apply -f /home/masters/insecure-deployment.yaml
```

Verify the Deployment is running

```bash
kubectl get deploy webapp -n secure-team
kubectl get pods -n secure-team
```

Explanation

`restricted` Pod Security Standard forbids:

Privileged containers

Running as root

HostPath volumes

Adding capabilities

Using `emptyDir` volume and unprivileged user satisfies the policy.

Security context ensures:

Non-root execution (`runAsNonRoot: true`, `runAsUser: 65535`)

Read-only filesystem (`readOnlyRootFilesystem: true`)

No privilege escalation (`allowPrivilegeEscalation: false`)

All Linux capabilities dropped (`capabilities: drop: ["ALL"]`)

After modification, the Pod launches successfully in `secure-team` namespace.

===============================================================
CKS_SOLUTION_EOF
