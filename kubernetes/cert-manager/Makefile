RELEASE := cert-manager
NAMESPACE := cert-manager
VERSION := v0.12.0
BASE_URL := https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests

repo:
	@if ! helm repo list | grep jetstack ; then \
		helm repo add jetstack https://charts.jetstack.io; \
		helm repo update; \
	fi;

crd:
	# ignore validate unknown field "preserveUnknownFields" in old k8s
	kubectl apply --validate=false -f $(BASE_URL)/00-crds.yaml;

apply:	repo crd
	kubectl apply -f ${BASE_URL}/01-namespace.yaml;

	helm upgrade --install \
		${RELEASE} jetstack/cert-manager \
		--namespace=${NAMESPACE} \
		--version=${VERSION} \
		--values=values.yaml;

	kubectl apply -f letsencrypt.yaml;

diff:
	kubectl diff -f ${BASE_URL}/00-crds.yaml;
	kubectl diff -f ${BASE_URL}/01-namespace.yaml;

	helm diff upgrade \
		${RELEASE} jetstack/cert-manager \
		--namespace=${NAMESPACE} \
		--version=${VERSION} \
		--values=values.yaml;

	kubectl diff -f letsencrypt.yaml;
