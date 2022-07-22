
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

supercdms: setup-helm
	$(call helm,'sdf-group-supercdms')

ard: setup-helm
	$(call helm,'sdf-group-ard')

rubin: setup-helm
	$(call helm,'sdf-group-rubin')
	$(call helm,'sdf-group-rubin-datasets')
	$(call helm,'sdf-group-rubin-scratch')
	$(call helm,'sdf-group-lsst')

cryoem-dev: setup-helm
	$(call helm,'sdf-group-cryoem-dev')
	$(call helm,'sdf-group-cryoem-dev-redis')

cryoem: setup-helm
	$(call helm,'sdf-group-cryoem')

update: home supercdms ard rubin cryoem-dev cryoem

apply:
	kubectl apply -k .

