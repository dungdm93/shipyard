build:
	docker build --pull \
		--build-arg APACHE_MIRROR=http://mirrors.viethosting.com/apache \
		--tag hub.teko.vn/data/pyspark-notebook:2.4.4-hadoop-3.1.3 .

publish: build
	docker push hub.teko.vn/data/pyspark-notebook:2.4.4-hadoop-3.1.3

run:
	docker run -it --user=root \
		-p 8888:8888 \
		-e GRANT_SUDO=yes \
		-e JUPYTER_ENABLE_LAB=yes \
		hub.teko.vn/data/pyspark-notebook:2.4.4-hadoop-3.1.3
