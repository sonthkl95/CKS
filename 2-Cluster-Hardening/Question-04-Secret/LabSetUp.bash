#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

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
