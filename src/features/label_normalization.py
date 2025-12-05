"""Map raw injury/practice labels into Active/Limited/Out categories.

This module provides a small helper to normalize textual labels coming from
ingestion into the three canonical categories used across the codebase
(`active`, `limited`, `out`). The mapping is defined in `LABEL_MAP` and a
reverse lookup `_REVERSE_MAP` is built at import-time to make `normalize` an
O(1) operation. The normalizer is defensive: it handles None, trims
whitespace, and compares case-insensitively.
"""

from typing import Optional


LABEL_MAP = {
    "active": ["Full Practice", "Probable", "Healthy", "Cleared"],
    "limited": ["Limited", "Questionable", "Day-to-Day"],
    "out": ["Out", "Doubtful", "IR", "PUP", "Inactive"],
}


# Build a reverse lookup for O(1) category resolution. Keys are normalized
# (stripped + lowercased) to tolerate casing and surrounding whitespace.
_REVERSE_MAP: dict[str, str] = {}
for category, items in LABEL_MAP.items():
    for item in items:
        if item is None:
            continue
        _REVERSE_MAP[item.strip().lower()] = category


def normalize(label: Optional[str]) -> str:
    """Normalize a raw label (str) into one of: 'active', 'limited', 'out'.

    Returns 'unknown' for None or unrecognized labels.
    """
    if not label:
        return "unknown"
    key = label.strip().lower()
    return _REVERSE_MAP.get(key, "unknown")
