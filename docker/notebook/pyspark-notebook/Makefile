IMAGE_TAG    ?= 2.4.4
SOURCE_IMAGE := hub.teko.vn/data/spark:${IMAGE_TAG}
TARGET_IMAGE := hub.teko.vn/data/pyspark-notebook:${IMAGE_TAG}

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


# Spark bundled (w/ Hadoop)
# $ make build
#
# Spark standalone (w/o Hadoop)
# $ make build IMAGE_TAG=2.4.4-hadoop-3.2.1
