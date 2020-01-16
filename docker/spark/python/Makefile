PYTHON_VERSION ?= 3.7

IMAGE_REPO ?= hub.teko.vn/data/spark

BASE_TAG   ?= 2.4.4-hadoop-3.2.1
BASE_IMAGE := ${IMAGE_REPO}:${BASE_TAG}

TARGET_TAG   ?= ${BASE_TAG}-python-${PYTHON_VERSION}
TARGET_IMAGE := ${IMAGE_REPO}:${TARGET_TAG}

build:
	docker build \
		--build-arg PYTHON_VERSION=${PYTHON_VERSION} \
		--build-arg BASE_IMAGE=${BASE_IMAGE} \
		--tag ${TARGET_IMAGE} .

push:
	docker push ${TARGET_IMAGE}

publish: build push

run:
	docker run -it --rm ${TARGET_IMAGE} bash
