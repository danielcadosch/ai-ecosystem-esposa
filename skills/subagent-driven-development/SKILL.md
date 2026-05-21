---
name: subagent-driven-development
description: Execute implementation plans by dispatching fresh subagents per independent task, followed by two-stage review (spec compliance, then code quality). Use when you have a documented plan with mostly independent tasks. Do NOT use for tasks with strong sequential dependencies.
source: https://github.com/obra/superpowers
---

# Subagent-Driven Development

Execute plans by dispatching one fresh subagent per task with two-stage review.

## Core Principle

**Fresh subagent per task + two-stage review (spec → quality) = high quality, fast iteration**

Each subagent gets isolated context — only what it needs for its specific task.

## When to Use

✅ Use when:
- You have a documented implementation plan
- Tasks are mostly independent
- Work stays in the current session

❌ Don't use when:
- Tasks have strong sequential dependencies
- Each task needs full session context
- You need holistic understanding across all changes

## The Task Loop

For each task, repeat:
```
1. Dispatch implementer subagent (fresh context, precise instructions)
2. Handle any questions from the subagent
3. Implementer: implement → test → commit
4. Spec compliance review (did it match the plan?)
5. Code quality review (is the code well-written?)
6. Issues found → re-dispatch implementer → re-review
7. Mark complete, move to next task
```

## Implementer Status Codes

| Status | Meaning | Action required |
|---|---|---|
| `DONE` | Complete, no issues | Proceed to review |
| `DONE_WITH_CONCERNS` | Complete, has notes | Review notes before proceeding |
| `NEEDS_CONTEXT` | Blocked, needs clarification | Answer and re-dispatch |
| `BLOCKED` | Cannot proceed | Escalate to human |

## Model Selection (cost optimization)

| Role | Model | Why |
|---|---|---|
| Mechanical implementation | Fast/cheap | Well-defined, routine work |
| Integration tasks | Standard | Needs some judgment |
| Architecture + review | Most capable | High-stakes decisions |

## Two-Stage Review

**Stage 1 — Spec Compliance**
> "Did the implementation match the plan exactly?"
- Map every requirement to the implementation
- STOP if non-compliant — fix before Stage 2

**Stage 2 — Code Quality**
> "Is the code well-written, maintainable, and idiomatic?"
- Only run after Stage 1 passes
- Issues trigger a fix cycle

## NEVER

- Start on `main`/`master` without explicit user consent
- Skip either review stage
- Proceed with unfixed issues
- Start code quality review before spec compliance passes
- Ignore questions from the subagent implementer
