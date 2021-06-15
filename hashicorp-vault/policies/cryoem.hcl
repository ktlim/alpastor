# List, create, update, and delete key/value secrets
path "secret/data/cryoem/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

