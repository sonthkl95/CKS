#!/bin/bash
# SolutionNotes.bash  —  CKS Practice Test 1, Question 15
# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation

cat << 'CKS_SOLUTION_EOF'
===============================================================
  SOLUTION  ·  CKS Practice Test 1  ·  Question 15
===============================================================

Commands / Steps:

```bash
# Check current versions
kubectl get nodes -o wide

# Drain the node
kubectl drain worker-1 --ignore-daemonsets

# SSH into worker-1
ssh worker-1
sudo -i

# Check current versions
kubeadm version

# If you don't see the version you expect to upgrade to, verify if the Kubernetes package repositories are used
# Open the file that defines the Kubernetes apt repository using a text editor of your choice:
vim /etc/apt/sources.list.d/kubernetes.list

# Change the version in the URL to the next available minor release, for example:
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /

# Save the file and exit your text editor. Continue following the relevant upgrade instructions.

# Upgrade kubeadm
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm='1.33.0-0.0' && \
sudo apt-mark hold kubeadm

# Apply node upgrade
sudo kubeadm upgrade node

# Upgrade kubelet and kubectl
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && \
sudo apt-get install -y kubelet='1.33.0-0.0' kubectl='1.33.0-0.0' && \
sudo apt-mark hold kubelet kubectl

# Restart kubelet
sudo systemctl daemon-reload
sudo systemctl restart kubelet
exit

# Uncordon the node / Bring the node back online by marking it schedulable
kubectl uncordon worker-1
```

Verification Step:

Verify the status of the cluster:

```bash
kubectl get nodes
```

Confirm that `worker-1` is in Ready state and running v1.33.0.

⚠️ Note:

Always upgrade control plane first before upgrading worker nodes. Ensure workloads are safely drained to avoid data loss.

===============================================================
CKS_SOLUTION_EOF
