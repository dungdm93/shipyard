ENVIRONMENT := gcp
ifneq ($(ENVIRONMENT),)
	EXTRA_ARGS := "--values=values/$(ENVIRONMENT).yaml"
endif

repo:
	@if ! helm repo list | grep stable > /dev/null 2>&1; then \
		helm repo add stable https://kubernetes-charts.storage.googleapis.com; \
		helm repo update; \
	fi;

apply:	repo
	@if ! kubectl get ns nginx-ingress > /dev/null 2>&1; then \
		kubectl create ns nginx-ingress; \
	fi;

	helm upgrade --install \
		tinker stable/nginx-ingress \
		--namespace=nginx-ingress \
		--values=values/cloud-generic.yaml $(EXTRA_ARGS)

diff:
	helm diff upgrade \
		tinker stable/nginx-ingress \
		--namespace=nginx-ingress \
		--values=values/cloud-generic.yaml $(EXTRA_ARGS)
