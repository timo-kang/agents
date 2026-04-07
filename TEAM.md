# Team Contract

## Naming

All roles use kebab-case `<domain>-<responsibility>`.

## Default Flow

1. `voca-orchestrator` for ambiguous or multi-stage Voca tasks
2. `research-analyst` or `product-planner` when the task is still being clarified
3. `systems-architect`, `api-designer`, `ui-systems-designer`, `frontend-builder`, or `data-modeler` depending on the design surface
4. `implementation-lead` for code changes
5. `test-strategist`, `security-reviewer`, and `observability-reviewer` when their concerns are materially relevant
6. `quality-gatekeeper` or `ruthless-quality-critic` for review
7. `release-orchestrator` when rollout readiness matters

## Handoff Format

```markdown
## Handoff
- Target agent: [agent-name]
- Why: [reason]
- Required input: [artifacts and constraints]
- Expected output: [decision or deliverable]
```

## Project-Specific Note

The `voca-orchestrator` skill and its reference files encode Voca-specific rules:

- stdlib-only Python backend
- no build step for the core app
- server-rendered templates
- external JS only because of CSP
- SQLite as the source of truth
- optional Capacitor wrapper in `mobile/`
