Dex authentication service manifests. Used primarily as OIDC frontend for SLAC's SAML2 services. Legacy unix and ad ldap sign in also provided.

All credentials are securely saved in the production instance of vault and requires that 

- the kubernetes cluster is registered with vault

```
export K8S_CLUSTER=k8s-api01
export K8S_HOST=k8s-api01.slac.stanford.edu:16443
export KUBECONFIG=~/.kube/contexts/vault--prod@slac

export SA_NAME=$(kubectl get sa vault-auth -o jsonpath="{.secrets[*]['name']}")
export SA_JWT_TOKEN=$(kubectl get secret $SA_NAME -o jsonpath="{.data.token}" | base64 --decode; echo)
export SA_CA_CRT=$(kubectl get secret $SA_NAME -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)

vault auth enable --path="$K8S_CLUSTER" kubernetes
vault write auth/$K8S_CLUSTER/config \
  token_reviewer_jwt="$SA_JWT_TOKEN" \
  kubernetes_host="https://$K8S_HOST" \
  kubernetes_ca_cert="$SA_CA_CRT"
````

as well as the `dex` service account such that it is tied to an appropriate vault policy

```
vault write auth/$K8S_CLUSTER/role/dex \
  bound_service_account_names=dex \
  bound_service_account_namespaces=auth-system \
  policies=dexidp \
  ttl=1h
```

specifically, the `dex-config.yaml` contains vault injector references to numerous vault kv secrets at `/secret/dexidp/*` with an example policy such as 

```
path "secret/data/dexidp/*"
{
  capabilities = ["read", "list"]
}
```

it is recommended that each dex client be registered under its own kv secret and that vault secret is shared with the app via an vault agent injector too.


It was chosen to utilise a self defined initContainer rather than annotations to support vault secret injection as this enables a cleaner separatation of configmaps that can be tracked with kustomize. However, one still has to be aware of changes in the vault secrets and re-apply dex manually in order to affect any changes.


