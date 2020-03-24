RELEASE   ?= foobar
NAMESPACE ?= default
VALUES    ?= ./examples/gs.yaml

dep:
	helm dependency update;

gen:
	@mkdir -p ./build;
	@rm   -rf ./build/*;
	helm template ${RELEASE} . \
		--namespace=${NAMESPACE} \
		--values=${VALUES} \
		--output-dir=build;

clean:
	rm -rf ./build

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
