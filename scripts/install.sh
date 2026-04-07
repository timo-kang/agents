#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_HOME="$HOME"
INSTALL_CLAUDE=1
INSTALL_CODEX=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --home)
      TARGET_HOME="$2"
      shift 2
      ;;
    --claude-only)
      INSTALL_CLAUDE=1
      INSTALL_CODEX=0
      shift
      ;;
    --codex-only)
      INSTALL_CLAUDE=0
      INSTALL_CODEX=1
      shift
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Usage: ./scripts/install.sh [--home PATH] [--claude-only | --codex-only]" >&2
      exit 1
      ;;
  esac
done

if [[ "$INSTALL_CLAUDE" -eq 1 ]]; then
  mkdir -p "$TARGET_HOME/.claude/agents"
  cp "$REPO_ROOT"/claude/agents/*.md "$TARGET_HOME/.claude/agents/"
  echo "Installed Claude agents to $TARGET_HOME/.claude/agents"
fi

if [[ "$INSTALL_CODEX" -eq 1 ]]; then
  mkdir -p "$TARGET_HOME/.codex/skills"
  for skill_dir in "$REPO_ROOT"/codex/skills/*; do
    skill_name="$(basename "$skill_dir")"
    rm -rf "$TARGET_HOME/.codex/skills/$skill_name"
    cp -R "$skill_dir" "$TARGET_HOME/.codex/skills/"
  done
  echo "Installed Codex skills to $TARGET_HOME/.codex/skills"
fi

echo "Done. Restart or reload your tools so new agents/skills are discovered."
