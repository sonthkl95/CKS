# CKS Practice Labs (CKS-PREP-2025)

Practical CKS (Certified Kubernetes Security Specialist) lab exercises derived from real exam scenarios. Each question lives in its own folder with three bash files:

- `LabSetUp.bash` — copy/paste into Killercoda (or any Kubernetes cluster) to prep the environment.
- `Questions.bash` — the scenario text and task description.
- `SolutionNotes.bash` — step-by-step solution when you need a hint.

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

## References

- [CKS Exam Curriculum](https://github.com/cncf/curriculum)
- [Kubernetes Security Documentation](https://kubernetes.io/docs/concepts/security/)
- [Falco Documentation](https://falco.org/docs/)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [AppArmor in Kubernetes](https://kubernetes.io/docs/tutorials/security/apparmor/)
