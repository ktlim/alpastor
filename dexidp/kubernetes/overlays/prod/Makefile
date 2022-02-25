SECRET_PATH=secret/dexidp/connectors/slac-adfs

etc:
	mkdir -p etc

passwords: etc
	echo '' > etc/adfs.slac.stanford.edu.cert
	vault kv get --field=adfs.slac.stanford.edu.cert -format=table $(SECRET_PATH) | xargs -d '\n' -I{} echo -e {}  >> etc/adfs.slac.stanford.edu.cert

apply: passwords
	kubectl apply -k .
