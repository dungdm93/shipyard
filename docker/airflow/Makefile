IMAGE := hub.teko.vn/data/airflow:1.10.6-all

build:
	docker build --pull --tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash
