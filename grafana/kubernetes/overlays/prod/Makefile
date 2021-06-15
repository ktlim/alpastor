SECRET_PATH=secret/grafana/prod

etc:
	mkdir -p etc

passwords: etc
	vault kv get --field=admin-user-encoded -format=json $(SECRET_PATH) > etc/admin-user
	vault kv get --field=admin-password-encoded -format=json $(SECRET_PATH) > etc/admin-password

apply:
	kubectl apply -k .
