IMAGE_REPO := hub.teko.vn/dataops/spark
SPARK_VERSION  ?= 3.0.0

ifeq (${BUNDLED}, yes)
	HADOOP_VERSION ?= 3.2
	IMAGE_TAG  := ${SPARK_VERSION}
	DOCKERFILE := ./Dockerfile.bundled
else
	HADOOP_VERSION ?= 3.3.0
	IMAGE_TAG  := ${SPARK_VERSION}-hadoop-${HADOOP_VERSION}
	DOCKERFILE := ./Dockerfile.separated
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
	$(MAKE) ${CMD} BUNDLED=no
	@echo =================================================
	$(MAKE) ${CMD} BUNDLED=yes
	@echo =================================================
	$(MAKE) ${CMD} BUNDLED=no  BINDING=python
	@echo =================================================
	$(MAKE) ${CMD} BUNDLED=yes BINDING=python

build-all:
	$(MAKE) all CMD=build

push-all:
	$(MAKE) all CMD=push

publish-all:
	$(MAKE) all CMD=publish
