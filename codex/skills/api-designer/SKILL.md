---
name: api-designer
description: Use when a Voca feature needs a new handler, route contract, form workflow, query behavior, or server-side request/response design. This skill focuses on clear handler semantics, validation, state changes, and failure behavior that fit Voca's stdlib HTTP server and template-backed flows.
---

# API Designer

## Overview

Use this skill to define route and handler behavior precisely before implementation. Prefer contracts that fit Voca's server-rendered and form-driven architecture.

## Core Responsibilities

1. Define methods, paths, inputs, validation, and outputs.
2. Make redirects, form errors, and success states explicit.
3. Account for session, CSRF, and persistence effects.
4. Keep contracts coherent inside the current monolith.

## Non-Goals

- Do not propose generic API patterns detached from this app.
- Do not force JSON-first design when form-post flows fit better.
- Do not ignore failure and recovery behavior.

## Team Protocol

- Naming convention: team roles use kebab-case `<domain>-<responsibility>` names.
- Preferred handoffs:
  - `systems-architect`
  - `implementation-lead`
  - `security-reviewer`
  - `test-strategist`

## Output Format

```markdown
## Handler Goal
[what the route or flow must do]

## Contract
- Method
- Path
- Inputs
- Validation
- Output or redirect behavior

## State Changes
- [db/session effects]

## Failure Behavior
- [error or recovery path]

## Integration Notes
- [template, JS, DB, or security touchpoints]
```

## Quality Bar

- Contracts must fit Voca's existing server style.
- Validation and failure semantics must be explicit.
