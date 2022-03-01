



update-crunchydata:
	cd crunchydata-operator/deps/postgres-operator
	git pull

apply-crunchydata:
	kubectl apply -k operator 

apply-crunchydata-db:
	kubectl apply -k .
	kubectl apply -f service.yaml

apply-crunchydata: apply-crunchydata apply-crunchydata-db


update-zalando:
	cd zalando
	git pull

apply-zalando:
	kubectl apply -k  zalando/postgres-operator
	 
