HADOOP_VERSION ?= 3.2.1
HIVE_VERSION   ?= 3.1.2
IMAGE := hub.teko.vn/data/hive:${HIVE_VERSION}-hadoop-${HADOOP_VERSION}

build:
	docker build \
		--build-arg HADOOP_VERSION=${HADOOP_VERSION} \
		--build-arg HIVE_VERSION=${HIVE_VERSION} \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash
