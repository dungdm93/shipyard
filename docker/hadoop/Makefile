HADOOP_VERSION ?= 3.2.1
IMAGE := hub.teko.vn/data/hadoop:${HADOOP_VERSION}

build:
	docker build --pull \
		--build-arg HADOOP_VERSION=${HADOOP_VERSION} \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash
