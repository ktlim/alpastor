



#helm:
#	helm repo add bitnami https://charts.bitnami.com/bitnami
#	helm template mongo bitnami/mongodb > mongo.yaml
#
mongo-operator-update:
	cd deps/mongo-operator/percona-server-mongodb-operator
	git pull

ns:
	kubectl create ns cryoem-logbook || true

mongo-operator: 
	helm repo add percona https://percona.github.io/percona-helm-charts/
	helm repo update
	helm template --version 1.11.0 mongodb-operator percona/psmdb-operator > mongo-operator.yaml

kafka-operator:
	curl -L https://strimzi.io/install/latest?namespace=kafka-operator -o kafka-operator.yaml


passwords:
	mkdir -p etc
	

apply: ns 
	kubectl apply -k .
