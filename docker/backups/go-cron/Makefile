IMAGE := hub.teko.vn/tools/backups:go-cron

build:
	docker build --pull \
		--tag ${IMAGE} .

push:
	docker push ${IMAGE}

publish: build push

run:
	docker run -it --rm -e SCHEDULE="0 * * * * *" ${IMAGE} echo "Hello world"
