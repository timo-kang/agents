# Private Overlay

Use the ignored `private/` tree for project-specific, proprietary, or machine-local roles that should not be pushed to the public repo.

## Layout

```text
private/
├── README.local.md
├── claude/
│   └── agents/
│       └── *.md
└── codex/
    └── skills/
        └── <skill-name>/
            ├── SKILL.md
            ├── agents/openai.yaml
            └── references/...
```

## Usage

- Install core only:
  - `./scripts/install.sh`
- Install core plus private overlay:
  - `./scripts/install.sh --with-private`
- Sync core only:
  - `./scripts/sync-from-home.sh`
- Sync core plus private overlay:
  - `./scripts/sync-from-home.sh --with-private`
- Validate core only:
  - `./scripts/validate.sh`
- Validate core plus private overlay:
  - `./scripts/validate.sh --with-private`

## Conventions

- Keep public/generic roles in the tracked repo.
- Keep project-specific orchestrators and proprietary domain logic in `private/`.
- Treat `private/` as local source of truth for your private packs.
- If you want a project-specific pack to become reusable, graduate it into the tracked core pack intentionally.
