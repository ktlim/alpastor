



update-deps:
	cd operator/deps/postgres-operator
	git pull

apply-operator:
	kubectl apply -k operator 

apply-db:
	kubectl apply -k .
	kubectl apply -f service.yaml

apply: apply-operator apply-db
