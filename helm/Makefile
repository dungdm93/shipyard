RELEASE   ?= foobar
NAMESPACE ?= default
VALUES    ?= ./values/sample.yaml

dep:
	helm dependency update;

gen:
	@mkdir -p ./out;
	@rm   -rf ./out/*;
	helm template ${RELEASE} . \
		--namespace=${NAMESPACE} \
		--values=${VALUES} \
		--output-dir=out/;

clean:
	rm -rf ./out

diff:
	helm diff upgrade ${RELEASE} . \
		--namespace=${NAMESPACE} \
		--values=${VALUES} \
		--allow-unreleased

apply:
	helm upgrade --install ${RELEASE} . \
		--namespace=${NAMESPACE} \
		--values=${VALUES}

show:
	kubectl --namespace=${NAMESPACE} get pod \
		-l app.kubernetes.io/instance=${RELEASE}

destroy:
	helm uninstall ${RELEASE} --namespace=${NAMESPACE}

push:
	# TODO: BasicAuth https://github.com/chartmuseum/helm-push#basic-auth
	helm push . teko
