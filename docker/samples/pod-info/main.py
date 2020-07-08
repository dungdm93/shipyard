import json
import logging
import os
import socket
import sys

from flask import Flask

logging.basicConfig(stream=sys.stdout, level=logging.INFO)
logger = logging.getLogger(__file__)

app = Flask("pod-info")

info = json.dumps({
    "hostname": socket.gethostname(),
    "namespace": os.getenv("MY_POD_NAMESPACE", "unknown"),
    "pod_name": os.getenv("MY_POD_NAME", "unknown"),
    "pod_ip": os.getenv("MY_POD_IP", "unknown"),
    "node_name": os.getenv("MY_NODE_NAME", "unknown"),
    "service_account": os.getenv("MY_POD_SERVICE_ACCOUNT", "unknown")
})


@app.route('/')
def index():
    logger.info(info)
    return info + "\n"


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=8080)
