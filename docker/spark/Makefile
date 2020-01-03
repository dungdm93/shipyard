IMAGE := hub.teko.vn/data/spark:2.4.4-hadoop-3.2.1

build:
	docker build --tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash
