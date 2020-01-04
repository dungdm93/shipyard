BASE_IMAGE ?= hub.teko.vn/data/spark:2.4.4-hadoop-3.2.1
IMAGE := ${BASE_IMAGE}-python-3.7

build:
	docker build \
		--build-arg BASE_IMAGE=${BASE_IMAGE} \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash
