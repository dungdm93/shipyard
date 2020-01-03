build:
	docker build --pull \
		--tag hub.teko.vn/data/spark:2.4.4-hadoop-3.2.1 .

push:
	docker push hub.teko.vn/data/spark:2.4.4-hadoop-3.2.1

publish: build push

run:
	docker run -it --rm \
		hub.teko.vn/data/spark:2.4.4-hadoop-3.2.1 bash
