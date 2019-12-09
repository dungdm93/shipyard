RELEASE := loki
NAMESPACE := kube-observability
PROFILE := local
ifneq (${PROFILE},)
	EXTRA_ARGS := --values=values/${PROFILE}.yaml
endif

repo:
	@if ! helm repo list | grep loki > /dev/null 2>&1; then \
		helm repo add loki https://grafana.github.io/loki/charts; \
		helm repo update; \
	fi;

apply:	repo
	@if ! kubectl get ns ${NAMESPACE} > /dev/null 2>&1; then \
		kubectl create ns ${NAMESPACE}; \
	fi;

	helm upgrade --install \
		${RELEASE} loki/loki \
		--namespace=${NAMESPACE} \
		--values=values/base.yaml ${EXTRA_ARGS}

diff:
	helm diff upgrade \
		${RELEASE} loki/loki \
		--namespace=${NAMESPACE} \
		--values=values/base.yaml ${EXTRA_ARGS}
