
NAME ?= vcluster--lcls-data-ana
SECRET_PATH ?= secret/lcls/lcls-data-ana/kubernetes
COOKIE_SECRET_PATH ?= secret/tid/k8s
KUBERNETES_DISTRO ?= k8s
VCLUSTER_CHART ?= v0.6.0

passwords:
	CLIENTID=$(shell vault kv get --field=client-id -format=json $(SECRET_PATH)) CLIENTSECRET=$(shell vault kv get --field=client-secret -format=json $(SECRET_PATH)) envsubst < etc/gangway.yaml > etc/.gangway.yaml
	vault kv get --field=gangway-session-key -format=table $(COOKIE_SECRET_PATH) > etc/.session-key

clean-passwords:
	rm etc/.gangway.yaml etc/.session-key

vcluster:
	vcluster create $(NAME) -n $(NAME) --upgrade --distro $(KUBERNETES_DISTRO) --chart-version $(VCLUSTER_CHART) -f vcluster-values.yaml

auth: passwords
	kubectl create ns $(NAME) || true
	kubectl apply -k .

apply: passwords auth vcluster clean-passwords

destroy:
	vcluster delete $(NAME) -n $(NAME) || true
	kubectl delete ns $(NAME)

rbac:
	vcluster connect $(NAME) -n $(NAME) -- kubectl apply -f workload/rbac.yaml


