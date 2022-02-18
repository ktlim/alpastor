SECRET_PATH=secret/dexidp/staticClients/vouch-dev

etc:
	mkdir -p etc

passwords: etc
	vault kv get --field=secret -format=table $(SECRET_PATH) | tr -dc '[:print:]' > etc/oidc-secret

apply:
	kubectl apply -k .
