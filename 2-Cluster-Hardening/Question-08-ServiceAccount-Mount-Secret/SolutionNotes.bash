#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 2, Question 15
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 2  ·  Question 15
===============================================================

Step 1: Edit the default ServiceAccount

```bash
kubectl edit sa default -n default
```

```bash
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
  namespace: default
automountServiceAccountToken: false  # add this line
```

Step 2: Edit the Pod

```bash
kubectl edit pod token-demo -n default
```

```bash
---
apiVersion: v1
kind: Pod
metadata:
  name: token-demo
  namespace: default
spec:
  serviceAccountName: default              # check serviceAccountName here
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: token-vol
      mountPath: /var/run/secrets/tokens   # change the volume mountpath
      readOnly: true
  volumes:
  - name: token-vol                        # add projected volume here
    projected:
      sources:
      - serviceAccountToken:
          path: token.jwt
          expirationSeconds: 600
          audience: https://kubernetes.default.svc.cluster.local
---

# audience is an optional field here, is set by default in this case and you can erase/skip this line

# however if you want to specify the audience, check the kube-apiserver has
`- --service-account-issuer=https://kubernetes.default.svc.cluster.local` parameter set

# so that you can specify audience explicitly like it is here:
`audience: https://kubernetes.default.svc.cluster.local`
```

Step 3: kube-apiserver configuration

Check that the kube-apiserver manifest (`/etc/kubernetes/manifests/kube-apiserver.yaml`) includes ServiceAccount issuer and signing options:

```bash
- --service-account-issuer=https://kubernetes.default.svc.cluster.local
- --service-account-key-file=/etc/kubernetes/pki/sa.pub
- --service-account-signing-key-file=/etc/kubernetes/pki/sa.key
```

Verification Step:

```bash
kubectl exec -it token-demo -- bash
cat /var/run/secrets/tokens/token.jwt
TOKEN=$(cat /var/run/secrets/tokens/token.jwt)
curl -sSk -H "Authorization: Bearer $TOKEN" https://kubernetes.default.svc/api

# Expected response should include available API versions
{
  "kind": "APIVersions",
  "versions": [
    "v1"
  ],
  "serverAddressByClientCIDRs": [
    {
      "clientCIDR": "0.0.0.0/0",
      "serverAddress": "172.16.0.2:6443"
    }
  ]
}
```

Explanation:

Setting `automountServiceAccountToken: false` prevents automatic token mounting for Pods using the `default` ServiceAccount.

A `projected ServiceAccount token volume` allows more fine-grained control, such as custom expiration and audience.

`Audience` ensures that the token is only valid for the intended service (here: the Kubernetes API server).

If the `--api-audiences` flag is not explicitly set, the default audience is the value of `--service-account-issuer`

More info:

The `--api-audiences` flag on the Kubernetes API server defines the valid audiences for ServiceAccount tokens used to authenticate with the API server.

When a ServiceAccount token is presented to the API server, the API server validates that the token's audience claim matches at least one of the audiences specified by `--api-audiences`.

Default Audience:

If the `--api-audiences` flag is not explicitly set, and the `--service-account-issuer` command-line argument is specified, the Kubernetes API server defaults to a single-element audience list containing only the issuer URL.

This means that by default, ServiceAccount tokens are expected to have the issuer URL as their audience.

Example:

If your `--service-account-issuer` is `https://kubernetes.default.svc.cluster.local`, then the default audience for ServiceAccount tokens would be `https://kubernetes.default.svc.cluster.local`.

Purpose of Audiences:

Audiences are a security mechanism used to prevent token replay attacks and ensure that a token is only used by its intended recipient.

By specifying audiences, you ensure that a ServiceAccount token issued for a specific purpose (e.g., accessing the Kubernetes API) cannot be misused by another service or application that is not the intended audience.

===============================================================
CKS_SOLUTION_EOF
