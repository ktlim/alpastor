SECRET_PATH ?= secret/cryoem/cryoem-logbook
MONGO_OPERATOR_VERSION ?= 1.11.0


#helm:
#	helm repo add bitnami https://charts.bitnami.com/bitnami
#	helm template mongo bitnami/mongodb > mongo.yaml
#
mongo-operator-update:
	cd deps/mongo-operator/percona-server-mongodb-operator
	git pull

mongo-operator: 
	helm repo add percona https://percona.github.io/percona-helm-charts/
	helm repo update
	helm template --version $(MONGO_OPERATOR_VERSION) mongodb-operator percona/psmdb-operator > mongo-operator.yaml

kafka-operator:
	curl -L https://strimzi.io/install/latest?namespace=kafka-operator -o kafka-operator.yaml

get-secrets-from-vault:
	mkdir -p etc/.secrets/
	set -e; for i in MONGODB_BACKUP_PASSWORD  MONGODB_CLUSTER_ADMIN_PASSWORD  MONGODB_CLUSTER_MONITOR_PASSWORD  MONGODB_USER_ADMIN_PASSWORD	PMM_SERVER_PASSWORD  S3_ACCESS_KEY  S3_SECRET_KEY; do vault kv get --field=$$i $(SECRET_PATH) > etc/.secrets/$$i ; done

clean-secrets:
	rm -f etc/.secrets/

run-apply: 
	kubectl apply -k .

apply: get-secrets-from-vault run-apply clean-secrets

