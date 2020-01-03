build:
	docker build --pull \
		--tag hub.teko.vn/data/pyspark-notebook:2.4.4-hadoop-3.2.1 .

publish: build
	docker push hub.teko.vn/data/pyspark-notebook:2.4.4-hadoop-3.2.1

run:
	docker run -it --rm --user=root \
		-p 8888:8888 \
		-e GRANT_SUDO=yes \
		-e JUPYTER_ENABLE_LAB=yes \
		hub.teko.vn/data/pyspark-notebook:2.4.4-hadoop-3.2.1
