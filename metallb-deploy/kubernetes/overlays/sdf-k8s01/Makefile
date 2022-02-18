HELM ?= helm
NS ?= metallb-system
PROXY ?= http://squid.slac.stanford.edu:3128
METALLB_VERSION ?= v0.12.1

download:
	curl --proxy $(PROXY) https://raw.githubusercontent.com/metallb/metallb/$(METALLB_VERSION)/manifests/metallb.yaml > metallb.yaml
#secrets:
#	vault kv get -field=secretkey secret/tid/scs/k8s/sdf-k8s01/metallb > config/secretkey 
apply:
	kubectl -n $(NS) apply -k .

clean:
	kubectl -n $(NS) delete -k .
