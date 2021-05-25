
deployment of postgres database for Rubin Butler service

Install

we currently just keep the root password in vault as a kv secret under

Initiate kv vault if not already enabled (with an admin role)

```
$ vault login -method=ldap
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

$ vault secrets enable -path=secret kv-v2
```

Make sure we have permissions on the vault

```
$ cat rubin.hcl
# List, create, update, and delete key/value secrets
path "secret/data/rubin/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}
$ vault policy write rubin ./rubin.hcl

```

Grant user access to rubin policies

```
vault write identity/group name="rubin" \
        policies="rubin" member_entity_ids=$(vault read identity/entity/name/ytl --format=json | jq .data.id | sed 's:"::g')
```
User may have to `vault login` again to ensure their `policies = ["admin" "default" "rubin"]`

Initiate passwords

```
$ vault kv put secret/rubin/rubin-postgres--prod/database root-password="$(openssl rand -base64 32)" primary-password="$(openssl rand -base64 32)" user-password="$(openssl rand -base64 32)"
```

for now, lets just make local files for the passwords, we will want to make use of vault database [https://learn.hashicorp.com/tutorials/vault/database-root-rotation] but for now, lets keep things simple.

```
$ kubernetes/overlays/prod
$ make passwords
```



Postgres

please see [https://access.crunchydata.com/documentation/crunchy-postgres-containers/4.6.2/container-specifications/crunchy-postgres/postgres/] for configuration options


