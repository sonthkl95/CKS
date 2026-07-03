#!/bin/bash
# LabSetUp.bash — prepares the environment for this task.
# Run this first (paste into Killercoda or your practice cluster).

echo "[+] Starting a mock service listening on TCP port 389 (LDAP)..."
mkdir -p /candidate/13
BIN=/usr/local/bin/ldap-mock
cat > "$BIN" <<'EOF'
#!/bin/bash
exec nc -lk -p 389
EOF
chmod +x "$BIN" 2>/dev/null
( setsid "$BIN" >/dev/null 2>&1 & ) 2>/dev/null \
  && echo "    mock service started (binary: $BIN)" \
  || echo "    (install netcat, or use the real service on port 389)"
echo ""
echo "[i] Task: find the PID listening on 389, save its open files to /candidate/13/files.txt,"
echo "    locate the process binary and delete it."
echo "[+] Lab Setup Complete."
