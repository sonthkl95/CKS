import os
import json
import re
from pathlib import Path

# Load extracted questions
with open('d:/CKS/extracted_questions.json', 'r', encoding='utf-8') as f:
    questions_data = json.load(f)

base_dir = Path('d:/CKS')

def extract_keywords(folder_name):
    # Example: Question-15-Mount-docker.sock -> Mount, docker, sock
    # Remove "Question-XX-"
    name_parts = folder_name.split('-')[2:]
    keywords = []
    for part in name_parts:
        keywords.extend(part.split('.'))
    return [k.lower() for k in keywords if len(k) > 2]

for root_dir in base_dir.iterdir():
    if not root_dir.is_dir() or root_dir.name.startswith('.') or root_dir.name in ('scripts', 'lab'):
        continue
    
    for question_dir in root_dir.iterdir():
        if question_dir.is_dir() and question_dir.name.startswith('Question-'):
            # It's a lab directory
            keywords = extract_keywords(question_dir.name)
            
            # Find best match
            best_match = None
            best_score = -1
            
            for q in questions_data:
                body_lower = q['body'].lower()
                score = sum(1 for kw in keywords if kw in body_lower)
                if score > best_score:
                    best_score = score
                    best_match = q
            
            if best_match and best_score > 0:
                q_text = f"#!/bin/bash\ncat << 'EOF'\n=======================================================\n  {best_match['header']} - Matched via Keywords\n=======================================================\n\n{best_match['body']}\n\n=======================================================\nEOF\n"
            else:
                q_text = f"#!/bin/bash\ncat << 'EOF'\n=======================================================\n  CKS Practice Task\n=======================================================\n\nPlease refer to the `LabSetUp.bash` script in this directory to understand the environment and the task requirements.\nThe goal of this lab is implied by the directory name and the resources created by `LabSetUp.bash`.\n\n=======================================================\nEOF\n"
            
            # Overwrite Questions.bash
            q_file = question_dir / 'Questions.bash'
            try:
                with open(q_file, 'w', encoding='utf-8') as f:
                    f.write(q_text)
            except Exception as e:
                print(f"Failed to write {q_file}: {e}")

            # Overwrite SolutionNotes.bash
            s_text = f"#!/bin/bash\ncat << 'EOF'\n=======================================================\n  Solution Notes\n=======================================================\n\nSince the original solution notes were incorrectly copied across multiple labs, they have been removed to avoid confusion.\nPlease refer to the CKS documentation to solve the task presented in `LabSetUp.bash`.\n\n=======================================================\nEOF\n"
            s_file = question_dir / 'SolutionNotes.bash'
            try:
                with open(s_file, 'w', encoding='utf-8') as f:
                    f.write(s_text)
            except Exception as e:
                print(f"Failed to write {s_file}: {e}")

print("Successfully processed all directories.")
