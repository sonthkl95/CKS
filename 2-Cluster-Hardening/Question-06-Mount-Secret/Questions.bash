#!/bin/bash
# Questions.bash  —  CKS Practice Test 2, Question 12
# Source: Udemy CKS Practice Tests (lab/*.mhtml)

cat << 'CKS_TASK_EOF'
===============================================================
  CKS Practice Test 2  ·  Question 12
===============================================================

Retrieve the contents of the existing secret `admin` in the `safe` namespace.

Store the fields into local files:

`username` → `/home/cert-masters/username.txt`

`password` → `/home/cert-masters/password.txt`

Create a new secret `newsecret` in the `safe` namespace with credentials:

username: `dbadmin`

password: `moresecurepas`

Create a new pod that mounts this new secret.

Constraints:

Both files must be created (they do not exist initially).

Do not reuse these files for later steps — create new resources independently.

===============================================================
CKS_TASK_EOF
