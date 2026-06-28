#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 2 - Question 16
=======================================================

Step 1: Enable the ImagePolicyWebhook plugin

```yaml
ls /etc/kubernetes/imgconfig/
```

Expected output:

```yaml
admission_configuration.yaml apiserver-client-key.pem apiserver-client.pem kubeconfig.yaml webhook-key.pem webhook.pem imagepolicyconfig.yaml
```

Edit /etc/kubernetes/imgconfig/admission_configuration.yaml:

```yaml
---
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
path: /etc/kubernetes/imgconfig/imgepolicyconfig.yaml
---
# the path should be the absolute path not just imagepolicyconfig.yaml
```

Step 2: Configure the ImagePolicyWebhook admission plugin

Edit /etc/kubernetes/imgconfig/imgepolicyconfig.yaml:

```yaml
imagePolicy:
kubeConfigFile: /etc/kubernetes/imgconfig/kubeconfig.yaml
allowTTL: 50
denyTTL: 50
retryBackoff: 500
defaultAllow: false    # Implicit deny for all images not allowed
```

Step 3: Configure webhook endpoint in kubeconfig

Edit /etc/kubernetes/imgconfig/kubeconfig.yaml:

```yaml
apiVersion: v1
kind: Config
clusters:
- name: valhalla-scan
cluster:
certificate-authority: /etc/kubernetes/imgconfig/webhook.pem
server: https://valhalla.local:8081/image_policy
users:
- name: apiserver
user:
client-certificate: /etc/kubernetes/imgconfig/apiserver-client.pem
client-key: /etc/kubernetes/imgconfig/apiserver-client-key.pem
contexts:
- name: webhook-context
context:
cluster: valhalla-scan
user: apiserver
current-context: webhook-context
```

Step 4: Enable admission plugin in kube-apiserver

Edit /etc/kubernetes/manifests/kube-apiserver.yaml:

```yaml
apiVersion: v1
kind: Pod
metadata:
name: kube-apiserver
namespace: kube-system
spec:
containers:
- name: kube-apiserver
command:
- kube-apiserver
- --admission-control=NodeRestriction,ImagePolicyWebhook
- --admission-control-config-file=/etc/kubernetes/imgconfig/admission_configuration.yaml
volumeMounts:
- name: image-policy-config
mountPath: /etc/kubernetes/imgconfig
readOnly: true
volumes:
- name: image-policy-config
hostPath:
path: /etc/kubernetes/imgconfig
type: DirectoryOrCreate
```

Step 5: Test the configuration

Test using /root/16/vulnerable-resource.yaml:

```yaml
---
apiVersion: v1
kind: ReplicationController
metadata:
labels:
app: nginx-latest
name: nginx-latest
spec:
replicas: 1
template:
metadata:
labels:
app: nginx-latest
spec:
containers:
- image: nginx
name: nginx-latest
ports:
- containerPort: 80
---
```

```yaml
kubectl apply -f /root/16/vulnerable-resource.yaml
```

```yaml
kubectl describe rc nginx-latest
```

Expected output:

```yaml
Warning  FailedCreate  2m19s
replication-controller  Error creating: pods "nginx-latest-k5fwg" is forbidden:
image policy webhook backend denied one or more images: Images using latest tag are not allowed
```

Troubleshooting if kube-apiserver fails:

```yaml
crictl ps -a | grep kube-api
journalctl -u kubelet -f
systemctl restart kubelet
kubectl -n kube-system logs -l component=kube-apiserver
```

'' Note:
defaultAllow: false ensures implicit deny for any images not explicitly approved.

HTTPS endpoint ensures secure communication between API server and the image policy webhook.

Testing with a vulnerable image (e.g., latest tag) confirms the webhook is functional.

=======================================================
EOF
