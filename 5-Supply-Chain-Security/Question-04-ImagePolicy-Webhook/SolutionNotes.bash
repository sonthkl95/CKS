#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 1, Question 11
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 1  ·  Question 11
===============================================================

The `ImagePolicyWebhook` ensures that only validated container images are allowed.

Configuring it with `defaultAllow: false` enforces implicit deny, preventing use of unapproved or potentially vulnerable images.

Commands / Steps

```bash
# Inspect the current configuration directory
ls /etc/kubernetes/confcontrol
```

```bash
# /etc/kubernetes/confcontrol/admission_configuration.yaml
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
  - name: ImagePolicyWebhook
    configuration:
      imagePolicy:
        kubeConfigFile: /etc/kubernetes/confcontrol/kubeconfig.yaml
        allowTTL: 50
        denyTTL: 50
        retryBackoff: 500
        defaultAllow: false
```

```bash
# /etc/kubernetes/confcontrol/kubeconfig.yaml
apiVersion: v1
kind: Config
clusters:
- name: test-server
  cluster:
    certificate-authority: /etc/kubernetes/confcontrol/webhook.pem
    server: https://test-server.local.8081/image_policy
users:
- name: apiserver
  user:
    client-certificate: /etc/kubernetes/confcontrol/apiserver-client.pem
    client-key: /etc/kubernetes/confcontrol/apiserver-client-key.pem
contexts:
- name: webhook-context
  context:
    cluster: test-server
    user: apiserver
current-context: webhook-context
```

```bash
# Update the kube-apiserver manifest to enable the admission plugin
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

```bash
# Relevant kube-apiserver.yaml snippet
- --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook
- --admission-control-config-file=/etc/kubernetes/confcontrol/admission_configuration.yaml
volumeMounts:
  - name: image-policy-config
    mountPath: /etc/kubernetes/confcontrol
    readOnly: true
volumes:
  - name: image-policy-config
    hostPath:
      path: /etc/kubernetes/confcontrol
      type: DirectoryOrCreate
```

```bash
# Test the configuration by deploying a Pod with latest tag
kubectl run pod-latest --image=nginx:latest
```

```bash
# Expected output:
Error from server (Forbidden): pods "pod-latest" is forbidden: image policy webhook backend denied one or more images: Images using latest tag are not allowed
```

Verification Step:

```bash
# The Pod creation should be denied
kubectl get pods -n default | grep pod-latest
```

⚠️ Note:

Ensure `defaultAllow`: false is set to enforce implicit deny.

The webhook requires a valid HTTPS endpoint with correct certificates.

Use troubleshooting commands if kube-apiserver fails:

```bash
crictl ps -a | grep kube-api
journalctl -u kubelet -f
systemctl restart kubelet
kubectl -n kube-system logs -l component=kube-apiserver
```

===============================================================
CKS_SOLUTION_EOF
