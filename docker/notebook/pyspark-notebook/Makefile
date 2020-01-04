HADOOP_VERSION ?= 3.2.1
SPARK_VERSION  ?= 2.4.4
PYSPARK_SOURCE_IMAGE := hub.teko.vn/data/spark:${SPARK_VERSION}-hadoop-${HADOOP_VERSION}
IMAGE := hub.teko.vn/data/pyspark-notebook:${SPARK_VERSION}-hadoop-${HADOOP_VERSION}

build:
	docker build --pull \
		--build-arg PYSPARK_SOURCE_IMAGE=${PYSPARK_SOURCE_IMAGE} \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm --user=root \
		-p 8888:8888 \
		-e GRANT_SUDO=yes \
		-e JUPYTER_ENABLE_LAB=yes \
		${IMAGE}
