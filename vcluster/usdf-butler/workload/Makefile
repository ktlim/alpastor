



update-crunchydata:
	cd crunchydata-operator/deps/postgres-operator
	git pull

apply-crunchydata-operator:
	kubectl apply -k operator 

apply-crunchydata-db:
	kubectl apply -f namespace.yaml 
	kubectl apply -f service.yaml -f crunchydata-postgres.yaml

apply-crunchydata: apply-crunchydata-operator apply-crunchydata-db


update-zalando:
	cd zalando
	git pull

apply-zalando-operator:
	kubectl apply -k  zalando-operator/

apply-zalando-db:
	#kubectl create ns postgres || true
	#kubectl apply -f huge-pages-fix.yaml -f zalando-postgres.yaml
	kubectl apply -k .

apply-zalando: apply-zalando-operator apply-zalando-db
	 
apply: apply-zalando


