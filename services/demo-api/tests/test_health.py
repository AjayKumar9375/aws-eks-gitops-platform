from app import app


def test_healthz():
    client = app.test_client()
    res = client.get("/healthz")
    assert res.status_code == 200
    assert res.data == b"ok"


def test_readyz():
    client = app.test_client()
    res = client.get("/readyz")
    assert res.status_code == 200
    assert res.data == b"ready"


def test_root():
    client = app.test_client()
    res = client.get("/")
    assert res.status_code == 200
    assert res.get_json() == {"service": "demo-api", "status": "ok"}


def test_metrics_contains_path_labels():
    client = app.test_client()
    client.get("/healthz")
    res = client.get("/metrics")

    assert res.status_code == 200
    assert res.headers["Content-Type"].startswith("text/plain")
    metrics_payload = res.data.decode("utf-8")
    assert 'demo_api_requests_total{path="/healthz"}' in metrics_payload
    assert 'demo_api_requests_total{path="/metrics"}' in metrics_payload
