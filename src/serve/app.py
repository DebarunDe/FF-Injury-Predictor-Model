"""Minimal Flask app for local dev and testing.
Run with: python -m src.serve.app
"""

from __future__ import annotations
import os
from flask import Flask, jsonify, request, abort

app = Flask(__name__)
API_TOKEN = os.getenv("API_TOKEN")


def _check_auth():
    token = None
    auth = request.headers.get("Authorization")
    if auth and auth.lower().startswith("bearer "):
        token = auth.split(" ", 1)[1].strip()
    return token == API_TOKEN or API_TOKEN is None


@app.route("/healthz", methods=["GET"])
def healthz():
    return jsonify({"status": "ok"})


@app.route("/v1/metadata/model", methods=["GET"])
def get_model_metadata():
    # Minimal metadata response; real handler lives in src.serve.app.get_model_metadata
    return jsonify({"model_version": "A-1.0.0", "trained_at": None})


@app.route("/admin/rebuild", methods=["POST"])
def admin_rebuild():
    if not _check_auth():
        abort(401)
    # placeholder: trigger rebuild logic in src.ops.snapshots
    return jsonify({"status": "rebuild_triggered"})


if __name__ == "__main__":
    port = int(os.getenv("PORT", "7860"))
    app.run(host="0.0.0.0", port=port)
