# use https://www.vaultproject.io/docs/platform/k8s/helm/examples/standalone-tls for raft cerst
CSR_NAME ?= raft.vault--prod

csr:
	openssl genrsa -out raft.key 2048
	openssl req -new -key raft.key -subj "/CN=vault.vault--prod.svc" -out raft.csr -config csr.conf

sign:
	kubectl delete certificatesigningrequest.certificates.k8s.io raft.vault--prod
	REQUEST=$(shell cat raft.csr | base64 | tr -d '\n') envsubst < csr.yaml | kubectl create -f -
	kubectl certificate approve $(CSR_NAME)
	kubectl get csr $(CSR_NAME) -o jsonpath='{.status.certificate}' | openssl base64 -d -A -out raft.crt
	kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 -d > raft.ca
	

