WALG_VERSION ?= v0.2.15
IMAGE := hub.teko.vn/tools/backups:wal-g

build:
	docker build --pull \
		--build-arg WALG_VERSION=${WALG_VERSION} \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash
