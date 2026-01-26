"""
Tests for vLLM OpenAI-compatible API.

Run with: uv run --group test pytest tests/test_vllm.py -v
"""

import os

import httpx
import pytest
from openai import OpenAI

VLLM_BASE_URL = os.environ.get("VLLM_BASE_URL", "http://localhost:47007/v1")
VLLM_API_KEY = os.environ.get("VLLM_API_KEY", "sk-local")
VLLM_MODEL_ID = os.environ.get("VLLM_MODEL_ID", "oriolrius/myemoji-gemma-3-270m-it")


@pytest.fixture
def vllm_client():
    """Create OpenAI client configured for vLLM."""
    return OpenAI(
        base_url=VLLM_BASE_URL,
        api_key=VLLM_API_KEY,
    )


class TestVLLMHealth:
    """Test vLLM server health and availability."""

    def test_health_endpoint(self):
        """Test that vLLM health endpoint responds."""
        base_url = VLLM_BASE_URL.replace("/v1", "")
        response = httpx.get(f"{base_url}/health", timeout=10)
        assert response.status_code == 200

    def test_models_endpoint(self, vllm_client):
        """Test that models endpoint returns available models."""
        models = vllm_client.models.list()
        model_ids = [m.id for m in models.data]
        assert len(model_ids) > 0, "No models available"
        print(f"\nAvailable models: {model_ids}")

    def test_expected_model_loaded(self, vllm_client):
        """Test that our expected model is loaded."""
        models = vllm_client.models.list()
        model_ids = [m.id for m in models.data]
        assert VLLM_MODEL_ID in model_ids, f"Expected model {VLLM_MODEL_ID} not found in {model_ids}"


class TestVLLMCompletion:
    """Test vLLM chat completion functionality."""

    def test_simple_completion(self, vllm_client):
        """Test basic chat completion."""
        response = vllm_client.chat.completions.create(
            model=VLLM_MODEL_ID,
            messages=[
                {"role": "user", "content": "Say hello in one word."}
            ],
            max_tokens=10,
            temperature=0.1,
        )
        assert response.choices[0].message.content is not None
        assert len(response.choices[0].message.content) > 0
        print(f"\nResponse: {response.choices[0].message.content}")

    def test_completion_with_system_message(self, vllm_client):
        """Test chat completion with system message."""
        response = vllm_client.chat.completions.create(
            model=VLLM_MODEL_ID,
            messages=[
                {"role": "system", "content": "You are a helpful assistant. Be concise."},
                {"role": "user", "content": "What is 2+2?"}
            ],
            max_tokens=20,
            temperature=0.1,
        )
        content = response.choices[0].message.content
        assert content is not None
        print(f"\nResponse: {content}")

    def test_streaming_completion(self, vllm_client):
        """Test streaming chat completion."""
        stream = vllm_client.chat.completions.create(
            model=VLLM_MODEL_ID,
            messages=[
                {"role": "user", "content": "Count from 1 to 3."}
            ],
            max_tokens=30,
            temperature=0.1,
            stream=True,
        )

        chunks = []
        for chunk in stream:
            if chunk.choices[0].delta.content:
                chunks.append(chunk.choices[0].delta.content)

        full_response = "".join(chunks)
        assert len(full_response) > 0
        print(f"\nStreamed response: {full_response}")


class TestVLLMMetrics:
    """Test vLLM metrics and usage tracking."""

    def test_usage_stats_returned(self, vllm_client):
        """Test that usage statistics are returned."""
        response = vllm_client.chat.completions.create(
            model=VLLM_MODEL_ID,
            messages=[
                {"role": "user", "content": "Hi"}
            ],
            max_tokens=5,
        )
        assert response.usage is not None
        assert response.usage.prompt_tokens > 0
        assert response.usage.completion_tokens > 0
        assert response.usage.total_tokens > 0
        print(f"\nUsage: {response.usage}")


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
