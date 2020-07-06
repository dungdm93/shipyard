FROM python:3.7-alpine

RUN pip install --no-cache-dir Flask
COPY ./main.py /app/
WORKDIR /app

CMD ["python", "/app/main.py"]
