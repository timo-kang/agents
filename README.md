# Agents Repo

Portable agent repository for:

- Claude agents in `claude/agents/`
- Codex skills in `codex/skills/`
- managed install profiles in `manifests/`
- local ignored overlays in `private/`
- CI in `.github/workflows/`

This repo is the source of truth for the tracked public core pack so it can be used on other machines without rebuilding prompts and skill files manually.

## Packs

- Core pack: reusable general-purpose roles tracked in git
- Private overlay: local/project-specific agents and skills kept under `private/` and ignored by git

By default, install and sync operate on the tracked core pack only. If a local private overlay exists, you can include it explicitly on machines that have that private directory.

## Included Team

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
├── manifests/
│   └── *.txt
├── .github/workflows/
│   └── validate.yml
├── claude/
│   └── agents/
│       └── *.md
├── codex/
│   └── skills/
│       └── <skill-name>/
│           ├── SKILL.md
│           ├── agents/openai.yaml
│           └── references/...
├── private/              # local only, git-ignored
│   ├── claude/agents/
│   └── codex/skills/
└── scripts/
    ├── install.sh
    └── sync-from-home.sh
    └── validate.sh
```

## Install On Another Machine

Clone the repo, then run:

```bash
./scripts/install.sh
```

By default this installs:

- the repo-managed core Claude agents to `~/.claude/agents`
- the repo-managed core Codex skills to `~/.codex/skills`

The installer is convergent for repo-managed items:

- managed agents/skills that were removed from the repo are removed from the target
- unrelated local agents/skills that are not managed by this repo are left alone

### Install only one side

```bash
./scripts/install.sh --claude-only
./scripts/install.sh --codex-only
```

### Install to a different home directory

```bash
./scripts/install.sh --home /custom/home
```

### Include your local private overlay

```bash
./scripts/install.sh --with-private
```

## Sync This Repo From Your Current Machine

If you edit the live agents under `~/.claude/agents` or `~/.codex/skills`, pull those changes back into this repo with:

```bash
./scripts/sync-from-home.sh
```

This syncs only the tracked core pack from the current machine's home directories.

### Sync your local private overlay too

```bash
./scripts/sync-from-home.sh --with-private
```

### Fail on missing managed files

```bash
./scripts/sync-from-home.sh --strict
```

## Validate The Repo

Before committing or after syncing, run:

```bash
./scripts/validate.sh
```

This checks that:

- every manifest entry exists
- every Codex skill has `SKILL.md` and `agents/openai.yaml`
- no repo-managed skill still contains `[TODO:]` placeholders
- repo-local skill validation passes

### Validate your local private overlay too

```bash
./scripts/validate.sh --with-private
```

This checks the ignored `private/` tree if it exists locally.

## CI

GitHub Actions runs the public-core validation on push and pull request via:

- `.github/workflows/validate.yml`

It validates the tracked public pack only, not your ignored local private overlay.

## Notes

- Put project-specific or proprietary roles under `private/claude/agents/` and `private/codex/skills/`. That path is ignored by git and is intentionally outside the public core pack.
- See [PRIVATE_OVERLAY.md](PRIVATE_OVERLAY.md) for the local private-overlay convention.
- The tracked core roles are intended to stay reusable across projects.
- After installing on another machine, restart or reload Claude/Codex so the new agents and skills are discovered.
