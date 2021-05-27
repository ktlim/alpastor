HELM ?= ../../helm
NS ?= ingress-nginx

helm:
	$(HELM) repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	$(HELM) repo update
	#$(HELM) template "k8s-master" nginx-stable/nginx-ingress --set controller.hostNetwork=true,controller.service.type="",controller.kind=DaemonSet > helm.yaml
	$(HELM) template k8s-master ingress-nginx/ingress-nginx --set controller.hostNetwork=true,controller.kind=DaemonSet > helm.yaml

apply:
	kubectl -n $(NS) apply -k .

clean:
	kubectl -n $(NS) delete -k .
