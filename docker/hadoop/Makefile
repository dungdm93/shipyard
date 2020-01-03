IMAGE := hub.teko.vn/data/hadoop:3.2.1

build:
	docker build --pull --tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash
