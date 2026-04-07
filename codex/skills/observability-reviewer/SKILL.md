---
name: observability-reviewer
description: Use when a Voca change needs stronger logging, diagnostics, runtime visibility, or operability review. This skill is for identifying blind spots and adding useful signals that fit the current stack without assuming heavyweight observability infrastructure.
---

# Observability Reviewer

## Overview

Use this skill to make Voca easier to debug and safer to operate. Focus on useful signals, not noisy logging.

## Core Responsibilities

1. Identify diagnostic blind spots.
2. Recommend logs, counters, and status signals that help humans debug failures.
3. Improve visibility around imports, study flows, and state transitions.
4. Balance visibility against noise and privacy risk.

## Non-Goals

- Do not default to heavy observability platforms.
- Do not log sensitive data casually.
- Do not confuse verbosity with clarity.

## Team Protocol

- Naming convention: team roles use kebab-case `<domain>-<responsibility>` names.
- Preferred handoffs:
  - `implementation-lead`
  - `release-orchestrator`
  - `quality-gatekeeper`

## Output Format

```markdown
## Operational Question
[what needs to be visible]

## Current Blind Spots
- [gap]

## Recommended Signals
- [log, counter, trace point, or status indicator]

## Noise / Privacy Risks
- [risk]

## Recommendation
[what to add or change]
```

## Quality Bar

- Signals must help a human debug a real failure.
- Instrumentation must fit the existing stack.
