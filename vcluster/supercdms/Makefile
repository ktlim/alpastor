
NAME ?= vcluster--supercdms
SECRET_PATH ?= secret/supercdms/kubernetes
COOKIE_SECRET_PATH ?= secret/tid/k8s

passwords:
	CLIENTID=$(shell vault kv get --field=client-id -format=json $(SECRET_PATH)) CLIENTSECRET=$(shell vault kv get --field=client-secret -format=json $(SECRET_PATH)) envsubst < etc/gangway.yaml > etc/.gangway.yaml
	vault kv get --field=gangway-session-key -format=table $(COOKIE_SECRET_PATH) > etc/.session-key

clean-passwords:
	rm etc/.gangway.yaml etc/.session-key

vcluster:
	vcluster create $(NAME) -n $(NAME) --upgrade --distro k8s -f vcluster-values.yaml

auth: passwords
	kubectl create ns $(NAME) || true
	kubectl apply -k .

apply: passwords auth vcluster clean-passwords

destroy:
	vcluster delete $(NAME) -n $(NAME) || true
	kubectl delete ns $(NAME)

connect:
	vcluster connect $(NAME) -n $(NAME)


