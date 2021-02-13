SUPERSET_VERSION ?= 1.0
IMAGE := hub.teko.vn/dataops/superset:${SUPERSET_VERSION}

build:
	docker build --pull \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash
