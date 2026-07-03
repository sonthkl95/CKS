#!/bin/bash
# scripts/run-lab.sh
# Usage: bash scripts/run-lab.sh <Domain-Folder/Question-Folder>
# Example: bash scripts/run-lab.sh "3-System-Hardening/Question-01-AppArmor"

set -e

QUESTION_DIR="${1:-}"

if [[ -z "$QUESTION_DIR" ]]; then
  echo "Usage: bash scripts/run-lab.sh <Domain-Folder/Question-Folder>"
  echo ""
  echo "Available domains:"
  ls -d [1-6]-* 2>/dev/null
  exit 1
fi

if [[ ! -d "$QUESTION_DIR" ]]; then
  echo "❌ Directory '$QUESTION_DIR' not found."
  echo "Usage example: bash scripts/run-lab.sh 1-Cluster-Setup/Question-01-Anonymous-API-Access"
  exit 1
fi

echo "=================================================="
echo "  CKS Lab: $QUESTION_DIR"
echo "=================================================="
echo ""

# Run LabSetUp
if [[ -f "$QUESTION_DIR/LabSetUp.bash" ]]; then
  echo "🔧 Running Lab Setup..."
  echo "--------------------------------------------------"
  bash "$QUESTION_DIR/LabSetUp.bash"
  echo ""
  echo "✅ Lab environment is ready!"
else
  echo "⚠️  No LabSetUp.bash found — environment may not need setup."
fi

echo ""
echo "📋 Read the question in: $QUESTION_DIR/Questions.bash"
echo "💡 See the solution in:  $QUESTION_DIR/SolutionNotes.bash"
echo "=================================================="
