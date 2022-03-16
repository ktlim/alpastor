RELEASE ?= prod
VERSION ?= 1.6.3

#helm:
#	helm repo add zalando https://opensource.zalando.com/postgres-operator/charts/postgres-operator/
#	helm repo update
#	helm template zalando/postgres-operator --name-template=$(RELEASE) > helm.yaml

git:
	cd postgres-operator
	git pull

apply:
	kubectl create ns postgres-operator || true
	kubectl apply -k .
