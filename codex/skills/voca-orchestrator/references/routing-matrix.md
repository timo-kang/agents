# Voca Routing Matrix

## Start Here

- Unclear scope or mixed concerns: `voca-orchestrator`
- Factual investigation or codebase reconnaissance: `research-analyst`
- Scope, sequencing, and phased delivery: `product-planner`

## Design and Structure

- System boundaries, handler decomposition, and technical tradeoffs: `systems-architect`
- Route contracts, form workflows, and handler semantics: `api-designer`
- SQLite schema, constraints, persistence behavior: `data-modeler`

## UX and Frontend

- UX flows, hierarchy, and component rules: `ui-systems-designer`
- Template, CSS, and JS implementation: `frontend-builder`

## Execution and Review

- Production code changes: `implementation-lead`
- Verification strategy and test gaps: `test-strategist`
- Threat modeling and hardening review: `security-reviewer`
- Logging, diagnostics, and operability gaps: `observability-reviewer`
- Final readiness gate: `quality-gatekeeper`
- More adversarial critique: `ruthless-quality-critic`
- Rollout, launch, and fallback planning: `release-orchestrator`

## Typical Sequences

### Feature work

`voca-orchestrator` -> `product-planner` -> `systems-architect` or `ui-systems-designer` -> `implementation-lead` -> `test-strategist` -> `quality-gatekeeper`

### Data-heavy feature

`voca-orchestrator` -> `data-modeler` -> `api-designer` -> `implementation-lead` -> `test-strategist` -> `security-reviewer` if sensitive

### UI refactor

`voca-orchestrator` -> `ui-systems-designer` -> `frontend-builder` -> `quality-gatekeeper`

### Release decision

`implementation-lead` -> `test-strategist` -> `security-reviewer` if needed -> `quality-gatekeeper` -> `release-orchestrator`
