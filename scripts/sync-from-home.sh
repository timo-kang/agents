#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MANIFEST_DIR="$REPO_ROOT/manifests"
SOURCE_HOME="$HOME"
WITH_PRIVATE=0
STRICT=0
PRIVATE_DIR="${AGENTS_PRIVATE_DIR:-$REPO_ROOT/private}"

usage() {
  cat <<'EOF' >&2
Usage: ./scripts/sync-from-home.sh [--home PATH] [--with-private] [--strict]

Syncs only the tracked core pack from the local machine back into this repo.
Use --with-private to also sync the local ignored private overlay if it already
exists in this repo. Use --strict to fail if any managed file is missing from the source machine.
EOF
  exit 1
}

manifest_entries() {
  local manifest_path="$1"
  if [[ -f "$manifest_path" ]]; then
    grep -Ev '^\s*(#|$)' "$manifest_path"
  fi
}

sync_file_manifest() {
  local source_dir="$1"
  local repo_dir="$2"
  local manifest_name="$3"
  local entry
  while IFS= read -r entry; do
    [[ -z "$entry" ]] && continue
    if [[ -f "$source_dir/$entry" ]]; then
      cp "$source_dir/$entry" "$repo_dir/$entry"
    elif [[ "$STRICT" -eq 1 ]]; then
      echo "Missing managed file in source: $source_dir/$entry" >&2
      exit 1
    else
      echo "Skipping missing managed file: $source_dir/$entry" >&2
    fi
  done < <(manifest_entries "$MANIFEST_DIR/${manifest_name}-core.txt")
}

sync_dir_manifest() {
  local source_dir="$1"
  local repo_dir="$2"
  local manifest_name="$3"
  local entry
  while IFS= read -r entry; do
    [[ -z "$entry" ]] && continue
    if [[ -d "$source_dir/$entry" && -f "$source_dir/$entry/SKILL.md" ]]; then
      rm -rf "$repo_dir/$entry"
      cp -R "$source_dir/$entry" "$repo_dir/$entry"
    elif [[ "$STRICT" -eq 1 ]]; then
      echo "Missing managed skill in source: $source_dir/$entry" >&2
      exit 1
    else
      echo "Skipping missing managed skill: $source_dir/$entry" >&2
    fi
  done < <(manifest_entries "$MANIFEST_DIR/${manifest_name}-core.txt")
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --home)
      [[ $# -lt 2 ]] && usage
      SOURCE_HOME="$2"
      shift 2
      ;;
    --with-private)
      WITH_PRIVATE=1
      shift
      ;;
    --strict)
      STRICT=1
      shift
      ;;
    *)
      usage
      ;;
  esac
done

mkdir -p "$REPO_ROOT/claude/agents" "$REPO_ROOT/codex/skills"

sync_file_manifest "$SOURCE_HOME/.claude/agents" "$REPO_ROOT/claude/agents" "claude"
sync_dir_manifest "$SOURCE_HOME/.codex/skills" "$REPO_ROOT/codex/skills" "codex"

if [[ "$WITH_PRIVATE" -eq 1 ]]; then
  if [[ -d "$PRIVATE_DIR/claude/agents" ]]; then
    for agent_file in "$PRIVATE_DIR"/claude/agents/*.md; do
      [[ -f "$agent_file" ]] || continue
      agent_name="$(basename "$agent_file")"
      if [[ -f "$SOURCE_HOME/.claude/agents/$agent_name" ]]; then
        cp "$SOURCE_HOME/.claude/agents/$agent_name" "$agent_file"
      elif [[ "$STRICT" -eq 1 ]]; then
        echo "Missing private Claude agent in source: $SOURCE_HOME/.claude/agents/$agent_name" >&2
        exit 1
      fi
    done
  fi
  if [[ -d "$PRIVATE_DIR/codex/skills" ]]; then
    for skill_dir in "$PRIVATE_DIR"/codex/skills/*; do
      [[ -d "$skill_dir" ]] || continue
      skill_name="$(basename "$skill_dir")"
      if [[ -d "$SOURCE_HOME/.codex/skills/$skill_name" ]]; then
        rm -rf "$skill_dir"
        cp -R "$SOURCE_HOME/.codex/skills/$skill_name" "$PRIVATE_DIR/codex/skills/"
      elif [[ "$STRICT" -eq 1 ]]; then
        echo "Missing private Codex skill in source: $SOURCE_HOME/.codex/skills/$skill_name" >&2
        exit 1
      fi
    done
  fi
  echo "Synced tracked core pack plus private overlay from $SOURCE_HOME"
else
  echo "Synced tracked core pack only from $SOURCE_HOME"
fi
