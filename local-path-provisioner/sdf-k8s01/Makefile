DIRECTORIES ?= $(shell ls -d */ | grep -v local-path-provisioner)
NS ?= local-path-storage


define helm
	helm template $(1) local-path-provisioner/deploy/chart/local-path-provisioner/ --namespace $(NS)  -f $(2)/$(1)-values.yaml  -f values.yaml  > $(2)/$(1)-helm.yaml 
endef

define iterate
	$(foreach file, $(wildcard $(1)/*-values.yaml), $(call helm,$(shell echo $(file) | sed 's:.*/::' | sed 's:-values.yaml::'),$@);)
endef

setup-helm:
	git clone https://github.com/rancher/local-path-provisioner.git || true

cleanup-helm:
	rm -rf local-path-provisioner

#atlas: setup-helm
#	$(call helm, 'sdf-group-atlas')
#	$(call helm, 'fs-ddn-sdf-group-atlas')

#supercdms: setup-helm
#	$(call helm,'sdf-group-supercdms')
#	$(call helm,'fs-ddn-sdf-group-supercdms')

#ard: setup-helm
#	$(call helm,'sdf-group-ard')
#	$(call helm,'fs-ddn-sdf-group-ard')

#rubin: setup-helm
#	$(call helm,'sdf-group-rubin')
#	$(call helm,'sdf-data-rubin')
#	$(call helm,'sdf-group-lsst')
#	$(call helm,'fs-ddn-sdf-group-rubin')
#	$(call helm,'fs-ddn-sdf-group-lsst')
*: FORCE
	$(call iterate,$@)

dirs:
	@echo $(DIRECTORIES)

#cryoem-dev: setup-helm
#	$(call helm,'sdf-group-cryoem-dev')
#	$(call helm,'fs-ddn-sdf-group-cryoem-dev')

#cryoem: setup-helm
#	$(call helm,'sdf-group-cryoem')
#	$(call helm,'sdf-group-cryoem-exp')
#	$(call helm,'fs-ddn-sdf-group-cryoem')
#	$(call helm,'fs-ddn-sdf-group-cryoem-exp')

FORCE: ;

update: $(DIRECTORIES)

dump:
	kubectl kustomize .

apply:
	kubectl apply -k .

