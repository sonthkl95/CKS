# CKS Practice Labs (CKS-PREP-2025)

Practical CKS (Certified Kubernetes Security Specialist) lab exercises derived from
the 4 Udemy CKS Practice Tests in [`lab/`](lab/) (**55 questions total**: Test 1–3 have
16 each, Test 4 has 7). Each question lives in its own folder, grouped by CKS domain,
with three bash files:

- `LabSetUp.bash` — copy/paste into Killercoda (or any Kubernetes cluster) to prep the environment (creates the correct namespaces and pre-existing resources for the task).
- `Questions.bash` — the exact scenario/task text from the source practice test.
- `SolutionNotes.bash` — the official step-by-step “Correct answer” explanation from the source.

> The `Questions.bash`, `LabSetUp.bash`, and `SolutionNotes.bash` in every folder all
> refer to the **same** question. See the [Lab Index](#lab-index) below for the mapping
> from each folder to its Practice Test / Question number.

## CKS Domains Covered

| Domain | Weight |
|--------|--------|
| Cluster Setup | 15% |
| Cluster Hardening | 15% |
| System Hardening | 10% |
| Minimize Microservice Vulnerabilities | 20% |
| Supply Chain Security | 20% |
| Monitoring, Logging, and Runtime Security | 20% |

## How to Use

1. Launch the **CKS Killercoda** playground or your own cluster (1 control-plane + 1 worker node).
2. Clone this repo inside the environment:
   ```bash
   git clone https://github.com/YOUR_USERNAME/CKS-PREP-2025.git
   cd CKS-PREP-2025
   ```
3. Pick a folder under one of the Domain directories.
4. Run LabSetUp first:
   ```bash
   bash scripts/run-lab.sh 3-System-Hardening/Question-01-AppArmor
   ```
5. Read `Questions.bash` for the task, then try to solve it.
6. Check `SolutionNotes.bash` if you need a hint.

## Recommended Cluster Setup (Killercoda)

Use the **Kubernetes 1.32** playground on [Killercoda](https://killercoda.com/playgrounds/scenario/kubernetes) with:
- 1 control-plane node (`master`)
- 1 worker node (`node01`)

## Lab Index

Every question from the source practice tests, mapped to its lab folder. Take a full
test by following the rows in order, or study by CKS domain using the folder paths.

### Practice Test 1

| Q | Topic | Lab folder |
|---|-------|-----------|
| 1 | AppArmor profile on a worker node | [3-System-Hardening/Question-01-AppArmor](3-System-Hardening/Question-01-AppArmor) |
| 2 | NetworkPolicy `deny-all` (testing ns) | [4-Minimize-Microservice-Vulnerabilities/Question-01-NetworkPolicy-DenyAll](4-Minimize-Microservice-Vulnerabilities/Question-01-NetworkPolicy-DenyAll) |
| 3 | ServiceAccount token mount (nginx-pod) | [2-Cluster-Hardening/Question-01-ServiceAccount-Token](2-Cluster-Hardening/Question-01-ServiceAccount-Token) |
| 4 | Re-secure anonymous API access | [1-Cluster-Setup/Question-01-Anonymous-API-Access](1-Cluster-Setup/Question-01-Anonymous-API-Access) |
| 5 | Audit logging + policy | [6-Monitoring-Logging-Runtime-Security/Question-01-Audit-Logging](6-Monitoring-Logging-Runtime-Security/Question-01-Audit-Logging) |
| 6 | Dockerfile + Pod security fixes | [5-Supply-Chain-Security/Question-01-Dockerfile-Pod-Security](5-Supply-Chain-Security/Question-01-Dockerfile-Pod-Security) |
| 7 | kube-bench fixes (apiserver/kubelet/etcd) | [2-Cluster-Hardening/Question-05-RBAC-Anonymous-Kubelet](2-Cluster-Hardening/Question-05-RBAC-Anonymous-Kubelet) |
| 8 | Encryption at rest (Secrets) | [1-Cluster-Setup/Question-03-Encryption-at-Rest](1-Cluster-Setup/Question-03-Encryption-at-Rest) |
| 9 | Stateless/immutable Pods (prod ns) | [4-Minimize-Microservice-Vulnerabilities/Question-04-Privileged-Immutable-Stateless](4-Minimize-Microservice-Vulnerabilities/Question-04-Privileged-Immutable-Stateless) |
| 10 | RuntimeClass `sandboxed` (gVisor) | [4-Minimize-Microservice-Vulnerabilities/Question-02-RuntimeClass-gVisor](4-Minimize-Microservice-Vulnerabilities/Question-02-RuntimeClass-gVisor) |
| 11 | ImagePolicy webhook (confcontrol) | [5-Supply-Chain-Security/Question-04-ImagePolicy-Webhook](5-Supply-Chain-Security/Question-04-ImagePolicy-Webhook) |
| 12 | Remove docker.sock mount (dev-ops ns) | [4-Minimize-Microservice-Vulnerabilities/Question-05-Privileged-Mount-docker.sock](4-Minimize-Microservice-Vulnerabilities/Question-05-Privileged-Mount-docker.sock) |
| 13 | Istio mTLS STRICT (payments ns) | [4-Minimize-Microservice-Vulnerabilities/Question-06-mTLS-Istio](4-Minimize-Microservice-Vulnerabilities/Question-06-mTLS-Istio) |
| 14 | PSA restricted Deployment fix (secure-team) | [4-Minimize-Microservice-Vulnerabilities/Question-07-PodSecurity-Admission](4-Minimize-Microservice-Vulnerabilities/Question-07-PodSecurity-Admission) |
| 15 | Upgrade worker node | [1-Cluster-Setup/Question-04-Upgrade](1-Cluster-Setup/Question-04-Upgrade) |
| 16 | Falco detect `/dev/mem` + scale to 0 | [6-Monitoring-Logging-Runtime-Security/Question-02-Falco-Threat-Detection](6-Monitoring-Logging-Runtime-Security/Question-02-Falco-Threat-Detection) |

### Practice Test 2

| Q | Topic | Lab folder |
|---|-------|-----------|
| 1 | AppArmor `nginx-deny` profile | [3-System-Hardening/Question-03-AppArmor](3-System-Hardening/Question-03-AppArmor) |
| 2 | Audit logging + policy (extended) | [6-Monitoring-Logging-Runtime-Security/Question-04-Audit-Secret](6-Monitoring-Logging-Runtime-Security/Question-04-Audit-Secret) |
| 3 | Trivy scan images | [5-Supply-Chain-Security/Question-02-Trivy-Scanning](5-Supply-Chain-Security/Question-02-Trivy-Scanning) |
| 4 | Falco detect process exec (30s) | [6-Monitoring-Logging-Runtime-Security/Question-03-Falco-Sysdig](6-Monitoring-Logging-Runtime-Security/Question-03-Falco-Sysdig) |
| 5 | NetworkPolicy `restricted-policy` (dev-team) | [4-Minimize-Microservice-Vulnerabilities/Question-08-NetworkPolicy-Network](4-Minimize-Microservice-Vulnerabilities/Question-08-NetworkPolicy-Network) |
| 6 | KubeSec scan + fix | [5-Supply-Chain-Security/Question-05-Kubesec-Scan-Manifest](5-Supply-Chain-Security/Question-05-Kubesec-Scan-Manifest) |
| 7 | RuntimeClass `untrusted` (gVisor) | [5-Supply-Chain-Security/Question-06-gVisor-RuntimeClass](5-Supply-Chain-Security/Question-06-gVisor-RuntimeClass) |
| 8 | PSP + ClusterRole (staging ns) | [4-Minimize-Microservice-Vulnerabilities/Question-09-ServiceAccount-RoleBinding-ClusterRole](4-Minimize-Microservice-Vulnerabilities/Question-09-ServiceAccount-RoleBinding-ClusterRole) |
| 9 | User `john` CSR + Role (john ns) | [2-Cluster-Hardening/Question-03-RoleBinding-Secret](2-Cluster-Hardening/Question-03-RoleBinding-Secret) |
| 10 | TLS Ingress `bingo.com` (testing ns) | [2-Cluster-Hardening/Question-04-Secret](2-Cluster-Hardening/Question-04-Secret) |
| 11 | CIS Benchmark fixes | [1-Cluster-Setup/Question-02-CIS-Benchmark](1-Cluster-Setup/Question-02-CIS-Benchmark) |
| 12 | Read/create Secret (safe ns) | [2-Cluster-Hardening/Question-06-Mount-Secret](2-Cluster-Hardening/Question-06-Mount-Secret) |
| 13 | Identify service on port 389 | [4-Minimize-Microservice-Vulnerabilities/Question-10-Identify-Service-Running](4-Minimize-Microservice-Vulnerabilities/Question-10-Identify-Service-Running) |
| 14 | RBAC for `sa-dev-1` (security ns) | [2-Cluster-Hardening/Question-07-ServiceAccount-RoleBinding-ClusterRole](2-Cluster-Hardening/Question-07-ServiceAccount-RoleBinding-ClusterRole) |
| 15 | Projected SA token (token-demo) | [2-Cluster-Hardening/Question-08-ServiceAccount-Mount-Secret](2-Cluster-Hardening/Question-08-ServiceAccount-Mount-Secret) |
| 16 | ImagePolicyWebhook (valhalla.local) | [5-Supply-Chain-Security/Question-07-ImagePolicy-Webhook-Admission](5-Supply-Chain-Security/Question-07-ImagePolicy-Webhook-Admission) |

### Practice Test 3

| Q | Topic | Lab folder |
|---|-------|-----------|
| 1 | CiliumNetworkPolicy (team-dev) | [4-Minimize-Microservice-Vulnerabilities/Question-11-NetworkPolicy-Cilium-Network](4-Minimize-Microservice-Vulnerabilities/Question-11-NetworkPolicy-Cilium-Network) |
| 2 | Seccomp profile (secure-app) | [3-System-Hardening/Question-02-Seccomp-Profile](3-System-Hardening/Question-02-Seccomp-Profile) |
| 3 | Restrict docker.sock perms (ci-cd) | [4-Minimize-Microservice-Vulnerabilities/Question-12-Mount-docker.sock](4-Minimize-Microservice-Vulnerabilities/Question-12-Mount-docker.sock) |
| 4 | Trivy scan namespace (nato) | [5-Supply-Chain-Security/Question-12-Trivy-Namespace-Scan](5-Supply-Chain-Security/Question-12-Trivy-Namespace-Scan) |
| 5 | NetworkPolicy `default-deny` egress (testing) | [4-Minimize-Microservice-Vulnerabilities/Question-13-NetworkPolicy-Network](4-Minimize-Microservice-Vulnerabilities/Question-13-NetworkPolicy-Network) |
| 6 | SA `backend-qa` no secrets (qa ns) | [2-Cluster-Hardening/Question-09-Secret](2-Cluster-Hardening/Question-09-Secret) |
| 7 | Falco monitor `tomcat` (40s) | [6-Monitoring-Logging-Runtime-Security/Question-05-Falco](6-Monitoring-Logging-Runtime-Security/Question-05-Falco) |
| 8 | Audit logging (Node/PVC frontend) | [6-Monitoring-Logging-Runtime-Security/Question-06-Audit](6-Monitoring-Logging-Runtime-Security/Question-06-Audit) |
| 9 | Secret volume mount (dev/app ns) | [5-Supply-Chain-Security/Question-08-Mount-Secret-Token](5-Supply-Chain-Security/Question-08-Mount-Secret-Token) |
| 10 | Dockerfile + Deployment fixes | [5-Supply-Chain-Security/Question-09-Dockerfile-Privileged](5-Supply-Chain-Security/Question-09-Dockerfile-Privileged) |
| 11 | SA `frontend-sa` no automount (qa) | [2-Cluster-Hardening/Question-10-ServiceAccount-Mount](2-Cluster-Hardening/Question-10-ServiceAccount-Mount) |
| 12 | PSP volumes + ClusterRole (restricted) | [4-Minimize-Microservice-Vulnerabilities/Question-14-ServiceAccount-RoleBinding-ClusterRole](4-Minimize-Microservice-Vulnerabilities/Question-14-ServiceAccount-RoleBinding-ClusterRole) |
| 13 | SBOM (bom + trivy CycloneDX) | [5-Supply-Chain-Security/Question-10-Trivy-SBOM-CycloneDX](5-Supply-Chain-Security/Question-10-Trivy-SBOM-CycloneDX) |
| 14 | Restrict Role for `test-sa` (database) | [2-Cluster-Hardening/Question-02-RBAC-Permissions](2-Cluster-Hardening/Question-02-RBAC-Permissions) |
| 15 | Binary integrity (sha512) | [5-Supply-Chain-Security/Question-03-Binary-Integrity](5-Supply-Chain-Security/Question-03-Binary-Integrity) |
| 16 | PSA restricted (team-blue) | [4-Minimize-Microservice-Vulnerabilities/Question-03-Pod-Security-Standards](4-Minimize-Microservice-Vulnerabilities/Question-03-Pod-Security-Standards) |

### Practice Test 4

| Q | Topic | Lab folder |
|---|-------|-----------|
| 1 | Harden docker.sock Deployment (sandbox) | [4-Minimize-Microservice-Vulnerabilities/Question-15-Mount-docker.sock](4-Minimize-Microservice-Vulnerabilities/Question-15-Mount-docker.sock) |
| 2 | SA name + Role for Deployments (test-system) | [2-Cluster-Hardening/Question-11-ServiceAccount](2-Cluster-Hardening/Question-11-ServiceAccount) |
| 3 | Dockerfile + kafka Deployment fixes | [5-Supply-Chain-Security/Question-11-Dockerfile-Privileged-Mount](5-Supply-Chain-Security/Question-11-Dockerfile-Privileged-Mount) |
| 4 | SA `backend-sa` list Pods (default) | [2-Cluster-Hardening/Question-12-ServiceAccount](2-Cluster-Hardening/Question-12-ServiceAccount) |
| 5 | NetworkPolicy `allow-np` port 80 (staging) | [4-Minimize-Microservice-Vulnerabilities/Question-16-NetworkPolicy-Network](4-Minimize-Microservice-Vulnerabilities/Question-16-NetworkPolicy-Network) |
| 6 | PSP prevent privileged (default) | [4-Minimize-Microservice-Vulnerabilities/Question-17-ServiceAccount-RoleBinding-ClusterRole](4-Minimize-Microservice-Vulnerabilities/Question-17-ServiceAccount-RoleBinding-ClusterRole) |
| 7 | NetworkPolicy default-deny (test ns) | [4-Minimize-Microservice-Vulnerabilities/Question-18-NetworkPolicy-Network](4-Minimize-Microservice-Vulnerabilities/Question-18-NetworkPolicy-Network) |

## References

- [CKS Exam Curriculum](https://github.com/cncf/curriculum)
- [Kubernetes Security Documentation](https://kubernetes.io/docs/concepts/security/)
- [Falco Documentation](https://falco.org/docs/)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [AppArmor in Kubernetes](https://kubernetes.io/docs/tutorials/security/apparmor/)
