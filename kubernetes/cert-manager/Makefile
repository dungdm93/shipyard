VERSION := v0.12.0
BASE_URL := https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests

repo:
	@if ! helm repo list | grep jetstack ; then \
		helm repo add jetstack https://charts.jetstack.io; \
		helm repo update; \
	fi;

apply:	repo
	# ignore validate unknown field "preserveUnknownFields" in old k8s
	kubectl apply --validate=false -f $(BASE_URL)/00-crds.yaml;
	kubectl apply -f $(BASE_URL)/01-namespace.yaml;

	helm upgrade --install \
		cert-manager jetstack/cert-manager \
		--namespace=cert-manager \
		--version=$(VERSION) \
		--values=values.yaml;

	kubectl apply -f letsencrypt.yaml;

diff:
	kubectl diff -f $(BASE_URL)/00-crds.yaml;
	kubectl diff -f $(BASE_URL)/01-namespace.yaml;

	helm diff upgrade \
		cert-manager jetstack/cert-manager \
		--namespace=cert-manager \
		--version=$(VERSION) \
		--values=values.yaml;

	kubectl diff -f letsencrypt.yaml;
