AIRFLOW_VERSION ?= 1.10.7
IMAGE := hub.teko.vn/data/airflow:${AIRFLOW_VERSION}-all

build:
	docker build --pull \
		--build-arg AIRFLOW_VERSION=${AIRFLOW_VERSION} \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash
