RELEASE := argus
NAMESPACE := kube-observability
BASE_URL := https://github.com/coreos/prometheus-operator/raw/v0.36.0/example/prometheus-operator-crd

repo:
	@if ! helm repo list | grep stable > /dev/null 2>&1; then \
		helm repo add stable https://kubernetes-charts.storage.googleapis.com; \
		helm repo update; \
	fi;

crd:
	kubectl apply -f "${BASE_URL}/monitoring.coreos.com_prometheuses.yaml"
	kubectl apply -f "${BASE_URL}/monitoring.coreos.com_alertmanagers.yaml"
	kubectl apply -f "${BASE_URL}/monitoring.coreos.com_servicemonitors.yaml"
	kubectl apply -f "${BASE_URL}/monitoring.coreos.com_podmonitors.yaml"
	kubectl apply -f "${BASE_URL}/monitoring.coreos.com_prometheusrules.yaml"
	kubectl apply -f "${BASE_URL}/monitoring.coreos.com_thanosrulers.yaml"

apply:	repo crd
	@if ! kubectl get ns ${NAMESPACE} > /dev/null 2>&1; then \
		kubectl create ns ${NAMESPACE}; \
	fi;

	helm upgrade --install \
		${RELEASE} stable/prometheus-operator \
		--namespace=${NAMESPACE} \
		--values=values.yaml

diff:
	helm diff upgrade \
		${RELEASE} stable/prometheus-operator \
		--namespace=${NAMESPACE} \
		--values=values.yaml
