RELEASE := griffin
NAMESPACE := kube-observability

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
		${RELEASE} stable/grafana \
		--namespace=${NAMESPACE} \
		--values=values.yaml

diff:
	helm diff upgrade \
		${RELEASE} stable/grafana \
		--namespace=${NAMESPACE} \
		--values=values.yaml
