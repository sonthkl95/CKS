#!/bin/bash
cat << 'EOF'
=======================================================
  Solution for Test 4 - Question 2
=======================================================

The ServiceAccount associated with a Pod determines which permissions it has.
By creating a Role scoped to Deployments and binding it to the ServiceAccount, we grant the Pod the necessary access without granting cluster-wide permissions.

Commands / Steps

```yaml
# Fetch the ServiceAccount used by nginx-pod
kubectl get pods -n test-system nginx-pod -o yaml \
| grep -i serviceAccount
# Save the ServiceAccount name to a file
echo "sa-dev-1" > /candidate/sa-name.txt
# Create a Role with permissions to list, get, and watch Deployments
kubectl create role dev-test-role -n test-system --verb=get,list,watch \
--resource=deployments
# Create a RoleBinding to bind the Role to the Pod's ServiceAccount
kubectl create rolebinding dev-test-role-binding --role=dev-test-role \
--serviceaccount=test-system:sa-dev-1 -n test-system
```

''Note:
Ensure the RoleBinding references the correct namespace and ServiceAccount.

This grants permissions only within test-system namespace (namespace-scoped Role)

=======================================================
EOF
