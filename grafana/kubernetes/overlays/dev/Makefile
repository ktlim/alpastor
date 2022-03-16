SECRET_PATH=secret/grafana/dev
OIDC_PATH=secret/dexidp/staticClients/grafana-dev

etc:
	mkdir -p etc/.secrets/

passwords: etc
	vault kv get --field=admin-user -format=json $(SECRET_PATH) | sed 's:"::g' > etc/.secrets/admin-user
	vault kv get --field=admin-password -format=json $(SECRET_PATH) | sed 's:"::g' > etc/.secrets/admin-password
	vault kv get --field=secret -format=json $(OIDC_PATH) | sed 's:"::g' > etc/.secrets/oidc-secret
	vault kv get --field=id -format=json $(OIDC_PATH) | sed 's:"::g' > etc/.secrets/oidc-id

apply:
	kubectl apply -k .
