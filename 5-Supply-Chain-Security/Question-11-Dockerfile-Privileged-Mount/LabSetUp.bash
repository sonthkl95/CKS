#!/bin/bash
echo "[+] Initializing Lab Environment..."
mkdir -p /home/manifests
cat << 'EOF_MOCK' > /home/manifests/Dockerfile
FROM ubuntu:20.04      # -> Fixed: use specific version instead of latest RUN apt-get update && \    apt-get install -y --no-install-recommends ca-certificates curl && \    rm -rf /var/lib/apt/lists/*WORKDIR /appCOPY app /appRUN chmod -R a+rX /appUSER root              # -> Fixed: run container as unprivileged userCMD ["./start.sh"]
EOF_MOCK
mkdir -p /home/manifests
cat << 'EOF_MOCK' > /home/manifests/deployment.yaml
FROM ubuntu:20.04      # -> Fixed: use specific version instead of latest RUN apt-get update && \    apt-get install -y --no-install-recommends ca-certificates curl && \    rm -rf /var/lib/apt/lists/*WORKDIR /appCOPY app /appRUN chmod -R a+rX /appUSER root              # -> Fixed: run container as unprivileged userCMD ["./start.sh"]
EOF_MOCK
echo "[+] Lab Setup Complete."