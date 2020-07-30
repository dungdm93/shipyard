IMAGE_REPO := hub.teko.vn/dataops/spark
SPARK_VERSION  ?= 3.0.0

ifeq (${STANDALONE}, yes)
	HADOOP_VERSION ?= 3.3.0
	IMAGE_TAG  := ${SPARK_VERSION}-hadoop-${HADOOP_VERSION}
	DOCKERFILE := ./Dockerfile.standalone
else
	HADOOP_VERSION ?= 3.2
	IMAGE_TAG  := ${SPARK_VERSION}
	DOCKERFILE := ./Dockerfile.bundled
endif
BUILD_ARGS := --build-arg HADOOP_VERSION=${HADOOP_VERSION} \
			 --build-arg SPARK_VERSION=${SPARK_VERSION}

ifeq (${BINDING}, python)
	PYTHON_VERSION ?= 3.8
	BUILD_ARGS := --build-arg PYTHON_VERSION=${PYTHON_VERSION} \
				 --build-arg BASE_IMAGE=${IMAGE_REPO}:${IMAGE_TAG}
	IMAGE_TAG  := ${IMAGE_TAG}-python-${PYTHON_VERSION}
	DOCKERFILE := ./python/Dockerfile
endif
IMAGE := ${IMAGE_REPO}:${IMAGE_TAG}

build:
	docker build ${BUILD_ARGS} \
		--file ${DOCKERFILE} \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash

all:
	$(MAKE) ${CMD} STANDALONE=no
	@echo =================================================
	$(MAKE) ${CMD} STANDALONE=yes
	@echo =================================================
	$(MAKE) ${CMD} STANDALONE=no  BINDING=python
	@echo =================================================
	$(MAKE) ${CMD} STANDALONE=yes BINDING=python

build-all:
	$(MAKE) all CMD=build

push-all:
	$(MAKE) all CMD=push

publish-all:
	$(MAKE) all CMD=publish
