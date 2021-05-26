

Installation
===

you will need valid certs! use `certs/csr.config` as a guide for the type of cert required. we cheat by using the same cert for all three vault ha instances for the raft communication (hence DNS.[2-4]). we also include the localhost as a IP.1 to faciliate bootstrapping the vault cluster. then run `cd certs; make csr` to generate the actual csr that will need to be signed.

you will also need to be able to setup dns to point to specific pods. there's a chicken and egg problem here, where we will need to know the actual external ip's of the service first before we can then initiate the vault itself. see below.

finally you will also need some form of permanent storage. we are using hostPaths as specified in `pv.yaml`, but for a final deployment we probably want something more stable.


check this repo out and run `make apply`. This will run the kustomize files.


once up, one will notice that none of the pods will go into a ready state.

if this is the first install, then we will need to initiate the database:

but first we need to know the ip address of the pods and assign dns addresses for them to match that of the certs we created above. specificaly, one will notice a set of Service entries

NAME                     TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)                         AGE
service/vault-0          LoadBalancer   10.99.0.81       172.23.99.146   8200:32517/TCP,8201:32205/TCP   60m
service/vault-1          LoadBalancer   10.98.121.5      172.23.99.147   8200:30492/TCP,8201:30033/TCP   60m
service/vault-2          LoadBalancer   10.107.94.44     172.23.99.148   8200:30645/TCP,8201:30507/TCP   60m

where we will now need to set the external-ips of the above table to dns entries - eg vault-0.slac.stanford.edu -> 172.23.99.146. etc. (the main vault.slac.stanford.edu will be an ingress).

one could do the whole `-tls-skip-verify`, however, as we have to use the same certs for the raft consensus within vault (which must have valid certs), we have to play around with dns rather than using the internal cluster-ips of the kubernetes cluster.

once dns is set, we can:

`kubectl -n vault--prod exec --stdin=true --tty=true vault-0 -- vault operator init -address=https://vault-0.slac.stanford.edu:8200`

upon success, you will be presented with some unseal keys, and an initial root token - KEEP THESE SOMEWHERE SAFE! loss of these will result in loss of all vault data.

Next, we need to unseal each instance of the vault.

`make unseal0`

and enter any 3 of th 5 shamir keys from the initialisation. at the end, the output should show `Sealed=false`

repeat this for the other two pods with `make unseal1` and `make unseal2`. once this is done, all three pods should be up and ready for use!


Initial configuration
===

so we now have vault installed, but we need to popualte with some authentication and authorisation steps. we first 'login' to vault with the root token that was generated from the install before:

We interact with vault with the vault binary which can be downloaded.

`VAULT_ADDR=https://vault.slac.stanford.edu vault login <token>`

it should spit out something similar to 

```
❯ vault login
Token (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                <REDACTED>
token_accessor       <REDACTED>
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]
```

so first thing we'll do is to setup ldap authentication:

`vault auth enable ldap`
```
vault write auth/ldap/config \
    url="ldaps://<REDACTED>.slac.stanford.edu:636" \
    binddn="CN=<REDACTED>,OU=Service-Accounts,OU=SCS,DC=win,DC=slac,DC=stanford,DC=edu" \
    bindpass='<REDACTED>' \
    userattr=sAMAccountName \
    userdn="DC=win,DC=slac,DC=Stanford,DC=edu" \
    groupdn="DC=win,DC=slac,DC=Stanford,DC=edu" \
    groupfilter="(&(objectClass=person)(uid={{.Username}}))" \
    groupattr="memberOf" \
    insecure_tls=false \
    starttls=true
```

we may want to change the service account to something else in the future.

we now need to define some admins. we have a policy file under `policies/admin-policy.hcl` defined. we can commit it by executing

```
cd policies
make admin-policy
```

we have the policy, but we also need to map a real user to it. rather than defining the user, we define an identity to allow for account delegation. we have to map the way the user authenticates with an identity-entity. essentially, we reference the mount_accessor (way user logs in) to a canonical_id which is the 'person'.

so first we find out the method (mount_accessor) for the above ldap authentication:

```
❯ vault auth list
Path      Type     Accessor               Description
----      ----     --------               -----------
ldap/     ldap     auth_ldap_53d93b6a     n/a
token/    token    auth_token_77c2906a    token based credentials
```
in this case, we need `auth_ldap_53d93b6a`.

then we create an entity for our user who we want to be associated with the admin policy we applied above

```
❯ vault write identity/entity name=ytl policies=admin
Key        Value
---        -----
aliases    <nil>
id         d107cb86-31f3-718e-706e-820e71d172d6
name       ytl
```

and we map the entity with the method as follows:

```
❯ vault write identity/entity-alias name="ytl" canonical_id=d107cb86-31f3-718e-706e-820e71d172d6 mount_accessor=auth_ldap_53d93b6a
Key             Value
---             -----
canonical_id    d107cb86-31f3-718e-706e-820e71d172d6
id              3203e543-decd-49a9-fafc-8f01349b6583
```

now to test, we can reauthenticate with vault as follows:

```
❯ vault login -method=ldap
Password (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

WARNING! The following warnings were returned from Vault:

  * no LDAP groups found in groupDN 'DC=win,DC=slac,DC=Stanford,DC=edu'; only
  policies from locally-defined groups available

Key                    Value
---                    -----
token                  <REDACTED>
token_accessor         <REDACTED>
token_duration         768h
token_renewable        true
token_policies         ["default"]
identity_policies      ["admin"]
policies               ["admin" "default"]
token_meta_username    ytl
```

notice the policies include the 'admin' policy we defined prior


Secret Stores

enable the kv secret store:

```
vault secrets enable -path=secret kv-v2
```

Note that we are using the common secret root path /secret in the above. we could create multiple top levels

enable the database secret store:

```
vault secrets enable database
```

enable the kubernetes secret store to facility secret injection into pods

```

export KUBECONFIG=~/.kube/contexts/k8s-master/vault--prod
export SA_NAME=$(kubectl get sa vault-auth -o jsonpath="{.secrets[*]['name']}")
export SA_JWT_TOKEN=$(kubectl get secret $SA_NAME -o jsonpath="{.data.token}" | base64 --decode; echo)
export SA_CA_CRT=$(kubectl get secret $SA_NAME -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)
export K8S_HOST=10.96.0.1:443

vault auth enable --path="k8s-master" kubernetes
vault write auth/k8s-master/config \
  token_reviewer_jwt="$SA_JWT_TOKEN" \
  kubernetes_host="https://$K8S_HOST" \
  kubernetes_ca_cert="$SA_CA_CRT"
vault write auth/k8s-master/role/dex \
  bound_service_account_names=dex \
  bound_service_account_namespaces=auth-system \
  policies=dexidp \
  ttl=1h


```

debugging commands
```
kubectl run tmp --rm -i --tty --serviceaccount=vault-auth --image alpine:3.7
KUBE_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
curl --insecure --request POST --data '{"jwt": "'"$KUBE_TOKEN"'", "role": "dex"}' https://vault.vault--prod.svc:8200/v1/auth/dexidp/login
curl --cacert /tmp/SA_CA_CRT -H "Authorization: Bearer $SA_JWT_TOKEN" https://10.96.0.1:443
```
