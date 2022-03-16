SECRET_PATH=secret/dexidp/staticClients/vouch

etc:
	mkdir -p etc/.secrets/

passwords: etc
	vault kv get --field=secret -format=table $(SECRET_PATH) | tr -dc '[:print:]' > etc/.secrets/oidc-secret

apply:
	kubectl apply -k .
