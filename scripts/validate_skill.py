#!/usr/bin/env python3
"""Validate a Codex skill directory for this repo."""

from __future__ import annotations

import re
import sys
from pathlib import Path

import yaml


def fail(message: str) -> int:
    print(message, file=sys.stderr)
    return 1


def load_yaml(path: Path):
    try:
        return yaml.safe_load(path.read_text())
    except yaml.YAMLError as exc:
        raise ValueError(f"Invalid YAML in {path}: {exc}") from exc


def validate_interface(data: any, path: Path, skill_name: str) -> int:
    if not isinstance(data, dict):
        return fail(f"{path.name} must be a mapping in {path}")

    interface = data.get("interface")
    if not isinstance(interface, dict):
        return fail(f"Missing interface mapping in {path}")

    display_name = interface.get("display_name")
    short_description = interface.get("short_description")
    default_prompt = interface.get("default_prompt")

    if not isinstance(display_name, str) or not display_name.strip():
        return fail(f"Missing interface.display_name in {path}")
    if not isinstance(short_description, str) or not (25 <= len(short_description) <= 64):
        return fail(
            f"interface.short_description must be 25-64 chars in {path}"
        )
    if default_prompt is not None:
        if not isinstance(default_prompt, str) or f"${skill_name}" not in default_prompt:
            return fail(
                f"interface.default_prompt must be a string mentioning ${skill_name} in {path}"
            )
    return 0


def validate_skill(skill_dir: Path) -> int:
    skill_md = skill_dir / "SKILL.md"
    openai_yaml = skill_dir / "agents" / "openai.yaml"
    gemini_yaml = skill_dir / "agents" / "gemini.yaml"

    if not skill_md.is_file():
      return fail(f"Missing SKILL.md: {skill_md}")
    if not openai_yaml.is_file():
      return fail(f"Missing agents/openai.yaml: {openai_yaml}")
    if not gemini_yaml.is_file():
      return fail(f"Missing agents/gemini.yaml: {gemini_yaml}")

    content = skill_md.read_text()
    match = re.match(r"^---\n(.*?)\n---\n", content, re.DOTALL)
    if not match:
        return fail(f"Missing or invalid frontmatter in {skill_md}")

    try:
        frontmatter = yaml.safe_load(match.group(1))
    except yaml.YAMLError as exc:
        return fail(f"Invalid YAML frontmatter in {skill_md}: {exc}")

    if not isinstance(frontmatter, dict):
        return fail(f"Frontmatter must be a mapping in {skill_md}")

    skill_name = frontmatter.get("name")
    description = frontmatter.get("description")
    if not isinstance(skill_name, str) or not skill_name.strip():
        return fail(f"Frontmatter name missing or invalid in {skill_md}")
    if skill_name != skill_dir.name:
        return fail(
            f"Skill dir/name mismatch: dir={skill_dir.name} frontmatter={skill_name}"
        )
    if not isinstance(description, str) or not description.strip():
        return fail(f"Frontmatter description missing or invalid in {skill_md}")

    for yaml_path in [openai_yaml, gemini_yaml]:
        try:
            data = load_yaml(yaml_path)
            res = validate_interface(data, yaml_path, skill_name)
            if res != 0:
                return res
        except ValueError as exc:
            return fail(str(exc))

    if "[TODO:" in content:
        return fail(f"Found TODO placeholder in {skill_md}")

    return 0


def main() -> int:
    if len(sys.argv) != 2:
        return fail("Usage: validate_skill.py <skill-dir>")
    return validate_skill(Path(sys.argv[1]).resolve())


if __name__ == "__main__":
    sys.exit(main())
