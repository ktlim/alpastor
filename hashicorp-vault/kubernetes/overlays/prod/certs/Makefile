SECRET_PATH=secret/tid/vault/certs

csr:
	openssl req -new -key vault--prod.key -out vault--prod.csr -config csr.config

download:
	vault kv get --field=vault--prod.key -format=table $(SECRET_PATH) > vault--prod.key
	vault kv get --field=vault--prod.crt -format=table $(SECRET_PATH) > vault--prod.crt
	vault kv get --field=vault--prod.csr -format=table $(SECRET_PATH) > vault--prod.csr
	vault kv get --field=vault--prod.ca -format=table $(SECRET_PATH) > vault--prod.ca

