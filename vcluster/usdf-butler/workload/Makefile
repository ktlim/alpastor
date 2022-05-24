


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
	kubectl apply -f service.yaml

pgbouncer:
	docker build . -f Dockerfile.pgbouncer -t slaclab/pgbouncer:master-22
	docker push slaclab/pgbouncer:master-22

