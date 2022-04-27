


helm:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	helm template sdf-k8s01 prometheus-community/prometheus > helm.yaml

apply:
	kubectl apply -k .
