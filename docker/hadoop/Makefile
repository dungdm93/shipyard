HADOOP_VERSION ?= 3.3.0
IMAGE := hub.teko.vn/dataops/hadoop:${HADOOP_VERSION}

build:
	docker build --pull \
		--build-arg HADOOP_VERSION=${HADOOP_VERSION} \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash
