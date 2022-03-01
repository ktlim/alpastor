



update-crunchydata:
	cd operator/deps/postgres-operator
	git pull

apply-crunchydata:
	kubectl apply -k operator 

apply-crunchydata-db:
	kubectl apply -k .
	kubectl apply -f service.yaml

apply-crunchydata: apply-crunchydata apply-crunchydata-db
