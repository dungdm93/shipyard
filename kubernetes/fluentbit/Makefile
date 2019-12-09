RELEASE := tivan
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

	kubectl -n ${NAMESPACE} apply -f labelmap.yaml
	helm upgrade --install \
		${RELEASE} stable/fluent-bit \
		--namespace=${NAMESPACE} \
		--values=values.yaml

diff:
	kubectl -n ${NAMESPACE} diff -f labelmap.yaml
	helm diff upgrade --allow-unreleased \
		${RELEASE} stable/fluent-bit \
		--namespace=${NAMESPACE} \
		--values=values.yaml
