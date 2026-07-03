#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 2, Question 11
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 2  ·  Question 11
===============================================================

The API server controls cluster authentication/authorization. CIS requires strict authorization modes (`Node`, `RBAC`).

The Kubelet must not allow unauthenticated access; it should authenticate via the API server (Webhook).

etcd is critical for Kubernetes state storage and must enforce TLS + client certificate authentication.

Steps

1. Fix API Server configuration

```bash
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

```bash
# /etc/kubernetes/manifests/kube-apiserver.yaml (flags section)
- --authorization-mode=Node,RBAC
```

```bash
✅ Removed AlwaysAllow.
✅ Added Node and RBAC.
The static pod will restart automatically after saving.
```

2. Fix Kubelet configuration

```bash
ps -ef | grep kubelet   # locate kubelet config file path
vim /var/lib/kubelet/config.yaml
```

```bash
# /var/lib/kubelet/config.yaml
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
authentication:
  anonymous:
    enabled: false          # 🔒 Disable anonymous auth
  webhook:
    enabled: true           # ✅ Enable API server webhook
  x509:
    clientCAFile: /etc/kubernetes/pki/ca.crt
authorization:
  mode: Webhook             # 🔐 Use centralized authorization
```

```bash
✅ Disabled anonymous authentication.
✅ Set authorization mode to Webhook.
```

```bash
# Reload and restart Kubelet:
systemctl daemon-reload
systemctl restart kubelet
systemctl status kubelet
```

3. Fix etcd configuration

```bash
vim /etc/kubernetes/manifests/etcd.yaml
```

```bash
# /etc/kubernetes/manifests/etcd.yaml (flags section)
- --cert-file=/etc/kubernetes/pki/etcd/server.crt
- --key-file=/etc/kubernetes/pki/etcd/server.key
- --client-cert-auth=true         # ✅ Enforce client cert auth
- --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
- --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
- --peer-client-cert-auth=true    # ✅ Mutual peer authentication
- --auto-tls=false                # ❌ Do not auto-generate TLS
```

```bash
✅ Enabled client cert auth.
✅ Enabled peer client cert auth.
✅ Disabled auto-tls.
Ensure etcd is using `valid CA-signed` certs stored in /etc/kubernetes/pki/etcd/.
Static pod will restart automatically after saving.
```

4. Verify CIS compliance

```bash
# Check API Server flags
ps -ef | grep kube-apiserver | grep authorization-mode

# Should show `Node,RBAC`:

--authorization-mode=Node,RBAC
```

```bash
# Check Kubelet config
curl -sk https://127.0.0.1:10250/metrics | head -n 5

Should `fail` without auth
```

```bash
kubectl get --raw /api/v1/nodes | jq .

Should work (via authenticated request)
```

```bash
# Check etcd flags
ps -ef | grep etcd | grep cert

Should include `--client-cert-auth=true` and `--auto-tls=false`
```

```bash
# Rerun CIS scan kube-bench
kube-bench run --targets=master,node,etcd
```

```bash
- target master — checks kube-apiserver, kube-controller-manager, scheduler, etcd, kubelet (on master)
- target node — checks kubelet, kube-proxy, cni (on nodes)
- target etcd — checks etcd (certs, access, etc)

Expected: ✅ all listed violations resolved.
Should show `PASS` for all findings.
```

⚠️ Note:

`AlwaysAllow` is insecure and must not be used.

`Node` ensures kubelet-to-apiserver communication authorization.

`RBAC` enforces role-based access control for users and workloads.

`etcd` without TLS is a critical security risk — certificates are mandatory

===============================================================
CKS_SOLUTION_EOF
