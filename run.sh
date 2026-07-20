#!/usr/bin/env bash
# Queue-driven episode batcher, ultracode pattern: fresh Claude context per
# episode. Usage: ./run.sh [max_episodes]   (default 25)
set -euo pipefail
cd "$(dirname "$0")"

MAX="${1:-25}"
MODEL="${PODCAST_MODEL:-claude-opus-4-8}"
i=0

while grep -qE '^- \[ \] ' queue.md && [ "$i" -lt "$MAX" ]; do
  slug=$(grep -m1 -E '^- \[ \] ' queue.md | sed 's/^- \[ \] //')
  echo "=== episode $((i + 1)) / max $MAX : $slug ==="

  claude --dangerously-skip-permissions --model "$MODEL" -p \
    "Use the litsearch-podcast skill to produce exactly one episode: the first unchecked item in queue.md. Follow the skill's workflow end to end (script, dry-run, render, feed, publish, mark done, commit, push), then stop."

  # Safety: if the item is still unchecked, the run failed — stop looping.
  if grep -qE "^- \[ \] ${slug}\$" queue.md; then
    echo "run.sh: '$slug' still unchecked after invocation; stopping." >&2
    exit 1
  fi
  i=$((i + 1))
done

echo "run.sh: done ($i episode(s) this session)."
