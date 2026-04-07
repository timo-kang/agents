# Agents Repo

Portable agent repository for:

- Claude agents in `claude/agents/`
- Codex skills in `codex/skills/`

This repo is meant to be the source of truth for the agent team so it can be used on other machines without rebuilding prompts and skill files manually.

## Included Team

- `voca-orchestrator`
- `research-analyst`
- `product-planner`
- `systems-architect`
- `api-designer`
- `ui-systems-designer`
- `frontend-builder`
- `data-modeler`
- `implementation-lead`
- `test-strategist`
- `security-reviewer`
- `observability-reviewer`
- `quality-gatekeeper`
- `ruthless-quality-critic`
- `release-orchestrator`

## Layout

```text
agents/
├── README.md
├── TEAM.md
├── claude/
│   └── agents/
│       └── *.md
├── codex/
│   └── skills/
│       └── <skill-name>/
│           ├── SKILL.md
│           ├── agents/openai.yaml
│           └── references/...
└── scripts/
    ├── install.sh
    └── sync-from-home.sh
```

## Install On Another Machine

Clone the repo, then run:

```bash
./scripts/install.sh
```

By default this installs:

- Claude agents to `~/.claude/agents`
- Codex skills to `~/.codex/skills`

### Install only one side

```bash
./scripts/install.sh --claude-only
./scripts/install.sh --codex-only
```

### Install to a different home directory

```bash
./scripts/install.sh --home /custom/home
```

## Sync This Repo From Your Current Machine

If you edit the live agents under `~/.claude/agents` or `~/.codex/skills`, pull those changes back into this repo with:

```bash
./scripts/sync-from-home.sh
```

This updates the repo copy from the current machine's home directories.

## Notes

- `voca-orchestrator` and its references are project-aware and specific to the Voca codebase.
- The other roles are generally reusable across projects.
- After installing on another machine, restart or reload Claude/Codex so the new agents and skills are discovered.
