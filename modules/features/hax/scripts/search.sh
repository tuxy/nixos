#!/usr/bin/env bash
# Search the web via SearXNG (priv.au). Usage: search.sh <query>
set -euo pipefail
query=${1:?usage: search.sh <query>}

curl -fsS --get https://priv.au/search \
  --data-urlencode "q=$query" \
  --data-urlencode "format=json" |
  jq -r '.results[] | "\(.title)\n\(.url)\n\(.content // "")\n"'
