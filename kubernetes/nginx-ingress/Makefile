RELEASE := tinker
NAMESPACE := nginx-ingress
ENVIRONMENT := gcp
ifneq (${ENVIRONMENT},)
	EXTRA_ARGS := --values=values/${ENVIRONMENT}.yaml
endif

repo:
	@if ! helm repo list | grep stable > /dev/null 2>&1; then \
		helm repo add stable https://kubernetes-charts.storage.googleapis.com; \
		helm repo update; \
	fi;

apply:	repo
	@if ! kubectl get ns ${NAMESPACE} > /dev/null 2>&1; then \
		kubectl create ns ${NAMESPACE}; \
	fi;

	helm upgrade --install \
		${RELEASE} stable/nginx-ingress \
		--namespace=${NAMESPACE} \
		--values=values/cloud-generic.yaml ${EXTRA_ARGS}

diff:
	helm diff upgrade \
		${RELEASE} stable/nginx-ingress \
		--namespace=${NAMESPACE} \
		--values=values/cloud-generic.yaml ${EXTRA_ARGS}
