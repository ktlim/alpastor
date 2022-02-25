PROXY ?= http://squid.slac.stanford.edu:3128


calico-download:
	curl --proxy $(PROXY) https://projectcalico.docs.tigera.io/manifests/tigera-operator.yaml -O
	curl --proxy $(PROXY) https://projectcalico.docs.tigera.io/manifests/custom-resources.yaml -O

calico: calico-download
	kubectl apply -f tigera-operator.yaml -f custom-resources.yaml

multus-download:
	curl --proxy $(PROXY) https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/master/deployments/multus-daemonset-thick-plugin.yml -O

multus: calico-install multus-download
	kubectl apply -f multus-daemonset-thick-plugin.yml


