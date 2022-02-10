
NAME ?= vcluster--ard
SECRET_PATH ?= secret/ard/kubernetes

apply:
	vcluster create $(NAME) -n $(NAME) --upgrade --distro k8s -f vcluster-values.yaml
	CLIENTID=$(shell vault kv get --field=client-id -format=json $(SECRET_PATH)) CLIENTSECRET=$(shell vault kv get --field=client-secret -format=json $(SECRET_PATH)) envsubst < etc/gangway.yaml > etc/.gangway.yaml
	vault kv get --field=session-key -format=table $(SECRET_PATH) > etc/.session-key
	kubectl apply -k .
	rm etc/.gangway.yaml etc/.session-key

destroy:
	vcluster delete $(NAME) || true
	kubectl delete ns $(NAME)

connect:
	vcluster connect $(NAME) -n $(NAME)


