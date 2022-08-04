
NAMESPACE ?= vcluster--usdf-oga-dmz
SECRET_PATH ?= secret/rubin/usdf-oga-dmz/kubernetes
COOKIE_SECRET_PATH ?= secret/tid/k8s
KUBERNETES_DISTRO ?= k8s
VCLUSTER_CHART ?= v0.10.2

make:
	source ./env && envsubst < Makefile.tmpl > Makefile

generate: make
	source ./env && envsubst < kustomization.yaml.tmpl > kustomization.yaml 
	source ./env && envsubst < vcluster-values.yaml.tmpl > vcluster-values.yaml
	source ./env && CLIENTID=$(shell vault kv get --field=client-id -format=json $(SECRET_PATH)) CLIENTSECRET=$(shell vault kv get --field=client-secret -format=json $(SECRET_PATH)) envsubst < etc/gangway.yaml > etc/.gangway.yaml
	vault kv get --field=gangway-session-key -format=table $(COOKIE_SECRET_PATH) > etc/.session-key

clean-passwords:
	rm etc/.gangway.yaml etc/.session-key

auth:
	kubectl create ns $(NAMESPACE) || true
	kubectl apply -k .

vcluster:
	vcluster create $(NAMESPACE) -n $(NAMESPACE) --upgrade --connect=false --distro $(KUBERNETES_DISTRO) --chart-version $(VCLUSTER_CHART) -f vcluster-values.yaml

destroy:
	vcluster delete $(NAMESPACE) -n $(NAMESPACE) || true
	kubectl delete ns $(NAMESPACE)

rbac:
	vcluster connect $(NAMESPACE) -n $(NAMESPACE) --update-current=false -- kubectl apply -f workload/rbac.yaml

apply: generate auth vcluster clean-passwords rbac

dump: generate
	kubectl kustomize . | yh

