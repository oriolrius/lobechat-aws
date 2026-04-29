"""
Haystack + Qdrant retrieval pipeline (no LLM, just retrieval).

Run:
  uv run --with 'haystack-ai' --with 'qdrant-haystack' \
         --with 'sentence-transformers' \
         python docs/rag-demo/query.py "your question"
"""
import sys

from haystack import Pipeline
from haystack.components.embedders import SentenceTransformersTextEmbedder
from haystack_integrations.components.retrievers.qdrant import QdrantEmbeddingRetriever
from haystack_integrations.document_stores.qdrant import QdrantDocumentStore

QDRANT_URL = "http://localhost:47010"
COLLECTION = "rag-demo"
EMBED_MODEL = "sentence-transformers/all-MiniLM-L6-v2"
DIM = 384

q = sys.argv[1] if len(sys.argv) > 1 else "What is retrieval-augmented generation?"

store = QdrantDocumentStore(url=QDRANT_URL, index=COLLECTION, embedding_dim=DIM)

p = Pipeline()
p.add_component("embed", SentenceTransformersTextEmbedder(model=EMBED_MODEL))
p.add_component("retrieve", QdrantEmbeddingRetriever(document_store=store, top_k=4))
p.connect("embed.embedding", "retrieve.query_embedding")

from pathlib import Path
p.draw(path=Path(__file__).parent / "pipeline_query.png")

r = p.run({"embed": {"text": q}})
print(f"\nQ: {q}\n")
for i, d in enumerate(r["retrieve"]["documents"], 1):
    src = d.meta.get("file_path", "?").split("/")[-1]
    print(f"[{i}] score={d.score:.3f}  source={src}")
    print(d.content[:300].replace("\n", " "))
    print("---")
