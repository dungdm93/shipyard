VARIANT ?= base
IMAGE   := hub.teko.vn/tools/deployer:${VARIANT}

ifeq (${VARIANT}, base)
	DOCKERFILE := Dockerfile
	CONTEXT    := ./
else
	DOCKERFILE := ${VARIANT}/Dockerfile
	CONTEXT    := ./${VARIANT}
endif

build:
	docker build --pull --file ${DOCKERFILE} \
		--tag ${IMAGE} ${CONTEXT}

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash -l
