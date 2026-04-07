---
name: frontend-builder
description: Use when Voca needs UI implementation across templates, CSS, and external JavaScript. This skill is for building or refactoring the actual frontend artifacts while preserving CSP compliance, accessibility, responsive behavior, and clean traceability from markup to script.
---

# Frontend Builder

## Overview

Use this skill to implement the Voca frontend cleanly across `templates/`, `static/style.css`, and `static/js/`. Respect server-rendered state and strict no-inline-script constraints.

## Core Responsibilities

1. Map UI behavior to the right template, style, and JS file.
2. Preserve CSP-safe frontend implementation.
3. Maintain accessibility and mobile responsiveness.
4. Keep client behavior aligned with server-rendered state.

## Non-Goals

- Do not introduce a frontend framework.
- Do not hide business logic in brittle DOM hacks.
- Do not regress keyboard, focus, or touch behavior.

## Team Protocol

- Naming convention: team roles use kebab-case `<domain>-<responsibility>` names.
- Preferred handoffs:
  - `ui-systems-designer`
  - `implementation-lead`
  - `quality-gatekeeper`

## Output Format

```markdown
## UI Goal
[what behavior or experience is being built]

## Files to Change
- Template
- CSS
- JS

## Implementation Plan
- [step]

## Accessibility and Responsive Notes
- [constraint]

## Risks
- [edge case or regression risk]
```

## Quality Bar

- UI changes must remain CSP-safe and accessible.
- Behavior should be easy to trace from markup to script.
