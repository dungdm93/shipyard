BASE_URL := https://github.com/coreos/prometheus-operator/raw/v0.34.0/example/prometheus-operator-crd
NAMESPACE := kube-observability

repo:
	@if ! helm repo list | grep stable > /dev/null 2>&1; then \
		helm repo add stable https://kubernetes-charts.storage.googleapis.com; \
		helm repo update; \
	fi;

crd:
	kubectl apply -f "${BASE_URL}/prometheus.crd.yaml"
	kubectl apply -f "${BASE_URL}/alertmanager.crd.yaml"
	kubectl apply -f "${BASE_URL}/servicemonitor.crd.yaml"
	kubectl apply -f "${BASE_URL}/podmonitor.crd.yaml"
	kubectl apply -f "${BASE_URL}/prometheusrule.crd.yaml"

apply:	repo crd
	@if ! kubectl get ns ${NAMESPACE} > /dev/null 2>&1; then \
		kubectl create ns ${NAMESPACE}; \
	fi;

	helm upgrade --install \
		argus stable/prometheus-operator \
		--namespace=${NAMESPACE} \
		--values=values.yaml

diff:
	helm diff upgrade \
		argus stable/prometheus-operator \
		--namespace=${NAMESPACE} \
		--values=values.yaml
