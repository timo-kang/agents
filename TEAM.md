# Team Contract

## Naming

All roles use kebab-case `<domain>-<responsibility>`.

## Default Flow

1. `research-analyst` or `product-planner` when the task is still being clarified
2. `systems-architect`, `api-designer`, `ui-systems-designer`, `frontend-builder`, or `data-modeler` depending on the design surface
3. `implementation-lead` for code changes
4. `test-strategist`, `security-reviewer`, and `observability-reviewer` when their concerns are materially relevant
5. `quality-gatekeeper` or `ruthless-quality-critic` for review
6. `release-orchestrator` when rollout readiness matters

## Distribution Model

- Core pack: reusable roles installed by default
- Private overlay: project-specific or proprietary roles kept under `private/` and installed only with `--with-private`
- Manifests define the exact repo-managed set for install and sync

Install and sync are scoped to manifest-managed items so unrelated local experiments are not copied into the repo or deleted from a target machine.

## Handoff Format

```markdown
## Handoff
- Target agent: [agent-name]
- Why: [reason]
- Required input: [artifacts and constraints]
- Expected output: [decision or deliverable]
```

Project-specific orchestration layers should live under `private/`, not the tracked public pack.
