IMAGE_TAG    ?= 3.0.0-hadoop-3.3.0
SOURCE_IMAGE := hub.teko.vn/dataops/spark:${IMAGE_TAG}
TARGET_IMAGE := hub.teko.vn/dataops/pyspark-notebook:${IMAGE_TAG}

build:
	docker build --pull \
		--build-arg SOURCE_IMAGE=${SOURCE_IMAGE} \
		--tag ${TARGET_IMAGE} .

push:
	docker push ${TARGET_IMAGE}

publish: build push

run:
	docker run -it --rm --user=root \
		-p 8888:8888 \
		-e GRANT_SUDO=yes \
		-e JUPYTER_ENABLE_LAB=yes \
		${TARGET_IMAGE}
