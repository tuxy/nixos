---
name: web-search
description: Search the web through a SearXNG instance. Use for current information, docs, or anything not in the repo.
---

# Web Search

DO NOT USE, INSTANCES DON'T WORK RIGHT NOW.

`search.sh` is not on `PATH`. It sits next to this file, under `$XDG_CONFIG_HOME`. Set it once:

    SEARCH="$XDG_CONFIG_HOME/hax/skills/web-search/search.sh"

Then run:

    "$SEARCH" "nix flake parts import-tree"

Searches priv.au and prints each result as title, URL, and snippet.
