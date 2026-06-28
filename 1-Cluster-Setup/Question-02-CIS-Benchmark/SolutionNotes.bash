#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 1 - Question 7
=======================================================

Step 1: Run kube-bench checks

```yaml
kube-bench run --targets=master,node,etcd
# Run master checks (apiserver, controller-manager, scheduler, etcd, kubelet-on-master)
kube-bench run --targets=master
# Run node (kubelet) checks
kube-bench run --targets=node --check "4.*"
# Run etcd checks
kube-bench run --targets=etcd
```

Step 2: Fix API Server configuration

Edit /etc/kubernetes/manifests/kube-apiserver.yaml:

```yaml
# /etc/kubernetes/manifests/kube-apiserver.yaml (flags section)
- --authorization-mode=Node,RBAC
- --feature-gates=RotateKubeletServerCertificate=true
- --enable-admission-plugins=...,PodSecurityPolicy
- --kubelet-certificate-authority=/etc/kubernetes/pki/ca.crt
```

Step 3: Fix Kubelet configuration

Check kubelet process:

```yaml
ps -ef | grep kubelet
```

Edit /var/lib/kubelet/config.yaml:

```yaml
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

```yaml
sudo systemctl daemon-reexec
sudo systemctl restart kubelet
```

Step 4: Fix ETCD configuration

Edit /etc/kubernetes/manifests/etcd.yaml:

```yaml
# /etc/kubernetes/manifests/etcd.yaml (flags section)
- --auto-tls=false
- --peer-auto-tls=false
```

Step 5: Verify fixes

```yaml
kube-bench run --targets=master,node,etcd
kubectl get pods -n kube-system
```

Issues Fixed:
API Server:
Enforced RotateKubeletServerCertificate=true.

Added admission plugin PodSecurityPolicy.

Configured --kubelet-certificate-authority for secure kubelet communication.

Kubelet:
Disabled anonymous authentication.

Configured authorization-mode=Webhook

ETCD:
Disabled --auto-tls and --peer-auto-tls to prevent insecure self-signed certs.

=======================================================
EOF
