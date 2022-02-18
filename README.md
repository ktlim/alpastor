# alpastor
SLAC kubernetes manifests

## Typical process for standing up a new k8s cluster

- install via kubeadm
- install ingress-nginx
- install metallb
- install gangway
- add auth via dex and kube-api/kubeadm
- install vcluster per project
