#!/bin/bash
echo "[+] Initializing Lab Environment..."
kubectl create namespace secure-team --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace secure-teamkubectl --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /home/masters
cat << 'EOF_MOCK' > /home/masters/insecure-deployment.yaml
---apiVersion: apps/v1kind: Deploymentmetadata:  name: webapp  namespace: secure-teamspec:  replicas: 1  selector:    matchLabels:      app: webapp  template:    metadata:      labels:        app: webapp    spec:      containers:      - name: webapp        image: nginx:1.23        ports:        - containerPort: 80        securityContext:          privileged: true        # -> triggers: .securityContext.privileged=true          runAsUser: 0            # -> triggers: .securityContext.runAsUser=0          capabilities:            add: ["NET_ADMIN"]    # -> triggers: .capabilities.add=["NET_ADMIN"]        volumeMounts:        - mountPath: /data          name: host-data         # -> triggers: spec.volumes[0].hostPath = /tmp      volumes:      - name: host-data        hostPath:          path: /tmp
EOF_MOCK
echo "[+] Lab Setup Complete."