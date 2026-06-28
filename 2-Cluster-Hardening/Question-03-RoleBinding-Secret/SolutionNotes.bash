#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 2 - Question 9
=======================================================

Kubernetes client authentication is certificate-based. This task demonstrates creating a user with a signed certificate, configuring kubeconfig, and enforcing namespace RBAC permissions.

Commands / Steps:

```yaml
# Switch to root
sudo -i
# Create namespace for the user
kubectl create namespace john
# Generate private key and CSR for user john
openssl genrsa -out john.key 3072
openssl req -new -key john.key -out john.csr -subj "/CN=john/O=devs"
# Encode CSR for Kubernetes
cat john.csr | base64 | tr -d "\n"
```

```yaml
# Create CSR object in Kubernetes
cat <<E O F | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
name: john-csr
spec:
request: <base64-encoded-csr>
signerName: kubernetes.io/kube-apiserver-client
expirationSeconds: 86400
usages:
- client auth
E O F
```

```yaml
# Approve CSR
kubectl get csr
kubectl certificate approve john-csr
```

```yaml
# Extract the certificate to a file
kubectl get csr john-csr -o jsonpath='{.status.certificate}' | base64 -d -w 0 > john.crt
```

```yaml
# Configure kubeconfig for john
kubectl config set-credentials john \
--client-key=john.key \
--client-certificate=john.crt \
--embed-certs=true
kubectl config set-context john@kubernetes \
--cluster=kubernetes \
--user=john \
--namespace=john
```

```yaml
# Verify the user's identity
kubectl --context john@kubernetes auth whoami
```

```yaml
# Create Role and RoleBinding in namespace john
kubectl create role john-role \
--verb=list,get,create,delete \
--resource=pods,secrets -n john
kubectl create rolebinding john-role-binding \
--role=john-role \
--user=john \
-n john
```

```yaml
# Verify permissions
kubectl auth can-i create pods -n john --as john
kubectl auth can-i create deployments -n john --as john
```

Verification Step:
Confirm the CSR was approved and certificate retrieved:

```yaml
kubectl get csr john-csr -o yaml
```

Ensure user john can perform allowed actions (pods, secrets) and is denied forbidden actions (deployments):

```yaml
kubectl auth can-i create pods -n john --as john  # should be "yes"
kubectl auth can-i create deployments -n john --as john  # should be "no"
```

'' Note:
The CN in the CSR identifies the username; O (organization) can be used for grouping.

Always embed certificates in kubeconfig for easier access.

Roles and RoleBindings are namespace-scoped; ClusterRoles are used for cluster-wide permissions.

=======================================================
EOF
