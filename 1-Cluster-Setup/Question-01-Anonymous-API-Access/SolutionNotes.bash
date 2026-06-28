#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 1 - Question 4
=======================================================

Step 1: Secure kube-apiserver configuration

Edit /etc/kubernetes/manifests/kube-apiserver.yaml:

```yaml
- --authorization-mode=Node,RBAC
- --enable-admission-plugins=NodeRestriction
- --anonymous-auth=false
- --client-ca-file=/etc/kubernetes/pki/ca.crt
```

Remove any insecure options such as AlwaysAllow or AlwaysAdmit.

Step 2: Remove anonymous ClusterRoleBinding

Check and delete:

```yaml
kubectl get clusterrolebinding | grep 'system:anonymous'
kubectl delete clusterrolebinding system:anonymous
```

Step 4: Verify

Check system pods to confirm access works with authenticated config:

```yaml
kubectl get pods -n kube-system --kubeconfig /etc/kubernetes/admin.conf
```

'' Note:
Setting --anonymous-auth=false ensures no unauthenticated requests are processed.

Authorization is now enforced via Node + RBAC.

NodeRestriction admission controller prevents kubelets from modifying objects outside their scope.

--client-ca-file ensures secure communication between API server and clients.

After cleanup, only authenticated + authorized users (e.g., kubernetes-admin) can access the cluster

=======================================================
EOF
