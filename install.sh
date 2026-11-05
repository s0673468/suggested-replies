#!/usr/bin/env bash
# Add (or remove) the suggested-replies block in your agents' global instruction files.
#   ./install.sh              install or update for Claude Code and Codex
#   ./install.sh --uninstall  remove it again
# Only text between the suggested-replies markers is ever touched.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
snippet="$here/snippet.md"
start='<!-- suggested-replies:start'
end='<!-- suggested-replies:end -->'
mode="${1:-install}"

targets=(
  "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/CLAUDE.md"   # Claude Code (also inside T3 Code)
  "${CODEX_HOME:-$HOME/.codex}/AGENTS.md"           # Codex (also inside T3 Code)
)

strip_block() {  # print $1 without the block (and without the blank line before it)
  awk -v s="$start" -v e="$end" '
    index($0, s) == 1 { skip = 1; held = ""; next }
    skip && index($0, e) == 1 { skip = 0; next }
    skip { next }
    /^$/ { held = held "\n"; next }
    { printf "%s", held; held = ""; print }
  ' "$1"
}

for f in "${targets[@]}"; do
  dir="$(dirname "$f")"
  if [ ! -d "$dir" ]; then
    echo "skip    $f (agent not installed)"
    continue
  fi
  if [ "$mode" = "--uninstall" ]; then
    if [ ! -f "$f" ] || ! grep -qF "$start" "$f"; then echo "absent  $f"; continue; fi
    tmp="$(mktemp)"; strip_block "$f" > "$tmp"
    if [ -s "$tmp" ]; then cat "$tmp" > "$f"; else rm -f "$f"; fi  # drop a file we created
    rm -f "$tmp"
    echo "removed $f"
    continue
  fi
  tmp="$(mktemp)"
  if [ -f "$f" ]; then
    strip_block "$f" > "$tmp"
    [ -s "$tmp" ] && printf '\n' >> "$tmp"
    verb=$(grep -qF "$start" "$f" && echo "updated" || echo "added  ")
  else
    verb="created"
  fi
  cat "$snippet" >> "$tmp"
  cat "$tmp" > "$f"; rm -f "$tmp"
  echo "$verb $f"
done

[ "$mode" = "--uninstall" ] || echo "Done. Start a new chat so your agent loads it."
