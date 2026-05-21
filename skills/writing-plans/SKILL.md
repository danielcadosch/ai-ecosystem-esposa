---
name: writing-plans
description: Create comprehensive, step-by-step implementation plans for multi-step development tasks. Use when starting any complex feature, refactor, migration, or project. Plans assume zero codebase context, include exact file paths, complete code (no placeholders), and 2-5 minute bite-sized tasks. Trigger when user says "plan", "how do we implement", "before we start" or is about to begin a complex multi-step task.
source: https://github.com/obra/superpowers
---

# Writing Plans

Create detailed implementation plans that assume **zero context** about the codebase and include all code needed to execute without guessing.

## Core Principle

> "Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste."

If a step changes code, show the code. No exceptions.

## Plan Structure

### Mandatory Header
```markdown
# Plan: [Feature Name]
**Goal**: [One-sentence description]
**Architecture**: [Key technical decisions]
**Tech Stack**: [Languages, frameworks, libraries]
**Estimated Tasks**: [N tasks × 2-5 min each]
```

### File Mapping (before tasks)
List every file to be created or modified:
```markdown
## Files
- `src/auth/jwt.ts` — JWT validation middleware (NEW)
- `src/routes/users.ts` — Add auth middleware (MODIFY)
- `tests/auth.test.ts` — Auth test suite (NEW)
```

### Task Structure
Each task must have:
- **Title**: Action verb + specific target
- **File**: Exact path(s) affected
- **Code**: Complete, runnable (no `// TODO` or `// add error handling`)
- **Command**: Exact terminal commands with expected output
- **Verification**: How to confirm it worked

## Task Granularity

Each task = one action ≈ 2-5 minutes.

**TDD pattern (preferred):**
```
Task N:   Write failing test for [feature]
          → Run: npm test (expect FAIL)
Task N+1: Implement [feature]
          → Run: npm test (expect PASS)
Task N+2: Commit: "feat: add [feature]"
```

## Critical Rules

- **NO placeholders**: Never write "TBD", "add logic here", "similar to above"
- **NO undefined references**: Define every type/function in the same task
- **Show complete code**: Every block must be copy-pasteable
- **Exact commands**: `npm run test:auth` not "run the tests"
- **Expected output**: Show what the terminal should print

## Self-Review Checklist

1. **Spec coverage** — every requirement maps to a task
2. **Placeholder scan** — zero instances of "TBD", "TODO", "etc."
3. **Type consistency** — function signatures match across tasks
4. **Path accuracy** — every file path exact and consistent

## Execution Handoff

At the end, offer two options:
- **Subagent execution**: Fresh agent per task (use `subagent-driven-development` skill)
- **Inline execution**: Sequential with checkpoints in this session

## Save Location
`docs/plans/YYYY-MM-DD-<feature-name>.md`
