#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MANIFEST_DIR="$REPO_ROOT/manifests"
VALIDATOR="$HOME/.codex/skills/.system/skill-creator/scripts/quick_validate.py"
FAILURES=0

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

if [[ "$FAILURES" -ne 0 ]]; then
  echo "Validation failed." >&2
  exit 1
fi

echo "Validation passed."
