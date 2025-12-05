# Makefile for common Python workflows
# Usage: make <target>
# Targets:
#   install  - install runtime + dev dependencies from requirements.txt
#   run      - run the dev server (python -m src.serve.app)
#   test     - run pytest
#   lint     - run ruff/black/mypy checks
#   format   - autoformat with ruff/black
#   help     - show this help

PYTHON ?= python
PIP := $(PYTHON) -m pip

.PHONY: help install run test lint format clean

help:
	@echo "Available targets: install run test lint format clean"

install:
	@echo "Installing runtime + dev dependencies from requirements.txt"
	$(PIP) install -r requirements.txt

run:
	@echo "Running dev server (python -m src.serve.app)"
	$(PYTHON) -m src.serve.app

test:
	@echo "Running tests (pytest)"
	$(PYTHON) -m pytest -q

lint:
	@echo "Running lints/checks: ruff, black, mypy"
	$(PYTHON) -m ruff check . && \
	$(PYTHON) -m black --check . && \
	$(PYTHON) -m mypy src

format:
	@echo "Formatting: ruff format, black"
	$(PYTHON) -m ruff format . || true
	$(PYTHON) -m black .

clean:
	@echo "Cleaning build artifacts and caches (no-op safe)"
	-rm -rf build dist *.egg-info .pytest_cache __pycache__
