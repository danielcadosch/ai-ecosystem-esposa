---
name: dispatching-parallel-agents
description: Handle 2+ independent problems simultaneously by dispatching one focused subagent per domain. Use when facing multiple failures or tasks across different subsystems that don't depend on each other. Much faster than sequential investigation.
source: https://github.com/obra/superpowers
---

# Dispatching Parallel Agents

When facing multiple independent problems, dispatch specialized agents to work concurrently rather than investigating sequentially.

## Core Concept

> "Dispatch one agent per independent problem domain. Let them work concurrently."

You keep your context free for coordination. Each agent gets only what it needs.

## When to Use

✅ Dispatch parallel agents when:
- Multiple failures exist across different subsystems
- Problems are independent (fixing one won't resolve others)
- No shared state or sequential dependencies

❌ Don't dispatch when:
- Failures are related (same root cause)
- You need holistic system understanding first
- Agents would write to the same files

## The Four-Step Pattern

### 1. Group by domain
```
Auth failures      → Auth agent
Payment errors     → Payments agent
UI regressions     → Frontend agent
```

### 2. Create focused tasks
Each task must be:
- **Narrowly scoped** to one domain
- **Self-contained** with all necessary context (exact errors, file paths, relevant snippets)
- **Explicit** about deliverables: "Return: root cause + fix + test output"

### 3. Dispatch concurrently
Launch all agents in the **same message/turn** so they run simultaneously.

### 4. Review and integrate
- Verify no conflicting changes (same file modified by two agents)
- Run full test suite
- Merge all changes

## Agent Prompt Requirements

Effective prompts are:
- Focused on ONE problem domain
- Include exact error messages and file paths
- Specify expected output format
- Set clear boundaries ("only modify files in `src/auth/`")

## Critical Mistakes to Avoid

| Mistake | Fix |
|---|---|
| Too-broad scope: "Fix all tests" | Split by domain |
| Missing context | Include exact errors + file paths |
| Vague deliverables: "Fix it" | "Return: root cause, code fix, test output" |
| Shared resources | Don't assign same files to two agents |
