RELEASE := jove
NAMESPACE := jupyter
VERSION := 0.8.2

repo:
	@if ! helm repo list | grep jupyterhub > /dev/null 2>&1; then \
		helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/; \
		helm repo update; \
	fi;

apply:	repo
	@if ! kubectl get ns ${NAMESPACE} > /dev/null 2>&1; then \
		kubectl create ns ${NAMESPACE}; \
	fi;

	kubectl apply --namespace=${NAMESPACE} \
		-f spark-sa.yaml \
		-f spark-conf.yaml

	helm upgrade --install \
		${RELEASE} jupyterhub/jupyterhub \
		--namespace=${NAMESPACE} \
		--version=${VERSION} \
		--values=values.yaml

diff:
	kubectl diff --namespace=${NAMESPACE} \
		-f spark-sa.yaml \
		-f spark-conf.yaml

	helm diff upgrade \
		${RELEASE} jupyterhub/jupyterhub \
		--namespace=${NAMESPACE} \
		--version=${VERSION} \
		--values=values.yaml
