
NS ?= local-path-storage


define helm
	helm template $(1) local-path-provisioner/deploy/chart/local-path-provisioner/ --namespace $(NS)  -f $(1)-values.yaml  -f values.yaml  > $(1)-helm.yaml 
endef


setup-helm:
	git clone https://github.com/rancher/local-path-provisioner.git || true

cleanup-helm:
	rm -rf local-path-provisioner

home: setup-helm
	$(call helm,'sdf-home')
	$(call helm, 'fs-ddn-sdf-home')

atlas: setup-helm
	$(call helm, 'sdf-group-atlas')
	$(call helm, 'fs-ddn-sdf-group-atlas')

supercdms: setup-helm
	$(call helm,'sdf-group-supercdms')
	$(call helm,'fs-ddn-sdf-group-supercdms')

ard: setup-helm
	$(call helm,'sdf-group-ard')
	$(call helm,'fs-ddn-sdf-group-ard')

rubin: setup-helm
	$(call helm,'sdf-group-rubin')
	$(call helm,'sdf-group-rubin-datasets')
	$(call helm,'sdf-group-rubin-scratch')
	$(call helm,'sdf-group-lsst')
	$(call helm,'fs-ddn-sdf-group-rubin')
	$(call helm,'fs-ddn-sdf-group-rubin-datasets')
	$(call helm,'fs-ddn-sdf-group-rubin-scratch')
	$(call helm,'fs-ddn-sdf-group-lsst')

cryoem-dev: setup-helm
	$(call helm,'sdf-group-cryoem-dev')
	$(call helm,'fs-ddn-sdf-group-cryoem-dev')

cryoem: setup-helm
	$(call helm,'sdf-group-cryoem')
	$(call helm,'sdf-group-cryoem-exp')
	$(call helm,'fs-ddn-sdf-group-cryoem')
	$(call helm,'fs-ddn-sdf-group-cryoem-exp')

update: home atlas supercdms ard rubin cryoem-dev cryoem

apply:
	kubectl apply -k .

