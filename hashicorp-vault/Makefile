NAMESPACE ?= vault--prod
HELM_BIN ?= helm
VAULT_ADDR=https://vault.slac.stanford.edu
NAMESPACE ?= vault--prod
DATE ?= $(shell date +%Y%m%d)

.PHONY: unseal unseal-0 unseal-1 unseal-2

define unseal
	kubectl exec -it vault-$(1) -- vault operator unseal -address=https://vault-$(1).slac.stanford.edu:8200
endef

define unseal-three
	$(call unseal,$(1))
	$(call unseal,$(1))
	$(call unseal,$(1))
endef

define delete-replica
	kubectl -n $(NAMESPACE) delete pod vault-$(1)
endef

define status
	kubectl -n $(NAMESPACE) exec --stdin=true --tty=true vault-$(1) -- vault status --tls-skip-verify
endef

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

unseal-0:
	$(call unseal-three,0)
delete-0:
	$(call delete-replica,0)
status-0:
	$(call status,0)
restart-0: delete-0 unseal-0

unseal-1:
	$(call unseal-threel,1)
delete-1:
	$(call delete-replica,1)
status-1:
	$(call status,1)

unseal-2:
	$(call unseal-three,2)
delete-2:
	$(call delete-replica,2)
status-2:
	$(call status,2)

raft-status:
	kubectl -n $(NAMESPACE) exec --stdin=true --tty=true vault-0 -- vault operator raft list-peers -address=https://vault-0.slac.stanford.edu:8200


# https://www.vaultproject.io/docs/platform/k8s/helm/examples/ha-with-raft
join1:
	kubectl -n $(NAMESPACE) exec -ti vault-1 -- sh -c "VAULT_ADDR=https://vault.slac.stanford.edu:8200 vault operator raft join http://vault-0.slac.stanford.edu:8200"

join2:
	kubectl -n $(NAMESPACE) exec -ti vault-2 -- sh -c "VAULT_ADDR=https://vault.slac.stanford.edu:8200 vault operator raft join http://vault-0.slac.stanford.edu:8200"

backup:
	vault operator raft snapshot save vault-backup.$(DATE)


destroy:
	kubectl -n $(NAMESPACE) delete ns $(NAMESPACE) -R

