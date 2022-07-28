
SECRET_PATH ?= secret/tid/storage/weka/k8s01/monitoring

passwords:
	vault kv get --field=auth-token.json -format=table $(SECRET_PATH) > etc/.auth-token.json

clean-passwords:
	rm etc/.auth-token.json

monitoring:
	kubectl apply -k . 

apply: passwords monitoring clean-passwords 
