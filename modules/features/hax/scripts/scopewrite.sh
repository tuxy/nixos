#!/usr/bin/env bash
# scopewrite — spawn an hax subagent scoped to an explicit write allowlist.
#
# usage: scopewrite [--resume=ID] WRITABLE_FILE... -- TASK
#
# Runs `hax -p TASK` in a bubblewrap sandbox where the whole filesystem is
# read-only except the listed files, which may be written (or created).
# Everything else fails with EROFS. Requires bubblewrap and hax on PATH.
#
# Every run also gets a tmux window, so agents can be watched live. The window
# goes into the current session when scopewrite runs under tmux, otherwise into
# a detached "hax-agents" session. The agent runs with --json and its event
# stream is formatted by haxlog.py, live in the pane and replayed on our stdout:
# callers still get the output and the agent's exit status. Without a tmux
# session it can talk to, the agent just runs here.
#
# The sandbox keeps the graphics stack: /dev is the host's (render nodes,
# /dev/shm, ptys) and the X11 socket is bound in, so agents can run and render
# GUI apps on the session's display.

set -euo pipefail

die() { printf 'scopewrite: %s\n' "$*" >&2; exit 2; }

usage() {
  sed -n '2,7p' "$(command -v -- "$0")" | sed 's/^# \{0,1\}//'
  exit 2
}

[ $# -ge 2 ] || usage

resume=""
writables=()
while [ $# -gt 0 ] && [ "$1" != "--" ]; do
  case "$1" in
    --resume)
      [ $# -ge 2 ] || die "--resume needs an id"
      resume="$2"; shift 2 ;;
    --resume=*)
      resume="${1#--resume=}"
      [ -n "$resume" ] || die "--resume needs an id"
      shift ;;
    *)
      f=$(realpath -m -- "$1") || die "bad path: $1"
      writables+=("$f")
      shift ;;
  esac
done
[ $# -ge 2 ] || die "nothing after -- (expected TASK)"
shift
task="$*"

# Pre-create files so bwrap can bind them (bind of a missing file fails).
# Only files we were explicitly told are writable get created.
for f in "${writables[@]}"; do
  if [ ! -e "$f" ]; then
    [ -d "$(dirname -- "$f")" ] || die "parent directory missing: $(dirname -- "$f")"
    : > "$f"
  fi
done

bwrap_args=(
  --ro-bind / /
  --dev-bind /dev /dev
  --tmpfs /tmp
  --proc /proc
  --unshare-pid
  --unshare-ipc
  --unshare-uts
  --die-with-parent
)
# The private /tmp hides the host's: X11 clients need that socket back.
[ -d /tmp/.X11-unix ] && bwrap_args+=(--ro-bind /tmp/.X11-unix /tmp/.X11-unix)
# Non-root: user namespace is required to unshare, keep own uid/gid inside.
if [ "$(id -u)" -ne 0 ]; then
  bwrap_args+=(--unshare-user --uid "$(id -u)" --gid "$(id -g)")
fi
for f in "${writables[@]}"; do
  bwrap_args+=(--bind "$f" "$f")
done

hax_args=(-p "$task")
# haxlog.py turns --json into a transcript we can watch and hand back; without
# it (or python3) -p is the only thing left, and it prints just the final message.
formatter=""
for cand in "$(command -v haxlog.py || true)" "$(dirname -- "$0")/haxlog.py"; do
  if [ -n "$cand" ] && [ -x "$cand" ] && command -v python3 >/dev/null 2>&1; then
    formatter="$cand"
    hax_args=(--json "${hax_args[@]}")
    break
  fi
done
[ -n "$resume" ] && hax_args=(--resume="$resume" "${hax_args[@]}")

printf 'scopewrite: writable: %s\n' "${writables[*]:-none}" >&2

agent=(bwrap "${bwrap_args[@]}" -- hax "${hax_args[@]}")

# Runs the agent here, in this process: used when there is no pane to put it in.
run_here() {
  if [ -n "$formatter" ]; then
    "${agent[@]}" 2>&1 | "$formatter"
  else
    "${agent[@]}" 2>&1
  fi
}

if ! command -v tmux >/dev/null 2>&1; then
  run_here
  exit 0
fi

work=$(mktemp -d -t scopewrite.XXXXXX)
log="$work/output"
status_fifo="$work/status"
status_file="$work/rc"
pane="$work/pane"
mkfifo -- "$status_fifo"
win=""

cleanup() {
  if [ -n "$win" ]; then
    tmux kill-window -t "$win" 2>/dev/null || true
  fi
  rm -rf -- "$work"
  return 0
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM HUP

window_name=$(printf '%s' "$task" | tr -cs '[:alnum:]' '-' | sed -e 's/^-\+//' -e 's/-\+$//' | cut -c1-24)
[ -n "$window_name" ] || window_name=agent

# The pane: hold the status fifo open (its close, on any death, tells us the run
# is over), run the agent, mirror its transcript to $log for the caller, report
# the exit status, then exit with it. The window is created by a tmux server
# that may be far older than this call, so carry our environment and directory
# over explicitly instead of inheriting the server's.
pane_pipeline="$(printf '%q ' "${agent[@]}")2>&1"
[ -n "$formatter" ] && pane_pipeline="$pane_pipeline | $(printf '%q' "$formatter")"
cat > "$pane" <<EOF
#!/usr/bin/env bash
set -o pipefail
cd -- $(printf '%q' "$PWD")
exec 3>$(printf '%q' "$status_fifo")
$(declare -px)
$pane_pipeline | tee -- $(printf '%q' "$log")
rc=\$?
printf '%s\n' "\$rc" >&3
exit "\$rc"
EOF
chmod 755 "$pane"
pane_sh=$(printf '%q' "$pane")

# Watch in whatever session we were started from, else in a dedicated one. A
# TMUX we cannot reach (a sandbox has its own /tmp, so the socket is not there)
# is no use: the run then has no pane, it happens right here.
target=""
if [ -n "${TMUX:-}" ] && [ -n "${TMUX_PANE:-}" ]; then
  target=$(tmux display-message -p -t "$TMUX_PANE" '#{session_id}' 2>/dev/null) || target=""
fi
if [ -n "$target" ]; then
  win=$(tmux new-window -d -P -F '#{window_id}' -t "$target" \
    -n "$window_name" "$pane_sh" 2>/dev/null) || win=""
elif [ -z "${TMUX:-}" ]; then
  if tmux has-session -t "=hax-agents" 2>/dev/null; then
    win=$(tmux new-window -d -P -F '#{window_id}' -t hax-agents \
      -n "$window_name" "$pane_sh" 2>/dev/null) || win=""
  else
    win=$(tmux new-session -d -P -F '#{window_id}' -x 220 -y 50 \
      -s hax-agents -n "$window_name" "$pane_sh" 2>/dev/null) || win=""
  fi
fi

if [ -z "$win" ]; then
  printf 'scopewrite: no tmux session to watch in, running in the foreground\n' >&2
  run_here
  exit 0
fi

# Blocks until the pane exits, whatever the reason.
cat "$status_fifo" > "$status_file" &
reader=$!
wait "$reader" || true

rc=130
status=$(cat "$status_file" 2>/dev/null || true)
case "$status" in
  '' | *[!0-9]*) rc=130 ;;
  *) rc="$status" ;;
esac

# Replay the pane transcript: plain text already, minus any escape sequences the
# agent's own diagnostics carried.
if [ -s "$log" ]; then
  sed -e 's/\x1b\[[0-9;?]*[a-zA-Z]//g' -e 's/\x1b\][^\x07]*\x07//g' \
      -e 's/\r$//' "$log"
fi
exit "$rc"
