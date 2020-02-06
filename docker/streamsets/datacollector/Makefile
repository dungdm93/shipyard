SDC_VERSION ?= 3.13.0
IMAGE := hub.teko.vn/data/streamsets/sdc:${SDC_VERSION}

build:
	docker build \
		--build-arg SDC_VERSION=${SDC_VERSION} \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm --entrypoint=bash ${IMAGE}
