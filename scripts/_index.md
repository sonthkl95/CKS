### Practice Test → Lab folder

**Practice Test 1**

| Q | Topic | Lab folder |
|---|-------|-----------|
| 1 | Enforce a prepared AppArmor profile on a specific worker node and depl | [3-System-Hardening/Question-01-AppArmor](3-System-Hardening/Question-01-AppArmor) |
| 2 | Create a NetworkPolicy named deny-all in the testing namespace that bl | [4-Minimize-Microservice-Vulnerabilities/Question-01-NetworkPolicy-DenyAll](4-Minimize-Microservice-Vulnerabilities/Question-01-NetworkPolicy-DenyAll) |
| 3 | A Pod nginx-pod is running in the default namespace and uses a token b | [2-Cluster-Hardening/Question-01-ServiceAccount-Token](2-Cluster-Hardening/Question-01-ServiceAccount-Token) |
| 4 | The cluster’s API server was temporarily configured to allow unauthent | [1-Cluster-Setup/Question-01-Anonymous-API-Access](1-Cluster-Setup/Question-01-Anonymous-API-Access) |
| 5 | Enable Kubernetes audit logging with custom retention and policy rules | [6-Monitoring-Logging-Runtime-Security/Question-01-Audit-Logging](6-Monitoring-Logging-Runtime-Security/Question-01-Audit-Logging) |
| 6 | You are given a Dockerfile and a Pod manifest. Both contain security b | [5-Supply-Chain-Security/Question-01-Dockerfile-Pod-Security](5-Supply-Chain-Security/Question-01-Dockerfile-Pod-Security) |
| 7 | Fix multiple security violations identified by kube-bench. API Server: | [2-Cluster-Hardening/Question-05-RBAC-Anonymous-Kubelet](2-Cluster-Hardening/Question-05-RBAC-Anonymous-Kubelet) |
| 8 | By default, Kubernetes stores Secrets in etcd in plaintext, which is i | [1-Cluster-Setup/Question-03-Encryption-at-Rest](1-Cluster-Setup/Question-03-Encryption-at-Rest) |
| 9 | Ensure that all Pods in the prod namespace follow the best practices o | [4-Minimize-Microservice-Vulnerabilities/Question-04-Privileged-Immutable-Stateless](4-Minimize-Microservice-Vulnerabilities/Question-04-Privileged-Immutable-Stateless) |
| 10 | The cluster uses containerd with runc as the default runtime. It has b | [4-Minimize-Microservice-Vulnerabilities/Question-02-RuntimeClass-gVisor](4-Minimize-Microservice-Vulnerabilities/Question-02-RuntimeClass-gVisor) |
| 11 | The cluster has a container image scanner webhook but its configuratio | [5-Supply-Chain-Security/Question-04-ImagePolicy-Webhook](5-Supply-Chain-Security/Question-04-ImagePolicy-Webhook) |
| 12 | A Pod in the namespace dev-ops is mounting /var/run/docker.sock from t | [4-Minimize-Microservice-Vulnerabilities/Question-05-Privileged-Mount-docker.sock](4-Minimize-Microservice-Vulnerabilities/Question-05-Privileged-Mount-docker.sock) |
| 13 | Enable Istio Mutual TLS (mTLS) in STRICT mode for all workloads in the | [4-Minimize-Microservice-Vulnerabilities/Question-06-mTLS-Istio](4-Minimize-Microservice-Vulnerabilities/Question-06-mTLS-Istio) |
| 14 | The namespace secure-team is configured with Pod Security Admission la | [4-Minimize-Microservice-Vulnerabilities/Question-07-PodSecurity-Admission](4-Minimize-Microservice-Vulnerabilities/Question-07-PodSecurity-Admission) |
| 15 | One of the worker nodes in the cluster, worker-1, is running Kubernete | [1-Cluster-Setup/Question-04-Upgrade](1-Cluster-Setup/Question-04-Upgrade) |
| 16 | Cluster security monitoring revealed that a malicious container is att | [6-Monitoring-Logging-Runtime-Security/Question-02-Falco-Threat-Detection](6-Monitoring-Logging-Runtime-Security/Question-02-Falco-Threat-Detection) |

**Practice Test 2**

| Q | Topic | Lab folder |
|---|-------|-----------|
| 1 | Enforce a prepared AppArmor profile on a Kubernetes Pod: Apply the ngi | [3-System-Hardening/Question-03-AppArmor](3-System-Hardening/Question-03-AppArmor) |
| 2 | Enable and configure Kubernetes audit logging with specific retention, | [6-Monitoring-Logging-Runtime-Security/Question-04-Audit-Secret](6-Monitoring-Logging-Runtime-Security/Question-04-Audit-Secret) |
| 3 | Scan two container images for high and critical vulnerabilities using  | [5-Supply-Chain-Security/Question-02-Trivy-Scanning](5-Supply-Chain-Security/Question-02-Trivy-Scanning) |
| 4 | Monitor container behavior on a worker node using Falco or any similar | [6-Monitoring-Logging-Runtime-Security/Question-03-Falco-Sysdig](6-Monitoring-Logging-Runtime-Security/Question-03-Falco-Sysdig) |
| 5 | Create a NetworkPolicy named restricted-policy to restrict access to t | [4-Minimize-Microservice-Vulnerabilities/Question-08-NetworkPolicy-Network](4-Minimize-Microservice-Vulnerabilities/Question-08-NetworkPolicy-Network) |
| 6 | Use KubeSec to scan a Pod manifest for security issues and apply sugge | [5-Supply-Chain-Security/Question-05-Kubesec-Scan-Manifest](5-Supply-Chain-Security/Question-05-Kubesec-Scan-Manifest) |
| 7 | Deploy a Pod using a custom RuntimeClass: Create a RuntimeClass named  | [5-Supply-Chain-Security/Question-06-gVisor-RuntimeClass](5-Supply-Chain-Security/Question-06-gVisor-RuntimeClass) |
| 8 | Create a PodSecurityPolicy that blocks privileged Pods within a specif | [4-Minimize-Microservice-Vulnerabilities/Question-09-ServiceAccount-RoleBinding-ClusterRole](4-Minimize-Microservice-Vulnerabilities/Question-09-ServiceAccount-RoleBinding-ClusterRole) |
| 9 | Create a new Kubernetes user, approve its certificate, and assign name | [2-Cluster-Hardening/Question-03-RoleBinding-Secret](2-Cluster-Hardening/Question-03-RoleBinding-Secret) |
| 10 | Deploy an Nginx Pod with TLS-enabled ingress in the testing namespace: | [2-Cluster-Hardening/Question-04-Secret](2-Cluster-Hardening/Question-04-Secret) |
| 11 | A CIS Benchmark scan revealed multiple violations on the API server, K | [1-Cluster-Setup/Question-02-CIS-Benchmark](1-Cluster-Setup/Question-02-CIS-Benchmark) |
| 12 | Retrieve the contents of the existing secret admin in the safe namespa | [2-Cluster-Hardening/Question-06-Mount-Secret](2-Cluster-Hardening/Question-06-Mount-Secret) |
| 13 | Identify a service running on port 389, list all its open files, and r | [4-Minimize-Microservice-Vulnerabilities/Question-10-Identify-Service-Running](4-Minimize-Microservice-Vulnerabilities/Question-10-Identify-Service-Running) |
| 14 | Modify the existing Role bound to ServiceAccount sa-dev-1 (used by Pod | [2-Cluster-Hardening/Question-07-ServiceAccount-RoleBinding-ClusterRole](2-Cluster-Hardening/Question-07-ServiceAccount-RoleBinding-ClusterRole) |
| 15 | A Pod token-demo is running in the default namespace and uses the defa | [2-Cluster-Hardening/Question-08-ServiceAccount-Mount-Secret](2-Cluster-Hardening/Question-08-ServiceAccount-Mount-Secret) |
| 16 | Integrate the cluster’s container image scanner to reject vulnerable i | [5-Supply-Chain-Security/Question-07-ImagePolicy-Webhook-Admission](5-Supply-Chain-Security/Question-07-ImagePolicy-Webhook-Admission) |

**Practice Test 3**

| Q | Topic | Lab folder |
|---|-------|-----------|
| 1 | In Namespace team-dev, there is an existing CiliumNetworkPolicy defaul | [4-Minimize-Microservice-Vulnerabilities/Question-11-NetworkPolicy-Cilium-Network](4-Minimize-Microservice-Vulnerabilities/Question-11-NetworkPolicy-Cilium-Network) |
| 2 | For security hardening, enforce a Seccomp profile on Pods in Namespace | [3-System-Hardening/Question-02-Seccomp-Profile](3-System-Hardening/Question-02-Seccomp-Profile) |
| 3 | A Pod in namespace ci-cd mounts /var/run/docker.sock from the host. By | [4-Minimize-Microservice-Vulnerabilities/Question-12-Mount-docker.sock](4-Minimize-Microservice-Vulnerabilities/Question-12-Mount-docker.sock) |
| 4 | Use Trivy to scan container images used by Pods in the nato namespace  | [5-Supply-Chain-Security/Question-12-Trivy-Namespace-Scan](5-Supply-Chain-Security/Question-12-Trivy-Namespace-Scan) |
| 5 | Create a default-deny NetworkPolicy named default-deny in the testing  | [4-Minimize-Microservice-Vulnerabilities/Question-13-NetworkPolicy-Network](4-Minimize-Microservice-Vulnerabilities/Question-13-NetworkPolicy-Network) |
| 6 | Create a service account named backend-qa in the qa namespace that can | [2-Cluster-Hardening/Question-09-Secret](2-Cluster-Hardening/Question-09-Secret) |
| 7 | Use Falco or Sysdig to monitor a single-container Pod named tomcat for | [6-Monitoring-Logging-Runtime-Security/Question-05-Falco](6-Monitoring-Logging-Runtime-Security/Question-05-Falco) |
| 8 | Enable audit logging in the cluster. Configure log backend with the fo | [6-Monitoring-Logging-Runtime-Security/Question-06-Audit](6-Monitoring-Logging-Runtime-Security/Question-06-Audit) |
| 9 | A development team needs to securely provide configuration data and cr | [5-Supply-Chain-Security/Question-08-Mount-Secret-Token](5-Supply-Chain-Security/Question-08-Mount-Secret-Token) |
| 10 | Review and correct security and best-practice issues in an existing Do | [5-Supply-Chain-Security/Question-09-Dockerfile-Privileged](5-Supply-Chain-Security/Question-09-Dockerfile-Privileged) |
| 11 | Organization’s security policy requires: ServiceAccounts must not auto | [2-Cluster-Hardening/Question-10-ServiceAccount-Mount](2-Cluster-Hardening/Question-10-ServiceAccount-Mount) |
| 12 | Implement a PodSecurityPolicy that restricts Pod volumes and bind it t | [4-Minimize-Microservice-Vulnerabilities/Question-14-ServiceAccount-RoleBinding-ClusterRole](4-Minimize-Microservice-Vulnerabilities/Question-14-ServiceAccount-RoleBinding-ClusterRole) |
| 13 | Generate Software Bill Of Materials (SBOM) documents for specific Kube | [5-Supply-Chain-Security/Question-10-Trivy-SBOM-CycloneDX](5-Supply-Chain-Security/Question-10-Trivy-SBOM-CycloneDX) |
| 14 | Adjust overly broad Role permissions assigned to a Pod's ServiceAccoun | [2-Cluster-Hardening/Question-02-RBAC-Permissions](2-Cluster-Hardening/Question-02-RBAC-Permissions) |
| 15 | Validate the integrity of four Kubernetes server binaries located at / | [5-Supply-Chain-Security/Question-03-Binary-Integrity](5-Supply-Chain-Security/Question-03-Binary-Integrity) |
| 16 | In the namespace team-blue, developers deployed a Pod running in privi | [4-Minimize-Microservice-Vulnerabilities/Question-03-Pod-Security-Standards](4-Minimize-Microservice-Vulnerabilities/Question-03-Pod-Security-Standards) |

**Practice Test 4**

| Q | Topic | Lab folder |
|---|-------|-----------|
| 1 | A Deployment docker-admin in namespace sandbox mounts /var/run/docker. | [4-Minimize-Microservice-Vulnerabilities/Question-15-Mount-docker.sock](4-Minimize-Microservice-Vulnerabilities/Question-15-Mount-docker.sock) |
| 2 | You have an existing Pod named nginx-pod in the test-system namespace. | [2-Cluster-Hardening/Question-11-ServiceAccount](2-Cluster-Hardening/Question-11-ServiceAccount) |
| 3 | Review a Dockerfile based on ubuntu:20.04 and a Kubernetes Deployment  | [5-Supply-Chain-Security/Question-11-Dockerfile-Privileged-Mount](5-Supply-Chain-Security/Question-11-Dockerfile-Privileged-Mount) |
| 4 | Create a new ServiceAccount backend-sa in the default namespace that c | [2-Cluster-Hardening/Question-12-ServiceAccount](2-Cluster-Hardening/Question-12-ServiceAccount) |
| 5 | Create a NetworkPolicy named allow-np that: Allows Pods in namespace s | [4-Minimize-Microservice-Vulnerabilities/Question-16-NetworkPolicy-Network](4-Minimize-Microservice-Vulnerabilities/Question-16-NetworkPolicy-Network) |
| 6 | Prevent privileged pods from being created in the default namespace us | [4-Minimize-Microservice-Vulnerabilities/Question-17-ServiceAccount-RoleBinding-ClusterRole](4-Minimize-Microservice-Vulnerabilities/Question-17-ServiceAccount-RoleBinding-ClusterRole) |
| 7 | Create a default-deny NetworkPolicy in the test namespace to prevent a | [4-Minimize-Microservice-Vulnerabilities/Question-18-NetworkPolicy-Network](4-Minimize-Microservice-Vulnerabilities/Question-18-NetworkPolicy-Network) |

