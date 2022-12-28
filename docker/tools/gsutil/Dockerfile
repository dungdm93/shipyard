FROM python:3.10-alpine

RUN pip install gsutil==5.17

COPY ./entrypoint.sh "/usr/local/bin/"
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
