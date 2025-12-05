## Copilot / AI assistant instructions — FF Injury Predictor Model

Purpose: Give immediate, project-specific guidance so an AI coding agent can be productive without extra context.

- Repo “source of truth”: `FF_Injury_Predictor_Model_Design.yaml` — it defines runtime commands, package pins, API contracts, scheduling, and repo layout. Use it first.

- Big picture (from YAML): This is a standalone Python (3.11) microservice that trains LightGBM/XGBoost models and serves calibrated multiclass availability probabilities via a Flask API. Key areas:
  - Data ingestion: `src/ingest/*` (loader: `src/ingest/load_nflverse.py`)
  - Feature engineering: `src/features/*` (label normalization: `src/features/label_normalization.py`)
  - Modeling: `src/modeling/*` (train/calibrate/evaluate/export)
  - Serving/API: `src/serve/*` (app, auth, rate_limit, schema)
  - Ops/scheduling: `src/ops/*` and `src/utils/hf_utils.py`

- Local dev commands (explicit in YAML):
  - Dev server: `python -m src.serve.app` (binds to port 7860 by default)
  - Prod server pattern: `gunicorn -w 2 -b 0.0.0.0:7860 src.serve.app:app`
  - Install deps: `pip install -r requirements.txt` (use Python 3.11)
  - Tests: `pytest -q` (CI runs this)
  - Docker build (CI smoke): `docker build -t model-a:latest .` and `docker run --rm -p 7860:7860 model-a:latest /bin/true`

- Environment & secrets: `API_TOKEN` (required) and `TZ` (default America/New_York). HF Spaces secrets are used in production; for local dev use a `.env` file and `python-dotenv`.

- API contract pointers (explicit):
  - Weekly availability: `GET /v1/availability/{player_id}` → handler: `src.serve.app.get_week_availability`
  - Batch, season, model metadata, healthz, and secured `/admin/rebuild` endpoint (see YAML `api.endpoints` section). Use these handler paths when editing routes/tests.

- Artifacts & outputs: `artifacts/` contains `model.bin`, `calibrator.pkl`, `feature_map.json`, `model_card.md`, and `metrics_report.json`. CI expects these to exist for release flows.

- Data locations: `data/raw`, `data/interim`, `data/processed`. Ingestion writes parquet under `data/raw` (see ingest module outputs in YAML).

- CI / checks: `.github/workflows/ci.yml` (referenced in YAML). CI runs: setup Python 3.11, `pip install -r requirements.txt`, `pytest`, Docker smoke test. Follow these steps locally to reproduce CI.

- Coding conventions and quality tools (from YAML): ruff + black for style; mypy for typing; bandit for security. Prefer existing style when changing code.

- Merge guidance for existing instruction files: none found in repo — create or edit `.github/copilot-instructions.md` only. If future AGENT/CLAUDE files appear, merge salient items (env secrets, protos, API contract) into this file.

- Quick-edit examples (use these exact paths):
  - If implementing an API change, update `src/serve/app.py` and add/update JSON schema in `src/serve/schema.py`.
  - If adding features, place feature builders in `src/features/build_features.py` and update outputs referenced in YAML.
  - If changing model export, update `src/modeling/export.py` and ensure `artifacts/*` filenames match YAML `modeling.export.outputs`.

- Scheduling note: HF Spaces cannot cron natively. The `/admin/rebuild` endpoint is secured and expected to be hit by an external scheduler (GitHub Actions, Cloud Function, or cron). See `scheduling.runner` for options.

- When uncertain, prefer to consult `FF_Injury_Predictor_Model_Design.yaml` rather than guessing; it encodes intent, endpoints, and exact filenames.

If anything above is unclear or you want me to expand examples (tests, sample curl requests, or a small CI smoke job), tell me which area to extend.
