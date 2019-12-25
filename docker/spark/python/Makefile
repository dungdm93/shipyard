build:
	docker build \
		--build-arg BASE_IMAGE=hub.teko.vn/data/spark:2.4.4-hadoop-3.1.3 \
		--tag hub.teko.vn/data/spark:2.4.4-hadoop-3.1.3-python-3.7 .

publish: build
	docker push hub.teko.vn/data/spark:2.4.4-hadoop-3.1.3-python-3.7

run:
	docker run -it --rm \
		hub.teko.vn/data/spark:2.4.4-hadoop-3.1.3-python-3.7 bash
