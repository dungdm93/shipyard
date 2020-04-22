RANGER_VERSION ?= 2.0.0
IMAGE_BUILDER := hub.teko.vn/data/ranger:${RANGER_VERSION}-cache
IMAGE_DIST    := hub.teko.vn/data/ranger:${RANGER_VERSION}-dist

build:
	-docker pull ${IMAGE_BUILDER}

	docker build --pull \
		--build-arg RANGER_VERSION=${RANGER_VERSION} \
		--target builder --tag ${IMAGE_BUILDER} .

	docker build --pull \
		--build-arg RANGER_VERSION=${RANGER_VERSION} \
		--target dist --tag ${IMAGE_DIST} .

push:
	docker push ${IMAGE_BUILDER}
	docker push ${IMAGE_DIST}

publish: build push

run:
	docker run -it --rm ${IMAGE_DIST} bash
