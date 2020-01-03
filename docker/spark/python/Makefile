build:
	docker build \
		--build-arg BASE_IMAGE=hub.teko.vn/data/spark:2.4.4-hadoop-3.2.1 \
		--tag hub.teko.vn/data/spark:2.4.4-hadoop-3.2.1-python-3.7 .

push:
	docker push hub.teko.vn/data/spark:2.4.4-hadoop-3.2.1-python-3.7

publish: build push

run:
	docker run -it --rm \
		hub.teko.vn/data/spark:2.4.4-hadoop-3.2.1-python-3.7 bash
