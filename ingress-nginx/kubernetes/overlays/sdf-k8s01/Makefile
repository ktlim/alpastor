HELM ?= helm
INGRESS_NGINX_VERSION ?= 4.1.4
NS ?= ingress-nginx
CLUSTER_NAME ?= sdf-k8s01


helm:
	$(HELM) repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	$(HELM) repo update
	$(HELM) template $(CLUSTER_NAME) ingress-nginx/ingress-nginx --version $(INGRESS_NGINX_VERSION) --namespace $(NS) --set controller.hostNetwork=true,controller.kind=DaemonSet > helm.yaml

apply:
	kubectl -n $(NS) apply -k .

clean:
	kubectl -n $(NS) delete -k .

clear-webhook:
	kubectl delete -A ValidatingWebhookConfiguration $(CLUSTER_NAME)-ingress-nginx-admission
