#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MANIFEST_DIR="$REPO_ROOT/manifests"
TARGET_HOME="$HOME"
INSTALL_CLAUDE=1
INSTALL_CODEX=1
INSTALL_GEMINI=1
WITH_PRIVATE=0
PRIVATE_DIR="${AGENTS_PRIVATE_DIR:-$REPO_ROOT/private}"

usage() {
  cat <<'EOF' >&2
Usage: ./scripts/install.sh [--home PATH] [--claude-only | --codex-only | --gemini-only] [--with-private]

Installs the tracked core pack into ~/.claude/agents, ~/.codex/skills, and ~/.gemini/agents.
Use --with-private to also install the local ignored private overlay if it exists.
EOF
  exit 1
}

manifest_entries() {
  local manifest_path="$1"
  if [[ -f "$manifest_path" ]]; then
    grep -Ev '^\s*(#|$)' "$manifest_path"
  fi
}

remove_managed_files() {
  local target_dir="$1"
  local manifest_name="$2"
  local entry
  while IFS= read -r entry; do
    [[ -z "$entry" ]] && continue
    rm -f "$target_dir/$entry"
  done < <(
    {
      manifest_entries "$MANIFEST_DIR/${manifest_name}-core.txt"
      manifest_entries "$MANIFEST_DIR/${manifest_name}-legacy-private.txt"
    } | awk '!seen[$0]++'
  )
}

remove_managed_dirs() {
  local target_dir="$1"
  local manifest_name="$2"
  local entry
  while IFS= read -r entry; do
    [[ -z "$entry" ]] && continue
    rm -rf "$target_dir/$entry"
  done < <(
    {
      manifest_entries "$MANIFEST_DIR/${manifest_name}-core.txt"
      manifest_entries "$MANIFEST_DIR/${manifest_name}-legacy-private.txt"
    } | awk '!seen[$0]++'
  )
}

copy_selected_files() {
  local source_dir="$1"
  local target_dir="$2"
  local manifest_name="$3"
  local entry
  while IFS= read -r entry; do
    [[ -z "$entry" ]] && continue
    cp "$source_dir/$entry" "$target_dir/$entry"
  done < <(manifest_entries "$MANIFEST_DIR/${manifest_name}-core.txt")
}

copy_selected_dirs() {
  local source_dir="$1"
  local target_dir="$2"
  local manifest_name="$3"
  local entry
  while IFS= read -r entry; do
    [[ -z "$entry" ]] && continue
    cp -R "$source_dir/$entry" "$target_dir/$entry"
  done < <(manifest_entries "$MANIFEST_DIR/${manifest_name}-core.txt")
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --home)
      [[ $# -lt 2 ]] && usage
      TARGET_HOME="$2"
      shift 2
      ;;
    --claude-only)
      INSTALL_CLAUDE=1
      INSTALL_CODEX=0
      INSTALL_GEMINI=0
      shift
      ;;
    --codex-only)
      INSTALL_CLAUDE=0
      INSTALL_CODEX=1
      INSTALL_GEMINI=0
      shift
      ;;
    --gemini-only)
      INSTALL_CLAUDE=0
      INSTALL_CODEX=0
      INSTALL_GEMINI=1
      shift
      ;;
    --with-private)
      WITH_PRIVATE=1
      shift
      ;;
    *)
      usage
      ;;
  esac
done

if [[ "$INSTALL_CLAUDE" -eq 1 ]]; then
  mkdir -p "$TARGET_HOME/.claude/agents"
  remove_managed_files "$TARGET_HOME/.claude/agents" "claude"
  copy_selected_files "$REPO_ROOT/claude/agents" "$TARGET_HOME/.claude/agents" "claude"
  echo "Installed tracked Claude core pack to $TARGET_HOME/.claude/agents"
fi

if [[ "$INSTALL_CODEX" -eq 1 ]]; then
  mkdir -p "$TARGET_HOME/.codex/skills"
  remove_managed_dirs "$TARGET_HOME/.codex/skills" "codex"
  copy_selected_dirs "$REPO_ROOT/codex/skills" "$TARGET_HOME/.codex/skills" "codex"
  echo "Installed tracked Codex core pack to $TARGET_HOME/.codex/skills"
fi

if [[ "$INSTALL_GEMINI" -eq 1 ]]; then
  mkdir -p "$TARGET_HOME/.gemini/agents"
  remove_managed_files "$TARGET_HOME/.gemini/agents" "gemini"
  copy_selected_files "$REPO_ROOT/gemini/agents" "$TARGET_HOME/.gemini/agents" "gemini"
  echo "Installed tracked Gemini core pack to $TARGET_HOME/.gemini/agents"
fi

if [[ "$WITH_PRIVATE" -eq 1 ]]; then
  if [[ "$INSTALL_CLAUDE" -eq 1 && -d "$PRIVATE_DIR/claude/agents" ]]; then
    cp "$PRIVATE_DIR"/claude/agents/*.md "$TARGET_HOME/.claude/agents/" 2>/dev/null || true
    echo "Installed private Claude overlay from $PRIVATE_DIR/claude/agents"
  fi
  if [[ "$INSTALL_CODEX" -eq 1 && -d "$PRIVATE_DIR/codex/skills" ]]; then
    for skill_dir in "$PRIVATE_DIR"/codex/skills/*; do
      [[ -d "$skill_dir" ]] || continue
      skill_name="$(basename "$skill_dir")"
      rm -rf "$TARGET_HOME/.codex/skills/$skill_name"
      cp -R "$skill_dir" "$TARGET_HOME/.codex/skills/"
    done
    echo "Installed private Codex overlay from $PRIVATE_DIR/codex/skills"
  fi
  if [[ "$INSTALL_GEMINI" -eq 1 && -d "$PRIVATE_DIR/gemini/agents" ]]; then
    cp "$PRIVATE_DIR"/gemini/agents/*.md "$TARGET_HOME/.gemini/agents/" 2>/dev/null || true
    echo "Installed private Gemini overlay from $PRIVATE_DIR/gemini/agents"
  fi
else
  echo "Installed tracked core pack only."
fi

echo "Done. Restart or reload your tools so new agents/skills are discovered."
