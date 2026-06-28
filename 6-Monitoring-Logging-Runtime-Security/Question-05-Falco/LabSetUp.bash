#!/bin/bash
echo "[+] Initializing Lab Environment..."
mkdir -p /etc/falco
touch /etc/falco/falco_rules.local.yaml
mkdir -p /etc/falco
touch /etc/falco/falco.yaml
echo "[+] Lab Setup Complete."