SECRET_PATH=secret/dexidp/staticClients/grafana-prod

etc:
	mkdir -p etc/.secrets/

passwords: etc
	vault kv get --field=admin-user-encoded $(SECRET_PATH) > etc/.secrets/admin-user
	vault kv get --field=admin-password-encoded $(SECRET_PATH) > etc/.secrets/admin-password
	vault kv get --field=id $(SECRET_PATH) > etc/.secrets/oidc-id
	vault kv get --field=secret $(SECRET_PATH) > etc/.secrets/oidc-secret

clean-passwords:
	rm -rf etc/.secrets

apply:
	kubectl apply -k .
