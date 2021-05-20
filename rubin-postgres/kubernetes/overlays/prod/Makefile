SECRET_PATH=secret/rubin/rubin-postgres--prod/database

etc:
	mkdir etc

passwords: etc
	vault kv get --field=root-password $(SECRET_PATH) > etc/root-password
	vault kv get --field=primary-password $(SECRET_PATH) > etc/primary-password
	vault kv get --field=user-password $(SECRET_PATH) > etc/user-password

apply:
	kubectl apply -k .
