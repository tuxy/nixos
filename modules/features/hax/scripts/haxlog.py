#!/usr/bin/env python3
"""Format hax's --json event stream into a readable transcript.

Reads one JSON record per line on stdin and prints progress as it arrives:
session header, tool calls, clipped tool results, assistant text and per-turn
usage. A line that is not a JSON record is passed through untouched, so stderr
mixed into the stream still reaches the reader. Exits 0 always: the status that
matters is hax's, which scopewrite takes from the pipeline.
"""

import json
import sys

MAX_ARGS = 240
MAX_LINE = 200
MAX_RESULT_LINES = 12


def clip(text, limit):
    text = " ".join(str(text).split())
    return text if len(text) <= limit else text[: limit - 1] + "…"


def show_args(tool, arguments):
    try:
        args = json.loads(arguments)
    except (TypeError, ValueError):
        return clip(arguments, MAX_ARGS)
    if tool == "bash" and isinstance(args, dict) and "command" in args:
        return clip(args["command"], MAX_ARGS)
    return clip(json.dumps(args, separators=(",", ":")), MAX_ARGS)


def show_result(output):
    lines = str(output).rstrip("\n").split("\n")
    if lines == [""]:
        return "← (no output)"
    if len(lines) == 1:
        return "← " + clip(lines[0], MAX_LINE)
    shown = [f"  {clip(line, MAX_LINE)}" for line in lines[:MAX_RESULT_LINES]]
    if len(lines) > MAX_RESULT_LINES:
        shown.append(f"  … +{len(lines) - MAX_RESULT_LINES} more lines")
    return "←\n" + "\n".join(shown)


def show_usage(usage):
    elapsed = usage.get("elapsed_ms")
    took = f"{elapsed / 1000:.1f}s · " if isinstance(elapsed, (int, float)) else ""
    return f"· {took}in {usage.get('input', '?')} out {usage.get('output', '?')}"


def main():
    out = sys.stdout
    for line in sys.stdin:
        line = line.rstrip("\n")
        if not line:
            continue
        try:
            rec = json.loads(line)
        except ValueError:
            print(line)
            out.flush()
            continue

        kind, typ = rec.get("kind"), rec.get("type")
        if typ == "session":
            sid = rec.get("id")
            print(f"hax: {rec.get('provider')} · {rec.get('model')}" + (f" · session {sid}" if sid else ""))
        elif kind == "tool_call":
            print(f"→ {rec.get('tool_name')}: {show_args(rec.get('tool_name'), rec.get('arguments'))}")
        elif kind == "tool_result":
            print(show_result(rec.get("output", "")))
        elif kind == "assistant":
            text = str(rec.get("text", "")).strip()
            if text:
                print(text)
        elif kind == "turn_usage":
            print(show_usage(rec.get("usage") or {}))
        elif typ == "result" and rec.get("outcome") != "complete":
            print(f"hax: run ended: {rec.get('outcome')}")
        out.flush()


if __name__ == "__main__":
    main()
