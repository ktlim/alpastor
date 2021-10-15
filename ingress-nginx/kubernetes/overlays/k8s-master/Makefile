HELM ?= helm
INGRESS_NGINX_VERSION ?= 3.34.0
NS ?= ingress-nginx
CLUSTER_NAME ?= k8s-master


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
