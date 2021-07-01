# List, create, update, and delete key/value secrets
path "secret/data/dexidp/*"
{
  capabilities = ["read", "list"]
}

