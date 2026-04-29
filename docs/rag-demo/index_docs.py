"""
Haystack + Qdrant indexing pipeline.

Reads source docs (PDF, MD, HTML) from ./sources/, chunks, embeds with
sentence-transformers, writes to Qdrant collection 'rag-demo' via the
qdrant-haystack integration.

Run:
  uv run --with 'haystack-ai' --with 'qdrant-haystack' --with 'pypdf' \
         --with 'trafilatura' --with 'sentence-transformers' \
         python docs/rag-demo/index_docs.py
"""
from pathlib import Path

from haystack import Pipeline
from haystack.components.converters import PyPDFToDocument, TextFileToDocument, HTMLToDocument
from haystack.components.preprocessors import DocumentSplitter
from haystack.components.embedders import SentenceTransformersDocumentEmbedder
from haystack.components.writers import DocumentWriter
from haystack.components.routers import FileTypeRouter
from haystack.components.joiners import DocumentJoiner
from haystack_integrations.document_stores.qdrant import QdrantDocumentStore

QDRANT_URL = "http://localhost:47010"
COLLECTION = "rag-demo"
EMBED_MODEL = "sentence-transformers/all-MiniLM-L6-v2"
DIM = 384

src = Path(__file__).parent / "sources"
files = sorted(p for p in src.iterdir() if p.is_file())
print(f"Found {len(files)} source files")

store = QdrantDocumentStore(
    url=QDRANT_URL,
    index=COLLECTION,
    embedding_dim=DIM,
    recreate_index=True,
)

p = Pipeline()
p.add_component("router", FileTypeRouter(mime_types=["application/pdf", "text/plain", "text/markdown", "text/html"]))
p.add_component("pdf", PyPDFToDocument())
p.add_component("txt", TextFileToDocument())
p.add_component("html", HTMLToDocument())
p.add_component("join", DocumentJoiner())
p.add_component("split", DocumentSplitter(split_by="word", split_length=200, split_overlap=30))
p.add_component("embed", SentenceTransformersDocumentEmbedder(model=EMBED_MODEL))
p.add_component("write", DocumentWriter(document_store=store))

p.connect("router.application/pdf", "pdf.sources")
p.connect("router.text/plain", "txt.sources")
p.connect("router.text/markdown", "txt.sources")
p.connect("router.text/html", "html.sources")
p.connect("pdf", "join")
p.connect("txt", "join")
p.connect("html", "join")
p.connect("join", "split")
p.connect("split", "embed")
p.connect("embed", "write")

p.draw(path=Path(__file__).parent / "pipeline_index.png")
result = p.run({"router": {"sources": [str(f) for f in files]}})
print("Documents written:", result.get("write", {}).get("documents_written"))
