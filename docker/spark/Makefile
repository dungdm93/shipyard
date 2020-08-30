IMAGE_REPO := hub.teko.vn/dataops/spark
SPARK_VERSION  ?= 3.0.0
HADOOP_VERSION ?= 3.2

BUILD_ARGS := --build-arg HADOOP_VERSION=${HADOOP_VERSION} \
			  --build-arg SPARK_VERSION=${SPARK_VERSION}
IMAGE_TAG  := ${SPARK_VERSION}
DOCKERFILE := ./Dockerfile

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
	$(MAKE) ${CMD}
	@echo =================================================
	$(MAKE) ${CMD} BINDING=python

build-all:
	$(MAKE) all CMD=build

push-all:
	$(MAKE) all CMD=push

publish-all:
	$(MAKE) all CMD=publish
