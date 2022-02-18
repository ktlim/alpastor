NAMESPACE ?= vault--prod
HELM_BIN ?= helm
VAULT_ADDR=https://vault.slac.stanford.edu
DATE ?= $(shell date +%Y%m%d)

unseal = \
  kubectl exec -it $(1) -- vault operator unseal -address=https:/$(1).slac.stanford.edu:8200

join = \

helm:
	$(HELM_BIN) repo add hashicorp https://helm.releases.hashicorp.com
	$(HELM_BIN) repo update
	$(HELM_BIN) template vault hashicorp/vault --namespace $(NAMESPACE) -f overrides.yaml > helm.yaml

keys:
	# generate keys into cert

apply:
	kubectl apply -k .

stdout:
	kubectl kustomize . 

# need to setup vault-{0,1,2}.slac.stanford.edu to point to pods

unseal0:
	kubectl exec --stdin=true --tty=true vault-0 -- vault operator unseal -address=https://vault-0.slac.stanford.edu:8200
	kubectl exec --stdin=true --tty=true vault-0 -- vault operator unseal -address=https://vault-0.slac.stanford.edu:8200
	kubectl exec --stdin=true --tty=true vault-0 -- vault operator unseal -address=https://vault-0.slac.stanford.edu:8200

status:
	kubectl exec --stdin=true --tty=true vault-0 -- vault status --tls-skip-verify

unseal1:
	kubectl exec --stdin=true --tty=true vault-1 -- vault operator unseal -address=https://vault-1.slac.stanford.edu:8200
	kubectl exec --stdin=true --tty=true vault-1 -- vault operator unseal -address=https://vault-1.slac.stanford.edu:8200
	kubectl exec --stdin=true --tty=true vault-1 -- vault operator unseal -address=https://vault-1.slac.stanford.edu:8200
#$(call unseal,vault-1)

unseal2:
	kubectl exec --stdin=true --tty=true vault-2 -- vault operator unseal -address=https://vault-2.slac.stanford.edu:8200
	kubectl exec --stdin=true --tty=true vault-2 -- vault operator unseal -address=https://vault-2.slac.stanford.edu:8200
	kubectl exec --stdin=true --tty=true vault-2 -- vault operator unseal -address=https://vault-2.slac.stanford.edu:8200


# https://www.vaultproject.io/docs/platform/k8s/helm/examples/ha-with-raft
join1:
	kubectl exec -ti vault-1 -- sh -c "VAULT_ADDR=https://vault.slac.stanford.edu:8200 vault operator raft join http://vault-0.slac.stanford.edu:8200"

join2:
	kubectl exec -ti vault-2 -- sh -c "VAULT_ADDR=https://vault.slac.stanford.edu:8200 vault operator raft join http://vault-0.slac.stanford.edu:8200"

backup:
	vault operator raft snapshot save vault-backup.$(DATE)


clean:
	kubectl -n $(NAMESPACE) delete ns $(NAMESPACE) -R

