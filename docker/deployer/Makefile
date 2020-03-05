IMAGE := hub.teko.vn/library/deployer

build:
	docker build --pull \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm ${IMAGE} bash -l
