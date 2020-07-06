import json
import os
import socket

from flask import Flask

app = Flask("pod-info")


@app.route('/')
def index():
    info = {
        "hostname": socket.gethostname(),
        "namespace": os.getenv("MY_POD_NAMESPACE", "unknown"),
        "pod_name": os.getenv("MY_POD_NAME", "unknown"),
        "pod_ip": os.getenv("MY_POD_IP", "unknown"),
        "node_name": os.getenv("MY_NODE_NAME", "unknown"),
        "service_account": os.getenv("MY_POD_SERVICE_ACCOUNT", "unknown")
    }

    return json.dumps(info) + "\n"


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=8080)
