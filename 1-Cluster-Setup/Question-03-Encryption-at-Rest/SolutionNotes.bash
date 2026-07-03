#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 1, Question 8
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 1  ·  Question 8
===============================================================

Commands / Steps:

```bash
# Generate a base64-encoded encryption key
head -c 32 /dev/urandom | base64
```

```bash
# /etc/kubernetes/enc/enc.yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: c2VjcmV0IGlzIHNlY3VyZSwgSSB0aGluaw==   # base64-encoded key
      - identity: {}
```

```bash
# Edit kube-apiserver manifest to enable encryption
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

```bash
...
spec:
  containers:
  - command:
    - kube-apiserver
    ...
    - --encryption-provider-config=/etc/kubernetes/enc/enc.yaml
    volumeMounts:
    ...
    - name: enc
      mountPath: /etc/kubernetes/enc
      readOnly: true
  volumes:
  ...
  - name: enc
    hostPath:
      path: /etc/kubernetes/enc
      type: DirectoryOrCreate
```

```bash
# Create a test secret
kubectl create secret generic secret1 -n default --from-literal=mykey=mydata
```

```bash
# Verify encryption in etcd
ETCDCTL_API=3 etcdctl \
   --cacert=/etc/kubernetes/pki/etcd/ca.crt \
   --cert=/etc/kubernetes/pki/etcd/server.crt \
   --key=/etc/kubernetes/pki/etcd/server.key \
   get /registry/secrets/default/secret1 | hexdump -C

# Ensure all existing secrets are re-encrypted with the new configuration
kubectl get secrets --all-namespaces -o json | kubectl replace -f -
ETCDCTL_API=3 etcdctl \
   --cacert=/etc/kubernetes/pki/etcd/ca.crt \
   --cert=/etc/kubernetes/pki/etcd/server.crt \
   --key=/etc/kubernetes/pki/etcd/server.key \
   get /registry/secrets/default/secret1 | hexdump -C
```

Verification Step:

```bash
# Confirm that the secret data in etcd is not plaintext
ETCDCTL_API=3 etcdctl \
   --cacert=/etc/kubernetes/pki/etcd/ca.crt \
   --cert=/etc/kubernetes/pki/etcd/server.crt \
   --key=/etc/kubernetes/pki/etcd/server.key \
   get /registry/secrets/default/secret1 | hexdump -C
```

⚠️ Note:

`aescbc` provider encrypts secret data at rest; `identity` allows unencrypted fallback (for non-secret resources).

Re-applying all secrets (`kubectl get secrets | kubectl replace -f -`) ensures previously created secrets are encrypted.

ETCD secrets are stored at `/registry/secrets/<namespace>/<secret>`; use `etcdctl` to inspect them.

Ensure that the encryption key is safely backed up and rotated periodically.

Requires API server restart after modifying encryption configuration.

===============================================================
CKS_SOLUTION_EOF
