
- edit the `env` file with relevant changes for your vcluster
- run `make make` to prepopulate the Makefile
- you will need to add ${API_NAME} as a dns alias for teh f5 endpoint lb01-sdf-k8s01 in netdb
- ensure you have a vault token with correct permissions to the secret defined in env
- add this information into dexidp, not forgetting the policy permissions. restart (make apply dexidp)
- run `make generate` to create all relevant yaml configurations
- run `make apply` to create the vcluster
