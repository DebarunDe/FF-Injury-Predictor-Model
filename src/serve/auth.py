"""Placeholder auth helpers used by the Flask app."""

import os


def get_api_token():
    return os.getenv("API_TOKEN")
