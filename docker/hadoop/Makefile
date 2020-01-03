build:
	docker build --pull \
		--tag hub.teko.vn/data/hadoop:3.2.1 .

push:
	docker push hub.teko.vn/data/hadoop:3.2.1

publish: build push

run:
	docker run -it --rm \
		hub.teko.vn/data/hadoop:3.2.1 bash
