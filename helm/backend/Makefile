RELEASE ?= foobar
VALUES  ?= ./values/sample.yaml

dep:
	@if [ ! -d "./charts" ]; then \
		helm dependency update;  \
	fi

gen: dep
	@mkdir -p out;
	@rm   -rf out/*;
	helm template ${RELEASE} . --values=${VALUES} --output-dir=out/;

push:
	# TODO: BasicAuth https://github.com/chartmuseum/helm-push#basic-auth
	helm push . teko

clean:
	rm -rf out charts
