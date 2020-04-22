RANGER_VERSION ?= 2.0.0
IMAGE := hub.teko.vn/data/ranger:${RANGER_VERSION}

build:
	docker build --pull \
		--build-arg RANGER_VERSION=${RANGER_VERSION} \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash
