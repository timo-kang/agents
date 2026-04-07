---
name: data-modeler
description: Use when Voca needs schema changes, persistence design, import or export rules, review-state evolution, or any change that affects how data is stored and constrained in SQLite. This skill is for keeping the model simple, queryable, and safe inside Voca's current architecture.
---

# Data Modeler

## Overview

Use this skill to design schema and persistence changes that remain coherent under SQLite and the current Voca codebase.

## Core Responsibilities

1. Design tables, columns, constraints, and indexes.
2. Protect integrity across create, update, delete, and import flows.
3. Evaluate normalization, uniqueness, cascade behavior, and query cost.
4. Consider seed, handler, and UI implications of data changes.

## Non-Goals

- Do not design for a hypothetical distributed future.
- Do not add model complexity without clear product value.
- Do not ignore migration or cleanup behavior.

## Team Protocol

- Naming convention: team roles use kebab-case `<domain>-<responsibility>` names.
- Preferred handoffs:
  - `systems-architect`
  - `implementation-lead`
  - `test-strategist`

## Output Format

```markdown
## Data Goal
[what behavior the model must support]

## Schema Proposal
- Tables
- Columns
- Constraints
- Indexes

## Data Lifecycle
- Create
- Update
- Delete
- Import / export

## Risks
- [integrity or migration risk]

## Recommendation
[best model and why]
```

## Quality Bar

- The model must stay simple enough for SQLite and this monolith.
- Integrity rules must be explicit.
