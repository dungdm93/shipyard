HADOOP_VERSION ?= 3.2.1
SPARK_VERSION  ?= 2.4.4
IMAGE := hub.teko.vn/data/spark:${SPARK_VERSION}-hadoop-${HADOOP_VERSION}

build:
	docker build \
		--build-arg SPARK_VERSION=${SPARK_VERSION} \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash
