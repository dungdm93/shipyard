RELEASE := airflow
NAMESPACE := airflow
EXECUTOR := celery
ifneq (${EXECUTOR},)
	EXTRA_ARGS := --values=profiles/executor-${EXECUTOR}.yaml
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
		${RELEASE} stable/airflow \
		--namespace=${NAMESPACE} \
		--values=profiles/base.yaml ${EXTRA_ARGS}

diff:
	helm diff upgrade \
		${RELEASE} stable/airflow \
		--namespace=${NAMESPACE} \
		--values=profiles/base.yaml ${EXTRA_ARGS}
