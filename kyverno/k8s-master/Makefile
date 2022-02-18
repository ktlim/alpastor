HELM ?= helm
NS ?= kyverno-system

helm:
	$(HELM) repo add kyverno https://kyverno.github.io/kyverno/
	$(HELM) repo update
	$(HELM) template kyverno kyverno/kyverno --namespace $(NS) --create-namespace > kyverno.yaml
	# $(HELM) template kyverno-policies kyverno/kyverno-policies --namespace $(NS) > kyverno-policies.yaml

apply:
	kubectl create ns $(NS) || true
	kubectl -n $(NS) apply -k .

destroy:
	kubectl -n $(NS) delete -k .
