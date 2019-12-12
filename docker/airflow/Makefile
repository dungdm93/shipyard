build:
	docker build --pull \
		--tag hub.teko.vn/data/airflow:all-1.10.6 .

publish: build
	docker push hub.teko.vn/data/airflow:all-1.10.6

run:
	docker run -it --rm hub.teko.vn/data/airflow:all-1.10.6 bash
