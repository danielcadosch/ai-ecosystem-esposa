---
name: verification-before-completion
description: Always run fresh verification commands before claiming any task is complete. Use this skill for every task, always — never say "should work", "probably passes", or "tests are green" without evidence. Non-negotiable standard.
source: https://github.com/obra/superpowers
---

# Verification Before Completion

**Never claim work is complete without running fresh verification commands and confirming the actual output.**

## The Core Rule

> "Evidence before claims, always."

Before asserting any task is done, fixed, or passing:

1. Identify which command proves your claim
2. Execute that command fresh (not from memory or cache)
3. Read the full output — check exit codes
4. Verify the output actually supports your claim
5. Only then state the claim, with the evidence

## What This Applies To

- ✅ "Tests are passing" → Run them, show the output
- ✅ "The build succeeds" → Run it, show the exit code
- ✅ "Linting is clean" → Run the linter, show the result
- ✅ "The bug is fixed" → Demonstrate with actual behavior
- ✅ "Requirements are met" → Check each one, show evidence
- ✅ "The subagent completed" → Independently verify the output

## Red Flag Language — Never Use

- "Should work now"
- "Probably passes"
- "I think this is fixed"
- "Assuming the tests pass"
- Expressing satisfaction before running verification

## The Pattern

```
❌ Bad:  "I've added the middleware, it should handle auth now."

✅ Good: "I've added the middleware. Running tests:
          $ npm test auth
          ✓ blocks unauthenticated requests (45ms)
          ✓ passes valid JWT tokens (23ms)
          2 passing — confirmed complete."
```

## Why This Matters

False completion claims waste time, break trust, and cause downstream failures.
An unverified "done" that's actually broken is worse than saying "let me check."

> "Claiming work is complete without verification is dishonesty, not efficiency."
