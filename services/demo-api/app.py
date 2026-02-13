from flask import Flask, jsonify, request
from prometheus_client import CONTENT_TYPE_LATEST, Counter, generate_latest

app = Flask(__name__)

REQUESTS = Counter("demo_api_requests_total", "Total requests", ["path"])


@app.before_request
def count_requests():
    REQUESTS.labels(path=request.path).inc()


@app.get("/")
def root():
    return jsonify({"service": "demo-api", "status": "ok"})


@app.get("/healthz")
def healthz():
    return "ok", 200


@app.get("/readyz")
def readyz():
    return "ready", 200


@app.get("/metrics")
def metrics():
    data = generate_latest()
    return data, 200, {"Content-Type": CONTENT_TYPE_LATEST}


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
