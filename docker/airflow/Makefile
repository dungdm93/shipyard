AIRFLOW_VERSION ?= 1.10.12
IMAGE := hub.teko.vn/dataops/airflow:${AIRFLOW_VERSION}

build:
	docker build --pull \
		--build-arg AIRFLOW_VERSION=${AIRFLOW_VERSION} \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash
