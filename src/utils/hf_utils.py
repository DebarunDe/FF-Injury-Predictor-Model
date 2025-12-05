"""Helpers for Hugging Face interactions (placeholder).
Real implementation should use huggingface_hub to push artifacts if HF_REPO_ID is set.
"""


def push_artifacts(repo_id: str, artifacts_dir: str = "artifacts"):
    print(f"Would push {artifacts_dir} to {repo_id}")
