#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_HOME="$HOME"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --home)
      SOURCE_HOME="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Usage: ./scripts/sync-from-home.sh [--home PATH]" >&2
      exit 1
      ;;
  esac
done

mkdir -p "$REPO_ROOT/claude/agents" "$REPO_ROOT/codex/skills"

cp "$SOURCE_HOME"/.claude/agents/*.md "$REPO_ROOT/claude/agents/"

for skill_dir in "$SOURCE_HOME"/.codex/skills/*; do
  if [[ -d "$skill_dir" && -f "$skill_dir/SKILL.md" ]]; then
    skill_name="$(basename "$skill_dir")"
    rm -rf "$REPO_ROOT/codex/skills/$skill_name"
    cp -R "$skill_dir" "$REPO_ROOT/codex/skills/"
  fi
done

echo "Synced live Claude agents and Codex skills back into $REPO_ROOT"
