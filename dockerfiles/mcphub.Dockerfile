FROM samanhappy/mcphub:latest

# graphviz + dev headers required by `infrastructure-diagram-mcp-server`
# (pulls pygraphviz which compiles against the libcgraph headers)
USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends graphviz libgraphviz-dev gcc docker.io \
 && rm -rf /var/lib/apt/lists/*
