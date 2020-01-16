SPARK_VERSION  ?= 2.4.4

ifdef STANDALONE
	HADOOP_VERSION ?= 3.2.1
	IMAGE := hub.teko.vn/data/spark:${SPARK_VERSION}-hadoop-${HADOOP_VERSION}
	DOCKERFILE = ./Dockerfile.standalone
else
	HADOOP_VERSION ?= 2.7
	IMAGE := hub.teko.vn/data/spark:${SPARK_VERSION}
	DOCKERFILE = ./Dockerfile.bundled
endif

build:
	docker build \
		--build-arg HADOOP_VERSION=${HADOOP_VERSION} \
		--build-arg SPARK_VERSION=${SPARK_VERSION} \
		--file ${DOCKERFILE} \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash


# make build STANDALONE=true
# make build
