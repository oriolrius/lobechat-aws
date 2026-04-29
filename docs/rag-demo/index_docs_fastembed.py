"""
Re-index sources/ into Qdrant with a schema compatible with mcp-server-qdrant.

mcp-server-qdrant uses fastembed and stores vectors under a NAMED vector
"fast-all-minilm-l6-v2". Haystack's QdrantDocumentStore default writes unnamed
vectors, so the MCP server's qdrant-find rejects the collection. This script:

  1. Splits documents using Haystack (PDF + MD + HTML)
  2. Embeds chunks with fastembed (same model the MCP server uses)
  3. Upserts to Qdrant under the named vector slot, with the payload shape that
     mcp-server-qdrant expects:
        {"document": "<chunk text>", "metadata": {"file_path": "..."}}

Run:
  uv run --with 'haystack-ai' --with 'pypdf' --with 'trafilatura' \
         --with 'fastembed' --with 'qdrant-client' \
         python docs/rag-demo/index_docs_fastembed.py
"""
import uuid
from pathlib import Path

from fastembed import TextEmbedding
from haystack import Pipeline
from haystack.components.converters import (
    PyPDFToDocument,
    TextFileToDocument,
    HTMLToDocument,
)
from haystack.components.preprocessors import DocumentSplitter
from haystack.components.routers import FileTypeRouter
from haystack.components.joiners import DocumentJoiner
from qdrant_client import QdrantClient
from qdrant_client.http import models as qmodels

QDRANT_URL = "http://localhost:47010"
COLLECTION = "rag-demo"
FASTEMBED_MODEL = "sentence-transformers/all-MiniLM-L6-v2"  # fastembed canonical
NAMED_VECTOR = "fast-all-minilm-l6-v2"  # what mcp-server-qdrant expects
DIM = 384

src = Path(__file__).parent / "sources"
files = sorted(p for p in src.iterdir() if p.is_file())
print(f"Found {len(files)} source files")

# 1. Haystack pipeline: convert + split (no embedding/writer)
p = Pipeline()
p.add_component(
    "router",
    FileTypeRouter(mime_types=["application/pdf", "text/plain", "text/markdown", "text/html"]),
)
p.add_component("pdf", PyPDFToDocument())
p.add_component("txt", TextFileToDocument())
p.add_component("html", HTMLToDocument())
p.add_component("join", DocumentJoiner())
p.add_component("split", DocumentSplitter(split_by="word", split_length=200, split_overlap=30))

p.connect("router.application/pdf", "pdf.sources")
p.connect("router.text/plain", "txt.sources")
p.connect("router.text/markdown", "txt.sources")
p.connect("router.text/html", "html.sources")
p.connect("pdf", "join")
p.connect("txt", "join")
p.connect("html", "join")
p.connect("join", "split")

p.draw(path=Path(__file__).parent / "pipeline_index.png")

result = p.run({"router": {"sources": [str(f) for f in files]}})
chunks = result["split"]["documents"]
print(f"Chunked into {len(chunks)} pieces")

# 2. Embed with fastembed (same library + model mcp-server-qdrant uses)
embedder = TextEmbedding(model_name=FASTEMBED_MODEL)
texts = [d.content for d in chunks]
vectors = list(embedder.embed(texts))
print(f"Embedded {len(vectors)} chunks (dim={len(vectors[0])})")

# 3. (Re)create collection with the named vector layout fastembed/mcp expects
client = QdrantClient(url=QDRANT_URL)
client.delete_collection(COLLECTION)
client.create_collection(
    collection_name=COLLECTION,
    vectors_config={NAMED_VECTOR: qmodels.VectorParams(size=DIM, distance=qmodels.Distance.COSINE)},
)

# 4. Upsert. Payload must use keys "document" + "metadata" — mcp-server-qdrant
#    reads these to render the qdrant-find result text.
points = [
    qmodels.PointStruct(
        id=str(uuid.uuid4()),
        vector={NAMED_VECTOR: list(map(float, v))},
        payload={
            "document": d.content,
            "metadata": {"file_path": d.meta.get("file_path", "")},
        },
    )
    for d, v in zip(chunks, vectors)
]
client.upsert(collection_name=COLLECTION, points=points, wait=True)
print(f"Upserted {len(points)} points into Qdrant collection '{COLLECTION}'")
