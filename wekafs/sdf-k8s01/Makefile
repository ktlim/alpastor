
SECRET_PATH ?= secret/tid/storage/weka/k8s01/sdf-k8s01 


helm:
	helm repo add csi-wekafs https://weka.github.io/csi-wekafs
	helm template csi-wekafs csi-wekafs/csi-wekafsplugin --namespace csi-wekafs --create-namespace > csi-wekafs.yaml

passwords:
	mkdir etc || true
	vault kv get --field=password -format=table $(SECRET_PATH) | tr -dc '[:print:]' > etc/password
	vault kv get --field=username -format=table $(SECRET_PATH) | tr -dc '[:print:]' > etc/username

remove-passwords:
	rm -rf etc

do:
	kubectl apply -k .

apply: passwords do remove-passwords
