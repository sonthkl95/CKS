#!/usr/bin/env python3
"""Rebuild the 39 auto-generated (garbage) LabSetUp.bash files so each one
creates the CORRECT namespace(s) and pre-existing resources for its mapped
question, instead of the keyword-derived junk namespaces.

Only the folders listed here are overwritten; the hand-crafted LabSetUp.bash
files are left untouched.
"""
from pathlib import Path

BASE = Path(__file__).resolve().parent.parent
HEADER = "#!/bin/bash\n# LabSetUp.bash — prepares the environment for this task.\n# Run this first (paste into Killercoda or your practice cluster).\n\n"

# folder (relative) -> bash body (after the shared header)
SETUPS = {

# ───────────────────────── 1-Cluster-Setup ─────────────────────────
"1-Cluster-Setup/Question-04-Upgrade": r'''
echo "[+] Scenario: worker node 'worker-1' runs v1.32.0, control plane is on v1.33.0."
echo "[+] This task requires a real 2-node kubeadm cluster (control-plane + worker-1)."
echo ""
kubectl get nodes -o wide 2>/dev/null || echo "    (run on a cluster to see node versions)"
echo ""
echo "[i] Nothing to pre-create. You will drain, upgrade kubeadm/kubelet/kubectl on worker-1,"
echo "    then uncordon it to match the control-plane version."
echo "[+] Lab Setup Complete."
''',

# ─────────────────────── 2-Cluster-Hardening ───────────────────────
"2-Cluster-Hardening/Question-02-RBAC-Permissions": r'''
echo "[+] Creating namespace 'database'..."
kubectl create ns database --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating ServiceAccount 'test-sa'..."
kubectl create sa test-sa -n database --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating the existing (overly broad) Role 'test-role' bound to test-sa..."
kubectl apply -f - <<'EOF'
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: test-role
  namespace: database
rules:
- apiGroups: [""]
  resources: ["pods", "secrets", "configmaps"]
  verbs: ["get", "list", "watch", "create", "update", "delete"]
- apiGroups: ["apps"]
  resources: ["deployments", "statefulsets"]
  verbs: ["get", "list", "create", "update", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: test-role-bind
  namespace: database
subjects:
- kind: ServiceAccount
  name: test-sa
  namespace: database
roleRef:
  kind: Role
  name: test-role
  apiGroup: rbac.authorization.k8s.io
EOF
echo "[+] Creating Pod 'web-pod' that uses test-sa..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
  namespace: database
spec:
  serviceAccountName: test-sa
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF
echo ""
echo "[i] Task: restrict 'test-role' to only 'get' on Pods; create Role 'test-role-2'"
echo "    (update on StatefulSets) and RoleBinding 'test-role-2-bind' -> test-sa."
echo "[+] Lab Setup Complete."
''',

"2-Cluster-Hardening/Question-03-RoleBinding-Secret": r'''
echo "[+] Creating namespace 'john'..."
kubectl create ns john --dry-run=client -o yaml | kubectl apply -f -
echo ""
echo "[i] You will create the user 'john' (openssl key + CSR), approve the CSR,"
echo "    then create Role 'john-role' and RoleBinding 'john-role-binding' in ns 'john'."
echo "[+] Lab Setup Complete."
''',

"2-Cluster-Hardening/Question-04-Secret": r'''
echo "[+] Creating namespace 'testing'..."
kubectl create ns testing --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Generating self-signed TLS material (bingo.crt / bingo.key)..."
cd /root 2>/dev/null || cd "$HOME"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout bingo.key -out bingo.crt -subj "/CN=bingo.com/O=bingo" 2>/dev/null \
  && echo "    created $(pwd)/bingo.crt and $(pwd)/bingo.key" \
  || echo "    (install openssl to generate certs)"
echo ""
echo "[i] Task: create TLS secret 'bingo-tls', Pod 'nginx-pod', a Service, and an"
echo "    Ingress for host 'bingo.com' with HTTP->HTTPS redirect, all in ns 'testing'."
echo "[+] Lab Setup Complete."
''',

"2-Cluster-Hardening/Question-05-RBAC-Anonymous-Kubelet": r'''
echo "[+] This task fixes kube-bench (CIS) findings on the control-plane node."
echo "[+] Installing kube-bench (if missing)..."
if ! command -v kube-bench >/dev/null 2>&1; then
  VER="0.6.17"
  ( cd /tmp && curl -sL -O "https://github.com/aquasecurity/kube-bench/releases/download/v${VER}/kube-bench_${VER}_linux_amd64.tar.gz" \
    && tar -xzf "kube-bench_${VER}_linux_amd64.tar.gz" && sudo mv kube-bench /usr/local/bin/ \
    && sudo mkdir -p /etc/kube-bench && sudo cp -r cfg /etc/kube-bench/ ) 2>/dev/null \
    && echo "    kube-bench installed" || echo "    (could not auto-install kube-bench)"
else
  echo "    kube-bench already installed"
fi
echo ""
echo "[i] Fix findings in:"
echo "    - /etc/kubernetes/manifests/kube-apiserver.yaml  (RotateKubeletServerCertificate, PodSecurityPolicy, --kubelet-certificate-authority)"
echo "    - /var/lib/kubelet/config.yaml                   (anonymous auth off, authorization Webhook)"
echo "    - /etc/kubernetes/manifests/etcd.yaml            (--auto-tls=false, --peer-auto-tls=false)"
echo "[+] Lab Setup Complete."
''',

"2-Cluster-Hardening/Question-06-Mount-Secret": r'''
echo "[+] Creating namespace 'safe'..."
kubectl create ns safe --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating the existing secret 'admin' in ns 'safe'..."
kubectl create secret generic admin -n safe \
  --from-literal=username=admin --from-literal=password=admin-pass-123 \
  --dry-run=client -o yaml | kubectl apply -f -
echo ""
echo "[i] Task: read 'admin' fields into /home/cert-masters/{username,password}.txt,"
echo "    create secret 'newsecret' (dbadmin/moresecurepas), and a Pod mounting it."
kubectl get secret admin -n safe
echo "[+] Lab Setup Complete."
''',

"2-Cluster-Hardening/Question-07-ServiceAccount-RoleBinding-ClusterRole": r'''
echo "[+] Creating namespace 'security'..."
kubectl create ns security --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating ServiceAccount 'sa-dev-1'..."
kubectl create sa sa-dev-1 -n security --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating the existing (overly broad) Role + RoleBinding for sa-dev-1..."
kubectl apply -f - <<'EOF'
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: role-1
  namespace: security
rules:
- apiGroups: [""]
  resources: ["services", "pods", "secrets"]
  verbs: ["get", "list", "watch", "create", "update", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: role-1-binding
  namespace: security
subjects:
- kind: ServiceAccount
  name: sa-dev-1
  namespace: security
roleRef:
  kind: Role
  name: role-1
  apiGroup: rbac.authorization.k8s.io
EOF
echo "[+] Creating Pod 'web-pod' that uses sa-dev-1..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
  namespace: security
spec:
  serviceAccountName: sa-dev-1
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF
echo ""
echo "[i] Task: restrict role-1 to only 'watch' on services; create ClusterRole 'role-2'"
echo "    (update on namespaces) and ClusterRoleBinding 'role-2-binding' -> sa-dev-1."
echo "[+] Lab Setup Complete."
''',

"2-Cluster-Hardening/Question-08-ServiceAccount-Mount-Secret": r'''
echo "[+] Creating Pod 'token-demo' in the 'default' namespace (uses default SA token)..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: token-demo
  namespace: default
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF
echo ""
echo "[i] Task: set 'automountServiceAccountToken: false' on the default SA, then edit"
echo "    the Pod to mount a projected SA token at /var/run/secrets/tokens/token.jwt."
kubectl get sa default -o yaml | grep -i automount || echo "    (default SA currently auto-mounts the token)"
echo "[+] Lab Setup Complete."
''',

"2-Cluster-Hardening/Question-09-Secret": r'''
echo "[+] Creating namespace 'qa'..."
kubectl create ns qa --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating the existing 'frontend' Pod in ns 'qa'..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  namespace: qa
  labels:
    app: frontend
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF
echo ""
echo "[i] Task: create SA 'backend-qa' (no secret access) in ns 'qa' and update the"
echo "    'frontend' Pod to use it."
echo "[+] Lab Setup Complete."
''',

"2-Cluster-Hardening/Question-10-ServiceAccount-Mount": r'''
echo "[+] Creating namespace 'qa'..."
kubectl create ns qa --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating some unused ServiceAccounts to clean up later..."
for sa in old-sa temp-sa frontend; do
  kubectl create sa "$sa" -n qa --dry-run=client -o yaml | kubectl apply -f -
done
echo "[+] Writing the Pod manifest at /home/candidate/11/pod-manifest.yaml..."
mkdir -p /home/candidate/11
cat > /home/candidate/11/pod-manifest.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  namespace: qa
  labels:
    run: frontend
spec:
  serviceAccountName: frontend-sa   # <-- does not exist yet
  containers:
  - name: frontend
    image: nginx:1.25-alpine
EOF
echo ""
echo "[i] Task: create SA 'frontend-sa' (automount off) in ns 'qa', apply the manifest,"
echo "    and delete unused ServiceAccounts."
echo "[+] Lab Setup Complete."
''',

"2-Cluster-Hardening/Question-11-ServiceAccount": r'''
echo "[+] Creating namespace 'test-system'..."
kubectl create ns test-system --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating a dedicated ServiceAccount and the existing 'nginx-pod'..."
kubectl create sa app-sa -n test-system --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  namespace: test-system
spec:
  serviceAccountName: app-sa
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF
mkdir -p /candidate
echo ""
echo "[i] Task: save the Pod's SA name to /candidate/sa-name.txt, then create a Role"
echo "    (list/get/watch Deployments) and bind it to that ServiceAccount."
echo "[+] Lab Setup Complete."
''',

"2-Cluster-Hardening/Question-12-ServiceAccount": r'''
echo "[+] This task works in the 'default' namespace (already present)."
echo ""
echo "[i] Task: create SA 'backend-sa' that can list Pods, deploy Pod 'backend-pod'"
echo "    using it, and verify it can list all Pods in 'default'."
kubectl get ns default
echo "[+] Lab Setup Complete."
''',

# ─────────────────────── 3-System-Hardening ───────────────────────
"3-System-Hardening/Question-03-AppArmor": r'''
echo "[+] Loading the 'nginx-deny' AppArmor profile on the worker node..."
ssh -o StrictHostKeyChecking=no node01 bash <<'REMOTE' 2>/dev/null || echo "    (load the profile manually on the worker node if SSH is unavailable)"
cat > /etc/apparmor.d/nginx-deny <<'PROFILE'
#include <tunables/global>
profile nginx-deny flags=(attach_disconnected) {
  #include <abstractions/base>
  file,
  # Deny all file writes.
  deny /** w,
}
PROFILE
apparmor_parser -q /etc/apparmor.d/nginx-deny
echo "nginx-deny profile loaded"
REMOTE
echo "[+] Writing the Pod manifest..."
mkdir -p /home/candidate/apparmor
cat > /home/candidate/apparmor/pod.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: apparmor-deny-pod
  # TODO: add container.apparmor.security.beta.kubernetes.io/<container>: localhost/nginx-deny
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF
echo ""
echo "[i] Task: reference profile 'localhost/nginx-deny' on the Pod, deploy it, and"
echo "    verify that file writes are denied."
echo "[+] Lab Setup Complete."
''',

# ────────────── 4-Minimize-Microservice-Vulnerabilities ──────────────
"4-Minimize-Microservice-Vulnerabilities/Question-04-Privileged-Immutable-Stateless": r'''
echo "[+] Creating namespace 'prod'..."
kubectl create ns prod --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Deploying a mix of compliant and non-compliant Pods..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata: { name: clean-app, namespace: prod }
spec:
  containers:
  - name: c
    image: nginx:1.25-alpine
    securityContext: { readOnlyRootFilesystem: true }
---
apiVersion: v1
kind: Pod
metadata: { name: stateful-app, namespace: prod }   # violates: stores data in a volume
spec:
  containers:
  - name: c
    image: nginx:1.25-alpine
    volumeMounts: [{ name: data, mountPath: /data }]
  volumes: [{ name: data, emptyDir: {} }]
---
apiVersion: v1
kind: Pod
metadata: { name: privileged-app, namespace: prod }  # violates: privileged
spec:
  containers:
  - name: c
    image: nginx:1.25-alpine
    securityContext: { privileged: true }
---
apiVersion: v1
kind: Pod
metadata: { name: writable-app, namespace: prod }    # violates: writable root fs
spec:
  containers:
  - name: c
    image: nginx:1.25-alpine
    securityContext: { readOnlyRootFilesystem: false }
EOF
echo ""
echo "[i] Task: delete Pods in 'prod' that are stateful (volumes), privileged, or have a writable root fs."
kubectl get pods -n prod
echo "[+] Lab Setup Complete."
''',

"4-Minimize-Microservice-Vulnerabilities/Question-05-Privileged-Mount-docker.sock": r'''
echo "[+] Creating namespace 'dev-ops'..."
kubectl create ns dev-ops --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Deploying a Deployment that mounts /var/run/docker.sock..."
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata: { name: docker-app, namespace: dev-ops }
spec:
  replicas: 1
  selector: { matchLabels: { app: docker-app } }
  template:
    metadata: { labels: { app: docker-app } }
    spec:
      containers:
      - name: app
        image: docker:24
        command: ["sleep", "infinity"]
        volumeMounts:
        - { name: docker-sock, mountPath: /var/run/docker.sock }
      volumes:
      - name: docker-sock
        hostPath: { path: /var/run/docker.sock }
EOF
echo ""
echo "[i] Task: find the Pod(s) mounting docker.sock and remove the volume mount from the Deployment."
kubectl get deploy,pods -n dev-ops
echo "[+] Lab Setup Complete."
''',

"4-Minimize-Microservice-Vulnerabilities/Question-06-mTLS-Istio": r'''
echo "[+] Creating namespace 'payments'..."
kubectl create ns payments --dry-run=client -o yaml | kubectl apply -f -
echo ""
echo "[i] This task requires Istio to be installed in the cluster."
echo "    1. Verify/enable sidecar injection: kubectl label ns payments istio-injection=enabled"
echo "    2. Apply a PeerAuthentication with mtls.mode: STRICT in ns 'payments'."
kubectl get ns payments --show-labels
echo "[+] Lab Setup Complete."
''',

"4-Minimize-Microservice-Vulnerabilities/Question-07-PodSecurity-Admission": r'''
echo "[+] Creating namespace 'secure-team' with Pod Security Admission = restricted..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Namespace
metadata:
  name: secure-team
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/enforce-version: latest
EOF
echo "[+] Writing the failing Deployment manifest at /home/masters/insecure-deployment.yaml..."
mkdir -p /home/masters
cat > /home/masters/insecure-deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
  namespace: secure-team
spec:
  replicas: 1
  selector: { matchLabels: { app: webapp } }
  template:
    metadata: { labels: { app: webapp } }
    spec:
      containers:
      - name: webapp
        image: nginx:1.23
        ports: [{ containerPort: 80 }]
        securityContext:
          privileged: true
          runAsUser: 0
          capabilities:
            add: ["NET_ADMIN"]
        volumeMounts:
        - { mountPath: /data, name: host-data }
      volumes:
      - name: host-data
        hostPath: { path: /tmp }
EOF
echo ""
echo "[i] Task: edit the manifest so it satisfies the 'restricted' PSS and runs in 'secure-team'."
echo "[+] Lab Setup Complete."
''',

"4-Minimize-Microservice-Vulnerabilities/Question-08-NetworkPolicy-Network": r'''
echo "[+] Creating namespace 'dev-team'..."
kubectl create ns dev-team --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Deploying the 'products-service' Pod and a client Pod..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: products-service
  namespace: dev-team
  labels: { app: products-service }
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
---
apiVersion: v1
kind: Pod
metadata:
  name: client
  namespace: dev-team
  labels: { app: client }
spec:
  containers:
  - name: busybox
    image: busybox:1.36
    command: ["sleep", "infinity"]
EOF
echo ""
echo "[i] Task: create NetworkPolicy 'restricted-policy' allowing ingress to 'products-service'"
echo "    only from ns 'dev-team' pods and from pods labelled environment=testing in any ns."
echo "[+] Lab Setup Complete."
''',

"4-Minimize-Microservice-Vulnerabilities/Question-09-ServiceAccount-RoleBinding-ClusterRole": r'''
echo "[+] Creating namespace 'staging'..."
kubectl create ns staging --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating ServiceAccount 'psp-restrict-sa'..."
kubectl create sa psp-restrict-sa -n staging --dry-run=client -o yaml | kubectl apply -f -
echo ""
echo "[!] NOTE: PodSecurityPolicy was removed in Kubernetes v1.25. On newer clusters,"
echo "    implement the same intent with Pod Security Admission (enforce=restricted)."
echo ""
echo "[i] Task: create PSP 'prevent-psp-policy' (no privileged), ClusterRole 'restrict-access-role',"
echo "    and ClusterRoleBinding 'restrict-access-bind' -> psp-restrict-sa."
echo "[+] Lab Setup Complete."
''',

"4-Minimize-Microservice-Vulnerabilities/Question-10-Identify-Service-Running": r'''
echo "[+] Starting a mock service listening on TCP port 389 (LDAP)..."
mkdir -p /candidate/13
BIN=/usr/local/bin/ldap-mock
cat > "$BIN" <<'EOF'
#!/bin/bash
exec nc -lk -p 389
EOF
chmod +x "$BIN" 2>/dev/null
( setsid "$BIN" >/dev/null 2>&1 & ) 2>/dev/null \
  && echo "    mock service started (binary: $BIN)" \
  || echo "    (install netcat, or use the real service on port 389)"
echo ""
echo "[i] Task: find the PID listening on 389, save its open files to /candidate/13/files.txt,"
echo "    locate the process binary and delete it."
echo "[+] Lab Setup Complete."
''',

"4-Minimize-Microservice-Vulnerabilities/Question-11-NetworkPolicy-Cilium-Network": r'''
echo "[+] Creating namespace 'team-dev'..."
kubectl create ns team-dev --dry-run=client -o yaml | kubectl apply -f -
echo ""
echo "[!] NOTE: this task requires a cluster with Cilium as the CNI (CiliumNetworkPolicy CRD)."
echo "[+] Creating the existing 'default-allow' CiliumNetworkPolicy (if the CRD exists)..."
kubectl apply -f - <<'EOF' 2>/dev/null || echo "    (CiliumNetworkPolicy CRD not present — install Cilium)"
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: default-allow
  namespace: team-dev
spec:
  endpointSelector: {}
  ingress:
  - fromEndpoints: [{}]
  egress:
  - toEndpoints: [{}]
  - toEndpoints:
    - matchLabels:
        k8s:io.kubernetes.pod.namespace: kube-system
        k8s-app: kube-dns
EOF
echo ""
echo "[i] Task: create CiliumNetworkPolicies 'team-dev' (mutual auth db->api-service) and"
echo "    'team-dev-2' (deny ICMP egress from Deployment 'stuff' to Service 'backend')."
echo "[+] Lab Setup Complete."
''',

"4-Minimize-Microservice-Vulnerabilities/Question-12-Mount-docker.sock": r'''
echo "[+] Creating namespace 'ci-cd'..."
kubectl create ns ci-cd --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Deploying a Pod that mounts /var/run/docker.sock..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata: { name: ci-runner, namespace: ci-cd }
spec:
  containers:
  - name: runner
    image: docker:24
    command: ["sleep", "infinity"]
    volumeMounts:
    - { name: docker-sock, mountPath: /var/run/docker.sock }
  volumes:
  - name: docker-sock
    hostPath: { path: /var/run/docker.sock }
EOF
echo ""
echo "[i] Task: restrict access to docker.sock (ownership + chmod) without breaking CI jobs."
kubectl get pods -n ci-cd
echo "[+] Lab Setup Complete."
''',

"4-Minimize-Microservice-Vulnerabilities/Question-13-NetworkPolicy-Network": r'''
echo "[+] Creating namespace 'testing'..."
kubectl create ns testing --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Deploying a test Pod..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata: { name: app, namespace: testing, labels: { app: app } }
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
EOF
echo ""
echo "[i] Task: create NetworkPolicy 'default-deny' in ns 'testing' blocking all Egress"
echo "    (optionally allow DNS egress)."
echo "[+] Lab Setup Complete."
''',

"4-Minimize-Microservice-Vulnerabilities/Question-14-ServiceAccount-RoleBinding-ClusterRole": r'''
echo "[+] Creating namespace 'restricted'..."
kubectl create ns restricted --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Creating ServiceAccount 'psp-sa'..."
kubectl create sa psp-sa -n restricted --dry-run=client -o yaml | kubectl apply -f -
echo ""
echo "[!] NOTE: PodSecurityPolicy was removed in Kubernetes v1.25. On newer clusters use"
echo "    Pod Security Admission or a policy engine (Kyverno/Gatekeeper) for the same intent."
echo ""
echo "[i] Task: create PSP 'prevent-volume-policy' (only persistentVolumeClaim volumes),"
echo "    ClusterRole 'psp-role', and ClusterRoleBinding 'psp-role-binding' -> psp-sa."
echo "[+] Lab Setup Complete."
''',

"4-Minimize-Microservice-Vulnerabilities/Question-15-Mount-docker.sock": r'''
echo "[+] Creating namespace 'sandbox'..."
kubectl create ns sandbox --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Deploying Deployment 'docker-admin' that mounts /var/run/docker.sock..."
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata: { name: docker-admin, namespace: sandbox }
spec:
  replicas: 1
  selector: { matchLabels: { app: docker-admin } }
  template:
    metadata: { labels: { app: docker-admin } }
    spec:
      containers:
      - name: docker-container
        image: docker:24
        command: ["sleep", "infinity"]
        volumeMounts:
        - { name: dockersock, mountPath: /var/run/docker.sock }
      volumes:
      - name: dockersock
        hostPath: { path: /var/run/docker.sock }
EOF
echo ""
echo "[i] Task: harden the Deployment — run as non-root, drop all capabilities,"
echo "    read-only root fs, and make the docker.sock mount read-only."
kubectl get deploy,pods -n sandbox
echo "[+] Lab Setup Complete."
''',

"4-Minimize-Microservice-Vulnerabilities/Question-16-NetworkPolicy-Network": r'''
echo "[+] Creating namespace 'staging'..."
kubectl create ns staging --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Deploying pods that listen on port 80 (and one that does not)..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata: { name: web-80, namespace: staging, labels: { app: web } }
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
    ports: [{ containerPort: 80 }]
---
apiVersion: v1
kind: Pod
metadata: { name: client, namespace: staging, labels: { app: client } }
spec:
  containers:
  - name: busybox
    image: busybox:1.36
    command: ["sleep", "infinity"]
EOF
echo ""
echo "[i] Task: create NetworkPolicy 'allow-np' allowing ns 'staging' pods to reach port 80"
echo "    of other pods in the same ns; deny other ports and cross-namespace traffic."
echo "[+] Lab Setup Complete."
''',

"4-Minimize-Microservice-Vulnerabilities/Question-17-ServiceAccount-RoleBinding-ClusterRole": r'''
echo "[+] Creating ServiceAccount 'psp-sa' in the 'default' namespace..."
kubectl create sa psp-sa -n default --dry-run=client -o yaml | kubectl apply -f -
echo ""
echo "[!] NOTE: PodSecurityPolicy was removed in Kubernetes v1.25. On newer clusters use"
echo "    Pod Security Admission or a policy engine for the same intent."
echo ""
echo "[i] Task: create PSP 'prevent-privileged-policy', ClusterRole 'prevent-role', and"
echo "    ClusterRoleBinding 'prevent-role-binding' -> psp-sa; verify a privileged Pod is blocked."
echo "[+] Lab Setup Complete."
''',

"4-Minimize-Microservice-Vulnerabilities/Question-18-NetworkPolicy-Network": r'''
echo "[+] Creating namespace 'test'..."
kubectl create ns test --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Writing the skeleton NetworkPolicy at /home/policy/network-policy.yaml..."
mkdir -p /home/policy
cat > /home/policy/network-policy.yaml <<'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-network
  namespace: test
spec:
  podSelector: {}
  # TODO: add policyTypes Ingress + Egress to block all traffic
EOF
echo ""
echo "[i] Task: complete the policy so it denies all ingress and egress for every pod in ns 'test'."
echo "[+] Lab Setup Complete."
''',

# ─────────────────────── 5-Supply-Chain-Security ───────────────────────
"5-Supply-Chain-Security/Question-04-ImagePolicy-Webhook": r'''
echo "[+] Creating the (incomplete) ImagePolicy webhook config in /etc/kubernetes/confcontrol ..."
mkdir -p /etc/kubernetes/confcontrol
cat > /etc/kubernetes/confcontrol/admission_configuration.yaml <<'EOF'
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
      defaultAllow: true          # <-- INCOMPLETE: must become false (implicit deny)
EOF
cat > /etc/kubernetes/confcontrol/kubeconfig.yaml <<'EOF'
apiVersion: v1
kind: Config
clusters:
- name: image-bouncer-webhook
  cluster:
    server: https://127.0.0.1:8081/image_policy
    # certificate-authority: /etc/kubernetes/confcontrol/ca.crt
contexts:
- name: image-bouncer-webhook
  context:
    cluster: image-bouncer-webhook
    user: api-server
current-context: image-bouncer-webhook
users:
- name: api-server
  user: {}
EOF
echo "[+] Writing a test Pod that uses the 'latest' image tag..."
mkdir -p /root/16
cat > /root/16/test-pod.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: test-latest
spec:
  containers:
  - name: nginx
    image: nginx:latest
EOF
echo ""
echo "[i] Task: enable the ImagePolicy admission plugin on kube-apiserver, set implicit"
echo "    deny (defaultAllow: false), then try to deploy /root/16/test-pod.yaml (latest tag)."
echo "[+] Lab Setup Complete."
''',

"5-Supply-Chain-Security/Question-05-Kubesec-Scan-Manifest": r'''
echo "[+] Writing the Pod manifest to scan (kubesec-test.yaml)..."
mkdir -p /root/kubesec 2>/dev/null; cd /root/kubesec 2>/dev/null || cd "$HOME"
cat > kubesec-test.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: kubesec-demo
spec:
  containers:
  - name: kubesec-demo
    image: gcr.io/google-samples/node-hello:1.0
    securityContext:
      readOnlyRootFilesystem: false
EOF
echo "    created $(pwd)/kubesec-test.yaml"
echo ""
echo "[i] Task: scan with the KubeSec docker image and apply fixes to reach a score >= 4, e.g.:"
echo "    docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < kubesec-test.yaml"
echo "[+] Lab Setup Complete."
''',

"5-Supply-Chain-Security/Question-06-gVisor-RuntimeClass": r'''
echo "[+] Preparing output directory /opt/course/7 ..."
mkdir -p /opt/course/7
echo ""
echo "[!] NOTE: this task requires the 'runsc' (gVisor) runtime handler configured in containerd,"
echo "    and a node named 'node-02'."
echo ""
echo "[i] Task: create RuntimeClass 'untrusted' (handler runsc), deploy Pod 'untrusted'"
echo "    (image alpine:3.18) on node-02, and save 'dmesg' output to /opt/course/7/untrusted-test-dmesg."
echo "[+] Lab Setup Complete."
''',

"5-Supply-Chain-Security/Question-07-ImagePolicy-Webhook-Admission": r'''
echo "[+] Creating the ImagePolicyWebhook configuration under /etc/kubernetes/imgconfig ..."
mkdir -p /etc/kubernetes/imgconfig /root/16
cat > /etc/kubernetes/imgconfig/admission_configuration.yaml <<'EOF'
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
  configuration:
    imagePolicy:
      kubeConfigFile: /etc/kubernetes/imgconfig/kubeconfig.yaml
      allowTTL: 50
      denyTTL: 50
      retryBackoff: 500
      defaultAllow: false          # implicit deny
EOF
cat > /etc/kubernetes/imgconfig/kubeconfig.yaml <<'EOF'
apiVersion: v1
kind: Config
clusters:
- name: bouncer_webhook
  cluster:
    server: https://valhalla.local:8081/image_policy
    # certificate-authority: /etc/kubernetes/imgconfig/ca.crt
contexts:
- name: bouncer_validator
  context:
    cluster: bouncer_webhook
    user: api-server
current-context: bouncer_validator
users:
- name: api-server
  user: {}
EOF
cat > /root/16/vulnerable-resource.yaml <<'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: vulnerable-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
EOF
echo ""
echo "[i] Task: enable the ImagePolicyWebhook admission plugin (endpoint https://valhalla.local:8081/image_policy),"
echo "    enforce implicit deny, then test with /root/16/vulnerable-resource.yaml."
echo "[+] Lab Setup Complete."
''',

"5-Supply-Chain-Security/Question-08-Mount-Secret-Token": r'''
echo "[+] Creating namespaces 'dev' and 'app'..."
kubectl create ns dev --dry-run=client -o yaml | kubectl apply -f -
kubectl create ns app --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Ensuring a token-style secret exists in ns 'dev'..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Secret
metadata:
  name: default-token-abcde
  namespace: dev
  annotations:
    kubernetes.io/service-account.name: default
type: kubernetes.io/service-account-token
EOF
echo ""
echo "[i] Task: extract ca.crt from the 'dev' token secret, create secret 'app-config-secret'"
echo "    (APP_USER=appadmin, APP_PASS=Sup3rS3cret) in ns 'app', and deploy Pod 'app-pod'"
echo "    (nginx) mounting the secret at /etc/app-config."
echo "[+] Lab Setup Complete."
''',

"5-Supply-Chain-Security/Question-09-Dockerfile-Privileged": r'''
echo "[+] Writing the Dockerfile and Deployment manifest at /home/candidate/10 ..."
mkdir -p /home/candidate/10
cat > /home/candidate/10/Dockerfile <<'EOF'
FROM ubuntu:latest
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends runit wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
COPY scripts/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["couchbase-server"]
EOF
cat > /home/candidate/10/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata: { name: couchbase, namespace: default }
spec:
  replicas: 1
  selector: { matchLabels: { app: couchbase } }
  template:
    metadata: { labels: { app: couchbase } }
    spec:
      containers:
      - name: couchbase
        image: couchbase:latest
        securityContext:
          privileged: true
          runAsUser: 0
EOF
echo ""
echo "[i] Task: fix TWO issues in each file (no adding/removing fields). Use user 'nobody' (UID 65535) where needed."
echo "[+] Lab Setup Complete."
''',

"5-Supply-Chain-Security/Question-10-Trivy-SBOM-CycloneDX": r'''
echo "[+] Preparing /opt/candidate/13 and a sample SBOM to scan..."
mkdir -p /opt/candidate/13
cat > /opt/candidate/13/sbom_check.json <<'EOF'
{ "spdxVersion": "SPDX-2.3", "name": "sample-sbom", "packages": [] }
EOF
echo ""
echo "[!] NOTE: requires the 'bom' and 'trivy' tools installed."
echo "[i] Task:"
echo "    - bom generate --format json --image registry.k8s.io/kube-apiserver:v1.32.0 -> /opt/candidate/13/sbom1.json (SPDX-JSON)"
echo "    - trivy image --format cyclonedx registry.k8s.io/kube-controller-manager:v1.32.0 -> /opt/candidate/13/sbom2.json"
echo "    - trivy sbom --format json /opt/candidate/13/sbom_check.json -> /opt/candidate/13/sbom_result.json"
echo "[+] Lab Setup Complete."
''',

"5-Supply-Chain-Security/Question-11-Dockerfile-Privileged-Mount": r'''
echo "[+] Writing the Dockerfile and Deployment manifest at /home/manifests ..."
mkdir -p /home/manifests
cat > /home/manifests/Dockerfile <<'EOF'
FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY app /app
RUN chmod -R a+rX /app
USER root
CMD ["./start.sh"]
EOF
cat > /home/manifests/deployment.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kafka
  labels: { app: kafka }
spec:
  replicas: 1
  selector: { matchLabels: { app: kafka } }
  template:
    metadata: { labels: { app: kafka } }
    spec:
      containers:
      - name: kafka
        image: bitnami/kafka
        volumeMounts:
        - { mountPath: /opt/bitnami/kafka/bin, name: kafka-vol }
        securityContext:
          capabilities: { add: ["NET_ADMIN"], drop: ["ALL"] }
          privileged: true
          readOnlyRootFilesystem: false
          runAsUser: 0
        resources: {}
      volumes:
      - name: kafka-vol
        hostPath: { path: / }
EOF
echo ""
echo "[i] Task: fix TWO issues in each file (no adding/removing fields). Use user 'nobody' (UID 65535) where needed."
echo "[+] Lab Setup Complete."
''',

"5-Supply-Chain-Security/Question-12-Trivy-Namespace-Scan": r'''
echo "[+] Creating namespace 'nato'..."
kubectl create ns nato --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Deploying Pods using a mix of clean and vulnerable image tags..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata: { name: nginx-1, namespace: nato }
spec: { containers: [ { name: c, image: nginx:1.25-alpine } ] }
---
apiVersion: v1
kind: Pod
metadata: { name: nginx-2, namespace: nato }
spec: { containers: [ { name: c, image: nginx:1.16 } ] }
---
apiVersion: v1
kind: Pod
metadata: { name: nginx-3, namespace: nato }
spec: { containers: [ { name: c, image: httpd:2.4.49 } ] }
EOF
echo ""
echo "[!] NOTE: requires the 'trivy' tool installed on the node."
echo "[i] Task: scan the images used by Pods in ns 'nato' for HIGH/CRITICAL vulnerabilities"
echo "    and delete any Pod running a severely vulnerable image."
kubectl get pods -n nato
echo "[+] Lab Setup Complete."
''',

# ─────────────── 6-Monitoring-Logging-Runtime-Security ───────────────
"6-Monitoring-Logging-Runtime-Security/Question-03-Falco-Sysdig": r'''
echo "[+] Preparing the incidents output directory /opt/node-01/alerts ..."
mkdir -p /opt/node-01/alerts
echo "[+] Deploying a Pod that spawns processes to be detected..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata: { name: noisy-app, namespace: default }
spec:
  containers:
  - name: app
    image: ubuntu:22.04
    command: ["/bin/sh","-c","while true; do id; sleep 2; curl -s localhost || true; sleep 3; done"]
EOF
echo ""
echo "[!] NOTE: requires Falco (or sysdig) on the worker node."
echo "[i] Task: watch process-exec events for >=30s and write incidents to"
echo "    /opt/node-01/alerts/details as: timestamp,uid/username,processName"
echo "[+] Lab Setup Complete."
''',

"6-Monitoring-Logging-Runtime-Security/Question-04-Audit-Secret": r'''
echo "[+] Preparing audit log directory and a BASE audit policy to extend..."
mkdir -p /var/log /etc/kubernetes
cat > /etc/kubernetes/audit-policy.yaml <<'EOF'
apiVersion: audit.k8s.io/v1
kind: Policy
omitStages:
  - "RequestReceived"
rules:
  # TODO (extend):
  # 1. namespaces -> RequestResponse
  # 2. secrets in kube-system -> Request (request body)
  # 3. all other core + extensions -> Request
  # 4. pods/portforward, services/proxy -> Metadata
  # 5. default catch-all -> Metadata
EOF
echo ""
echo "[i] Task: extend the audit policy as above and enable audit logging on kube-apiserver"
echo "    (path /var/log/kubernetes-logs.log, retain 12 days, 8 backups, rotate at 200MB)."
echo "[+] Lab Setup Complete."
''',

"6-Monitoring-Logging-Runtime-Security/Question-05-Falco": r'''
echo "[+] Deploying the single-container Pod 'tomcat' to monitor..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Pod
metadata: { name: tomcat, namespace: default }
spec:
  containers:
  - name: tomcat
    image: tomcat:9.0
EOF
echo "[+] Preparing the report directory /home/anomalous ..."
mkdir -p /home/anomalous
echo ""
echo "[!] NOTE: requires Falco (or sysdig) on the worker node."
echo "[i] Task: monitor the 'tomcat' Pod for >=40s and write incidents to"
echo "    /home/anomalous/report as: [timestamp],[uid],[processName]"
echo "[+] Lab Setup Complete."
''',

"6-Monitoring-Logging-Runtime-Security/Question-06-Audit": r'''
echo "[+] Creating namespace 'frontend'..."
kubectl create ns frontend --dry-run=client -o yaml | kubectl apply -f -
echo "[+] Preparing audit log dir and a BASE policy (only says what NOT to log) to extend..."
mkdir -p /var/log /etc/audit
cat > /etc/audit/audit-policy.yaml <<'EOF'
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
  # TODO (extend):
  # 1. nodes -> RequestResponse
  # 2. persistentvolumeclaims in ns 'frontend' -> Request (request body)
  # Base: do not log anything else
  - level: None
EOF
echo ""
echo "[i] Task: extend the audit policy as above and enable audit logging on kube-apiserver"
echo "    (path /var/log/kubernetes-logs.log, retain 5 days, keep 10 old files)."
echo "[+] Lab Setup Complete."
''',
}


def main():
    n = 0
    for rel, body in SETUPS.items():
        f = BASE / rel / "LabSetUp.bash"
        if not f.parent.exists():
            print("MISSING FOLDER:", rel)
            continue
        f.write_text(HEADER + body.lstrip("\n"), encoding="utf-8")
        n += 1
        print(f"[ok] {rel}/LabSetUp.bash")
    print(f"\nRewrote {n} LabSetUp.bash files.")


if __name__ == "__main__":
    main()
