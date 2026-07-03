#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 1, Question 7
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 1  ·  Question 7
===============================================================

Step 1: Run kube-bench checks

```bash
kube-bench run --targets=master,node,etcd
# Run master checks (apiserver, controller-manager, scheduler, etcd, kubelet-on-master)
kube-bench run --targets=master
# Run node (kubelet) checks
kube-bench run --targets=node --check "4.*"
# Run etcd checks
kube-bench run --targets=etcd
```

Step 2: Fix API Server configuration

Edit `/etc/kubernetes/manifests/kube-apiserver.yaml`:

```bash
# /etc/kubernetes/manifests/kube-apiserver.yaml (flags section)
- --authorization-mode=Node,RBAC
- --feature-gates=RotateKubeletServerCertificate=true
- --enable-admission-plugins=...,PodSecurityPolicy
- --kubelet-certificate-authority=/etc/kubernetes/pki/ca.crt
```

Step 3: Fix Kubelet configuration

Check kubelet process:

```bash
ps -ef | grep kubelet
```

Edit `/var/lib/kubelet/config.yaml`:

```bash
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: /etc/kubernetes/pki/ca.crt

authorization:
  mode: Webhook
```

```bash
sudo systemctl daemon-reexec
sudo systemctl restart kubelet
```

Step 4: Fix ETCD configuration

Edit `/etc/kubernetes/manifests/etcd.yaml`:

```bash
# /etc/kubernetes/manifests/etcd.yaml (flags section)
- --auto-tls=false
- --peer-auto-tls=false
```

Step 5: Verify fixes

```bash
kube-bench run --targets=master,node,etcd
kubectl get pods -n kube-system
```

Issues Fixed:

API Server:

Enforced `RotateKubeletServerCertificate=true`.

Added admission plugin `PodSecurityPolicy`.

Configured `--kubelet-certificate-authority` for secure kubelet communication.

Kubelet:

Disabled anonymous authentication.

Configured `authorization-mode=Webhook`

ETCD:

Disabled `--auto-tls` and `--peer-auto-tls` to prevent insecure self-signed certs.

===============================================================
CKS_SOLUTION_EOF
