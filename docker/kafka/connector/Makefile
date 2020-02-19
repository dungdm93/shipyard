CONFLUENT_VERSION := 5.4.0
BASE_IMAGE := confluentinc/cp-kafka-connect:${CONFLUENT_VERSION}
IMAGE := hub.teko.vn/data/kafka/connector:${CONFLUENT_VERSION}

build:
	docker build \
		--build-arg BASE_IMAGE=${BASE_IMAGE} \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm --entrypoint=bash ${IMAGE}
