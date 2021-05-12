# List, create, update, and delete key/value secrets
path "secret/data/rubin/*"
{
  capabilities = ["create", "read", "update", "delete", "list"]
}

