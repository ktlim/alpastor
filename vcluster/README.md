To create a new vcluster for a group, one needs to

- copy the entire directory of one of the existing vclusters with `cp -rp one two`. do a find/replace of the old vcluster to the new one.
- generate an oidc secret for authnz to the cluster, use `openssl rand -base64 32 | tr -d '\n'`. create a secret in vault somewhere apt (like `rubin/usdf-staffrsp-dev/kubernetes` with `client-id` and `client-secret` and store the secret in the latter. the former should start with the prefix `vcluster--` and match the namespace used.
- add an entry into the `staticClients` of dex (under alpastor/dexidp) to dynamically inject the secret from vault. `k apply` it.
- create a dns entry for the api endpoint in netdb and assign it to the appropriate k8s cluster ingress VIP. modify the endpoints.yaml to suit.
- `make apply`


