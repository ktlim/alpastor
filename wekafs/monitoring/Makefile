FS_NAME ?= new_fs

get-vault-secrets:
	mkdir etc/.secrets -p
	vault kv get --field=auth-token.json -format=table secret/tid/storage/weka/k8s01/monitoring > etc/.secrets/auth-token.json.k8s01
	vault kv get --field=auth-token.json -format=table secret/tid/storage/weka/sdfhome/monitoring > etc/.secrets/auth-token.json.sdfhome

clean-passwords:
	rm -rf etc/.secrets

run-apply:
	kubectl apply -k . 

# generate a new set of manifests for a file system
# must til create the cm and secrets
template:
	FS_NAME=$(FS_NAME) envsubst < template.yaml > $(FS_NAME).yaml

dump:
	kubectl kustomize . | yh

apply: get-vault-secrets run-apply clean-passwords 
