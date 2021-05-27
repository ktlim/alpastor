HELM ?= helm
NS ?= metallb-system

secrets:
	vault kv get -field=secretkey secret/k8s-master/metallb > config/secretkey 
apply:
	kubectl -n $(NS) apply -k .

clean:
	kubectl -n $(NS) delete -k .
