"""Basic rate-limit placeholder. Real implementation should use in-memory or redis-backed counters."""


def allow_request(token: str) -> bool:
    # TODO: implement simple sliding window or token-bucket
    return True
