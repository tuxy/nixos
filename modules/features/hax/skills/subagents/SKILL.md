---
name: subagents
description: Spawn subagents scoped to an explicit write allowlist. Use when the user asks to delegate a task or run work in parallel.
---

# Subagents

`scopewrite.sh` (on `PATH`) spawns a subagent inside a bubblewrap sandbox and tmux window where the whole filesystem is read-only except the files you list.

## Scoping

Launch agents through:

    scopewrite.sh FILE... -- "prompt"

- List every file the child may create or modify. Everything else fails with EROFS on write, create, rename, or delete.
- Unlisted files stay readable: the subagent can read the whole tree, write only the allowlist.
- New files must be listed explicitly; their parent directory must already exist.
- The child gets a private empty /tmp and its own PID namespace (good for experimentation), but keeps the host's /dev and the X11 socket: GUI apps and GPU/EGL rendering work, and DISPLAY/WAYLAND_DISPLAY are inherited.
- If the task's write targets are unknown, narrow the task first; an unscoped child is not an option.

## Running

- Launch each child with `background: true`. Collect with `task_wait`; that is also how several run in parallel.
- Each run gets a tmux window named after its task (session `hax-agents`, so `tmux a`): the same transcript this call returns, live. A run started from inside a sandbox has no reachable tmux server, so it has no window and runs in the foreground.
- Follow up on a finished or killed run: `scopewrite.sh FILE... --resume=<id> -- "follow-up"`, with the `session` line of the run's transcript as the id. Only runs started outside a sandbox have an id: hax cannot record a session on the sandbox's read-only state directory.
- Never poll with sleep; give `task_wait` a timeout.
