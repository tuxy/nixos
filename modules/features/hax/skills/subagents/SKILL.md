---
name: subagents
description: Spawn hax subagents with clean context. Use when the user asks to delegate a task or run work in parallel.
---

# Subagents

`hax -p "<task>"` runs a fresh hax in this directory with clean context and prints its final answer to stdout. The child inherits this session's provider, model, and effort. Always specify the allowed scope in the prompt.

- Launch each child with `background: true`. Collect with `task_wait`; that is also how several run in parallel.
- The child prints its session id to stderr at startup.
- Follow up on a finished or killed run: `hax --resume=<id> -p "<follow-up>"`.
- Never poll with sleep; give `task_wait` a timeout.
