RELEASE ?= foobar
VALUES  ?= ./values/default.yaml

dep:
	@if [ ! -d "./charts" ]; then \
		helm dependency update;  \
	fi

gen: dep
	@mkdir -p out;
	@rm   -rf out/*;
	helm template ${RELEASE} . --values=${VALUES} --output-dir=out/;

clean:
	rm -rf out charts
