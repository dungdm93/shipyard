IMAGE := hub.teko.vn/samples/pod-info:v1

build:
	docker build \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} sh
