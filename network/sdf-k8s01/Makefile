PROXY ?= http://squid.slac.stanford.edu:3128


calico-download:
	curl --proxy $(PROXY) https://docs.projectcalico.org/manifests/calico.yaml -O

calico-install: calico-download
	kubectl apply -f calico.yaml

multus-download:
	curl --proxy $(PROXY) https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/master/deployments/multus-daemonset-thick-plugin.yml -O

multus-install: calico-install multus-download
	kubectl apply -f multus-daemonset-thick-plugin.yml


