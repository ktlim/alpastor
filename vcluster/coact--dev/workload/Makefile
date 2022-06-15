NAMESPACE ?= coact
MONGO_OPERATOR_VERSION ?= 1.11.0
ns:
	kubectl create ns $(NAMESPACE) || true

# hmm... upgrades manual?? https://www.percona.com/doc/kubernetes-operator-for-psmongodb/update.html
mongo-operator: 
	helm repo add percona https://percona.github.io/percona-helm-charts/
	helm repo update
	curl -L https://raw.githubusercontent.com/percona/percona-server-mongodb-operator/v$(MONGO_OPERATOR_VERSION)/deploy/crd.yaml > mongo-operator-crds.yaml
	curl -L https://raw.githubusercontent.com/percona/percona-server-mongodb-operator/v$(MONGO_OPERATOR_VERSION)/deploy/rbac.yaml > mongo-operator-rbac.yaml 
	helm template --version $(MONGO_OPERATOR_VERSION) mongodb-operator percona/psmdb-operator > mongo-operator.yaml

kustomize:
	kubectl apply -k .

apply: mongo-operator ns kustomize
