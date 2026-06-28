#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 3 - Question 1
=======================================================

Step 1: Verify Pod labels and IPs

```yaml
kubectl get pod -n team-dev --show-labels -o wide
```

Example output:

```yaml
NAME                         ...     IP           ...   LABELS
database-0                   ...   10.244.2.122    ...   ...,role=database
api-service-57f557cd65-rhzd7 ...   10.244.1.171    ...   ...,role=api-service
api-service-57f557cd65-xcqwz ...   10.244.2.44     ...   ...,role=api-service
stuff-866696fc57-6ccgr       ...   10.244.1.15     ...   ...,role=stuff
stuff-866696fc57-d8qk4       ...   10.244.2.222    ...   ...,role=stuff
backend-0                    ...   10.244.3.10     ...   ...,role=backend
```

Step 2: Create CiliumNetworkPolicy to deny ICMP traffic from stuff to backend

```yaml
# cnp-icmp-deny.yaml
apiVersion: "cilium.io/v2"
kind: CiliumNetworkPolicy
metadata:
name: team-dev
namespace: team-dev
spec:
endpointSelector:
matchLabels:
role: stuff  # Pods behind Deployment "stuff"
egressDeny:
- toEndpoints:
- matchLabels:
role: backend  # Pods behind Service "backend"
icmps:
- fields:
- type: 8
family: IPv4
- type: EchoRequest
family: IPv6
```

```yaml
kubectl apply -f cnp-icmp-deny.yaml
```

Step 3: Create CiliumNetworkPolicy to enforce Mutual Authentication from database -> api-service

```yaml
# cnp-mtls.yaml
apiVersion: "cilium.io/v2"
kind: CiliumNetworkPolicy
metadata:
name: team-dev-2
namespace: team-dev
spec:
endpointSelector:
matchLabels:
role: database
egress:
- toEndpoints:
- matchLabels:
role: api-service
authentication:
mode: "required"  # Enable Mutual Authentication
```

```yaml
kubectl apply -f cnp-mtls.yaml
```

Step 4: Verify policies are applied

```yaml
# Check applied CiliumNetworkPolicies
kubectl get cnp -n team-dev
# Test ICMP block (stuff -> backend)
kubectl exec -n team-dev stuff-866696fc57-6ccgr -- ping -c 1 <backend-pod-IP>
# Should fail due to ICMP deny
# Test outgoing traffic from database to api-service (Mutual Authentication enforced)
kubectl exec -n team-dev database-0 -- curl http://<api-service-pod-IP>
# Connection should succeed only if authenticated
```

Explanation
endpointSelector -> selects Pods the policy applies to.

egressDeny -> blocks ICMP traffic from stuff Pods to backend Pods.

egress.authentication.mode=required -> enforces Mutual TLS for traffic from database to api-service.

By keeping default-allow intact, intra-namespace and DNS traffic remain allowed.

'' Notes:
ICMP types 8 (IPv4) and EchoRequest (IPv6) are the ones used for ping.

Mutual Authentication ensures encrypted and verified communication between selected Pods.

Policies are additive; multiple CNPs can coexist to enforce different rules for different traffic flows.

=======================================================
EOF
