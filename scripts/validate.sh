#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MANIFEST_DIR="$REPO_ROOT/manifests"
VALIDATOR="$HOME/.codex/skills/.system/skill-creator/scripts/quick_validate.py"
FAILURES=0
WITH_PRIVATE=0
PRIVATE_DIR="${AGENTS_PRIVATE_DIR:-$REPO_ROOT/private}"

usage() {
  cat <<'EOF' >&2
Usage: ./scripts/validate.sh [--with-private]

Validates the tracked core pack by default.
Use --with-private to also validate the local ignored private overlay if it exists.
EOF
  exit 1
}

manifest_entries() {
  local manifest_path="$1"
  if [[ -f "$manifest_path" ]]; then
    grep -Ev '^\s*(#|$)' "$manifest_path"
  fi
}

check_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    echo "Missing file: $path" >&2
    FAILURES=1
  fi
}

check_skill() {
  local skill_dir="$1"
  if [[ ! -d "$skill_dir" ]]; then
    echo "Missing skill dir: $skill_dir" >&2
    FAILURES=1
    return
  fi
  check_file "$skill_dir/SKILL.md"
  check_file "$skill_dir/agents/openai.yaml"
  if grep -RIn '\[TODO:' "$skill_dir" >/dev/null 2>&1; then
    echo "Found TODO placeholder in $skill_dir" >&2
    FAILURES=1
  fi
  if [[ -f "$VALIDATOR" ]]; then
    if ! python3 "$VALIDATOR" "$skill_dir" >/dev/null; then
      echo "Validator failed for $skill_dir" >&2
      FAILURES=1
    fi
  fi
}

check_optional_private_file() {
  local path="$1"
  if [[ -e "$path" && ! -f "$path" ]]; then
    echo "Expected file but found something else: $path" >&2
    FAILURES=1
  fi
}

check_optional_private_skill() {
  local skill_dir="$1"
  if [[ ! -e "$skill_dir" ]]; then
    return
  fi
  check_skill "$skill_dir"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-private)
      WITH_PRIVATE=1
      shift
      ;;
    *)
      usage
      ;;
  esac
done

while IFS= read -r entry; do
  [[ -z "$entry" ]] && continue
  check_file "$REPO_ROOT/claude/agents/$entry"
done < <(
  manifest_entries "$MANIFEST_DIR/claude-core.txt"
)

while IFS= read -r entry; do
  [[ -z "$entry" ]] && continue
  check_skill "$REPO_ROOT/codex/skills/$entry"
done < <(
  manifest_entries "$MANIFEST_DIR/codex-core.txt"
)

if [[ "$WITH_PRIVATE" -eq 1 ]]; then
  if [[ -d "$PRIVATE_DIR/claude/agents" ]]; then
    while IFS= read -r private_file; do
      [[ -z "$private_file" ]] && continue
      check_optional_private_file "$private_file"
    done < <(find "$PRIVATE_DIR/claude/agents" -maxdepth 1 -type f -name '*.md' | sort)
  fi

  if [[ -d "$PRIVATE_DIR/codex/skills" ]]; then
    while IFS= read -r private_skill; do
      [[ -z "$private_skill" ]] && continue
      check_optional_private_skill "$private_skill"
    done < <(find "$PRIVATE_DIR/codex/skills" -mindepth 1 -maxdepth 1 -type d | sort)
  fi
fi

if [[ "$FAILURES" -ne 0 ]]; then
  echo "Validation failed." >&2
  exit 1
fi

echo "Validation passed."
