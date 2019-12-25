build:
	docker build --pull \
		--build-arg APACHE_MIRROR=http://mirrors.viethosting.com/apache \
		--tag hub.teko.vn/data/spark:2.4.4-hadoop-3.1.3 .

publish: build
	docker push hub.teko.vn/data/spark:2.4.4-hadoop-3.1.3
