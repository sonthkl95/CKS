#!/usr/bin/env python3
"""Regenerate Questions.bash and SolutionNotes.bash for every lab folder so that
the question text and the solution match the correct source question extracted
from the Udemy .mhtml review pages (scripts/questions_solutions.json).

The mapping folder -> (test, question) was verified by matching the distinctive
identifiers (namespaces, resource names, file paths, embedded answer snippets)
inside each folder's original LabSetUp.bash against the source questions.
"""
import json
from pathlib import Path

BASE = Path(__file__).resolve().parent.parent
DATA = json.load(open(BASE / "scripts" / "questions_solutions.json", encoding="utf-8"))

# folder (relative to repo root) -> "T<test>Q<num>"
MAPPING = {
    "1-Cluster-Setup/Question-01-Anonymous-API-Access": "T1Q4",
    "1-Cluster-Setup/Question-02-CIS-Benchmark": "T2Q11",
    "1-Cluster-Setup/Question-03-Encryption-at-Rest": "T1Q8",
    "1-Cluster-Setup/Question-04-Upgrade": "T1Q15",
    "2-Cluster-Hardening/Question-01-ServiceAccount-Token": "T1Q3",
    "2-Cluster-Hardening/Question-02-RBAC-Permissions": "T3Q14",
    "2-Cluster-Hardening/Question-03-RoleBinding-Secret": "T2Q9",
    "2-Cluster-Hardening/Question-04-Secret": "T2Q10",
    "2-Cluster-Hardening/Question-05-RBAC-Anonymous-Kubelet": "T1Q7",
    "2-Cluster-Hardening/Question-06-Mount-Secret": "T2Q12",
    "2-Cluster-Hardening/Question-07-ServiceAccount-RoleBinding-ClusterRole": "T2Q14",
    "2-Cluster-Hardening/Question-08-ServiceAccount-Mount-Secret": "T2Q15",
    "2-Cluster-Hardening/Question-09-Secret": "T3Q6",
    "2-Cluster-Hardening/Question-10-ServiceAccount-Mount": "T3Q11",
    "2-Cluster-Hardening/Question-11-ServiceAccount": "T4Q2",
    "2-Cluster-Hardening/Question-12-ServiceAccount": "T4Q4",
    "3-System-Hardening/Question-01-AppArmor": "T1Q1",
    "3-System-Hardening/Question-02-Seccomp-Profile": "T3Q2",
    "3-System-Hardening/Question-03-AppArmor": "T2Q1",
    "4-Minimize-Microservice-Vulnerabilities/Question-01-NetworkPolicy-DenyAll": "T1Q2",
    "4-Minimize-Microservice-Vulnerabilities/Question-02-RuntimeClass-gVisor": "T1Q10",
    "4-Minimize-Microservice-Vulnerabilities/Question-03-Pod-Security-Standards": "T3Q16",
    "4-Minimize-Microservice-Vulnerabilities/Question-04-Privileged-Immutable-Stateless": "T1Q9",
    "4-Minimize-Microservice-Vulnerabilities/Question-05-Privileged-Mount-docker.sock": "T1Q12",
    "4-Minimize-Microservice-Vulnerabilities/Question-06-mTLS-Istio": "T1Q13",
    "4-Minimize-Microservice-Vulnerabilities/Question-07-PodSecurity-Admission": "T1Q14",
    "4-Minimize-Microservice-Vulnerabilities/Question-08-NetworkPolicy-Network": "T2Q5",
    "4-Minimize-Microservice-Vulnerabilities/Question-09-ServiceAccount-RoleBinding-ClusterRole": "T2Q8",
    "4-Minimize-Microservice-Vulnerabilities/Question-10-Identify-Service-Running": "T2Q13",
    "4-Minimize-Microservice-Vulnerabilities/Question-11-NetworkPolicy-Cilium-Network": "T3Q1",
    "4-Minimize-Microservice-Vulnerabilities/Question-12-Mount-docker.sock": "T3Q3",
    "4-Minimize-Microservice-Vulnerabilities/Question-13-NetworkPolicy-Network": "T3Q5",
    "4-Minimize-Microservice-Vulnerabilities/Question-14-ServiceAccount-RoleBinding-ClusterRole": "T3Q12",
    "4-Minimize-Microservice-Vulnerabilities/Question-15-Mount-docker.sock": "T4Q1",
    "4-Minimize-Microservice-Vulnerabilities/Question-16-NetworkPolicy-Network": "T4Q5",
    "4-Minimize-Microservice-Vulnerabilities/Question-17-ServiceAccount-RoleBinding-ClusterRole": "T4Q6",
    "4-Minimize-Microservice-Vulnerabilities/Question-18-NetworkPolicy-Network": "T4Q7",
    "5-Supply-Chain-Security/Question-01-Dockerfile-Pod-Security": "T1Q6",
    "5-Supply-Chain-Security/Question-02-Trivy-Scanning": "T2Q3",
    "5-Supply-Chain-Security/Question-03-Binary-Integrity": "T3Q15",
    "5-Supply-Chain-Security/Question-04-ImagePolicy-Webhook": "T1Q11",
    "5-Supply-Chain-Security/Question-05-Kubesec-Scan-Manifest": "T2Q6",
    "5-Supply-Chain-Security/Question-06-gVisor-RuntimeClass": "T2Q7",
    "5-Supply-Chain-Security/Question-07-ImagePolicy-Webhook-Admission": "T2Q16",
    "5-Supply-Chain-Security/Question-08-Mount-Secret-Token": "T3Q9",
    "5-Supply-Chain-Security/Question-09-Dockerfile-Privileged": "T3Q10",
    "5-Supply-Chain-Security/Question-10-Trivy-SBOM-CycloneDX": "T3Q13",
    "5-Supply-Chain-Security/Question-11-Dockerfile-Privileged-Mount": "T4Q3",
    "5-Supply-Chain-Security/Question-12-Trivy-Namespace-Scan": "T3Q4",
    "6-Monitoring-Logging-Runtime-Security/Question-01-Audit-Logging": "T1Q5",
    "6-Monitoring-Logging-Runtime-Security/Question-02-Falco-Threat-Detection": "T1Q16",
    "6-Monitoring-Logging-Runtime-Security/Question-03-Falco-Sysdig": "T2Q4",
    "6-Monitoring-Logging-Runtime-Security/Question-04-Audit-Secret": "T2Q2",
    "6-Monitoring-Logging-Runtime-Security/Question-05-Falco": "T3Q7",
    "6-Monitoring-Logging-Runtime-Security/Question-06-Audit": "T3Q8",
}

TEST_TITLE = {1: "Practice Test 1", 2: "Practice Test 2",
              3: "Practice Test 3", 4: "Practice Test 4"}


def get_q(tag: str):
    test = int(tag[1])
    num = int(tag[3:])
    for q in DATA[f"test{test}"]:
        if q["num"] == num:
            return test, num, q
    raise KeyError(tag)


def banner(title: str) -> str:
    line = "=" * 63
    return f"{line}\n  {title}\n{line}"


def write_questions(folder: Path, test: int, num: int, q: dict):
    body = q["prompt"].strip()
    content = (
        "#!/bin/bash\n"
        f"# Questions.bash  —  CKS {TEST_TITLE[test]}, Question {num}\n"
        "# Source: Udemy CKS Practice Tests (lab/*.mhtml)\n\n"
        "cat << 'CKS_TASK_EOF'\n"
        f"{banner(f'CKS {TEST_TITLE[test]}  ·  Question {num}')}\n\n"
        f"{body}\n\n"
        f"{'=' * 63}\n"
        "CKS_TASK_EOF\n"
    )
    (folder / "Questions.bash").write_text(content, encoding="utf-8")


def write_solution(folder: Path, test: int, num: int, q: dict):
    body = q["solution"].strip() or "No solution content was provided in the source."
    content = (
        "#!/bin/bash\n"
        f"# SolutionNotes.bash  —  CKS {TEST_TITLE[test]}, Question {num}\n"
        "# Source: Udemy CKS Practice Tests (lab/*.mhtml) — official 'Correct answer' explanation\n\n"
        "cat << 'CKS_SOLUTION_EOF'\n"
        f"{banner(f'SOLUTION  ·  CKS {TEST_TITLE[test]}  ·  Question {num}')}\n\n"
        f"{body}\n\n"
        f"{'=' * 63}\n"
        "CKS_SOLUTION_EOF\n"
    )
    (folder / "SolutionNotes.bash").write_text(content, encoding="utf-8")


def main():
    missing = []
    for rel, tag in MAPPING.items():
        folder = BASE / rel
        if not folder.exists():
            missing.append(rel)
            continue
        test, num, q = get_q(tag)
        # guard: content must not contain the heredoc delimiters
        assert "CKS_TASK_EOF" not in q["prompt"]
        assert "CKS_SOLUTION_EOF" not in q["solution"]
        write_questions(folder, test, num, q)
        write_solution(folder, test, num, q)
        print(f"[ok] {rel:70s} <- {tag}")
    if missing:
        print("\nMissing folders (skipped):")
        for m in missing:
            print("  ", m)
    # sanity: bijection check
    tags = list(MAPPING.values())
    dupes = {t for t in tags if tags.count(t) > 1}
    print(f"\n{len(tags)} mappings, {len(set(tags))} unique. Duplicates: {dupes or 'none'}")


if __name__ == "__main__":
    main()
