VARIANT := base
IMAGE   := hub.teko.vn/library/deployer:${VARIANT}

ifeq (${VARIANT}, base)
	DOCKERFILE := Dockerfile
else
	DOCKERFILE := ${VARIANT}/Dockerfile
endif

build:
	docker build --pull --file ${DOCKERFILE} \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash -l
