
NS ?= local-path-storage


define helm
	helm template $(1) local-path-provisioner/deploy/chart/local-path-provisioner/ --namespace $(NS)  -f $(1)-values.yaml  -f values.yaml  > $(1)-helm.yaml 
endef


setup-helm:
	git clone https://github.com/rancher/local-path-provisioner.git || true

supercdms: setup-helm
	$(call helm,'sdf-group-supercdms')

cleanup-helm:
	rm -rf local-path-provisioner

update: supercdms

apply:
	kubectl apply -k .

