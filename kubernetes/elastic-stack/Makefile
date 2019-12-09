NAMESPACE := default

apply:
	@if ! kubectl get ns ${NAMESPACE} > /dev/null 2>&1; then \
		kubectl create ns ${NAMESPACE}; \
	fi;

	kubectl apply -f https://download.elastic.co/downloads/eck/1.0.0-beta1/all-in-one.yaml; \
	kubectl -n ${NAMESPACE} apply -f ./elasticsearch.yaml;
	kubectl -n ${NAMESPACE} apply -f ./kibana.yaml;

diff:
	kubectl diff -f https://download.elastic.co/downloads/eck/1.0.0-beta1/all-in-one.yaml;
	kubectl -n ${NAMESPACE} diff -f ./elasticsearch.yaml;
	kubectl -n ${NAMESPACE} diff -f ./kibana.yaml;
