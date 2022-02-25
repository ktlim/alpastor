
SECRET_PATH ?= secret/dexidp/staticClients/k8s-master-login
COOKIE_SECRET_PATH ?= secret/tid/k8s

passwords:
	CLIENTID=k8s-master CLIENTSECRET=$(shell vault kv get --field=secret -format=json $(SECRET_PATH)) envsubst < etc/gangway.yaml > etc/.gangway.yaml
	vault kv get --field=gangway-session-key -format=table $(COOKIE_SECRET_PATH) > etc/.session-key

clean-passwords:
	rm etc/.gangway.yaml etc/.session-key

auth: passwords
	kubectl create ns auth-system || true
	kubectl apply -k .

apply: passwords auth clean-passwords



