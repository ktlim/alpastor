SECRET_PATH=secret/grafana/dev
OIDC_PATH=secret/dexidp/staticClients/grafana-dev

etc:
	mkdir -p etc

passwords: etc
	vault kv get --field=admin-user -format=json $(SECRET_PATH) | sed 's:"::g' > etc/admin-user
	vault kv get --field=admin-password -format=json $(SECRET_PATH) | sed 's:"::g' > etc/admin-password
	vault kv get --field=secret -format=json $(OIDC_PATH) | sed 's:"::g' > etc/oidc-secret
	vault kv get --field=id -format=json $(OIDC_PATH) | sed 's:"::g' > etc/oidc-id

apply:
	kubectl apply -k .
