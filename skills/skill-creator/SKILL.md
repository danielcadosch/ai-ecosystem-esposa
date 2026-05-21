---
name: skill-creator
description: Create new skills, modify and improve existing skills, and measure skill performance. Use when users want to create a skill from scratch, edit or optimize an existing skill, run evals to test a skill, benchmark skill performance, or optimize a skill's description for better triggering accuracy.
source: https://github.com/anthropics/skills
---

# Skill Creator

Create new skills and iteratively improve them through a test-eval-improve loop.

## High-Level Process

1. Decide what the skill should do and roughly how
2. Write a draft of the skill
3. Create test prompts and run Claude-with-skill on them
4. Evaluate results qualitatively and quantitatively
5. Rewrite the skill based on feedback
6. Repeat until satisfied
7. Expand test set and try at larger scale

Figure out where the user is in this process and jump in to help them progress.

---

## Creating a Skill

### Capture Intent

Understand the user's intent. The current conversation might already contain a workflow to capture.
Extract from conversation history: tools used, sequence of steps, corrections made, I/O formats.

Ask:
1. What should this skill enable Claude to do?
2. When should this skill trigger? (what user phrases/contexts)
3. What's the expected output format?
4. Should we set up test cases to verify?

### Interview and Research

Proactively ask about edge cases, input/output formats, example files, success criteria, dependencies.
Research via subagents if available. Don't write test prompts until this is settled.

### Write the SKILL.md

Fill in these components:

- **name**: Skill identifier (lowercase, alphanumeric + hyphens, ≤64 chars)
- **description**: When to trigger AND what it does. This is the primary triggering mechanism.
  - Include both WHAT the skill does AND specific contexts for WHEN to use it
  - Make it slightly "pushy" — LLMs tend to undertrigger. Instead of "How to build a dashboard", write "How to build a dashboard. Use whenever user mentions dashboards, data visualization, or internal metrics."
- **the rest of the skill body**

### Skill Anatomy

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter (name, description required)
│   └── Markdown instructions
└── Bundled Resources (optional)
    ├── scripts/    - Executable code for deterministic/repetitive tasks
    ├── references/ - Docs loaded into context as needed
    └── assets/     - Files used in output (templates, icons, fonts)
```

### Progressive Disclosure (3 levels)

1. **Metadata** (name + description) — Always in context, ~100 words
2. **SKILL.md body** — In context when skill triggers, <500 lines ideal
3. **Bundled resources** — As needed, unlimited

Key patterns:
- Keep SKILL.md under 500 lines; use references/ for overflow
- Reference files clearly with guidance on when to read them
- For large reference files (>300 lines), include a table of contents

### Writing Patterns

Use imperative form. Explain WHY, not just WHAT.

**Output format definition:**
```markdown
## Report structure
ALWAYS use this exact template:
# [Title]
## Executive summary
## Key findings
## Recommendations
```

**Examples pattern:**
```markdown
## Commit message format
Input: Added user authentication with JWT tokens
Output: feat(auth): implement JWT-based authentication
```

**Try to explain WHY behind instructions** — LLMs with good theory of mind go beyond rote instructions when they understand the reasoning.

---

## Running and Evaluating Test Cases

### Step 1: Spawn all runs (with-skill AND baseline) in the same turn

For each test case, spawn two subagents simultaneously:
- **With-skill run**: Task + skill path + save outputs
- **Baseline run**: Same task, no skill (or old version of skill)

NEVER spawn with-skill runs first and then come back for baselines.

### Step 2: While runs are in progress, draft assertions

Good assertions are objectively verifiable with descriptive names.
For subjective outputs (writing style, design quality), use qualitative review.

### Step 3: Grade and aggregate

1. Grade each run against assertions
2. Aggregate into benchmark: pass_rate, time, tokens for each configuration
3. Surface patterns: non-discriminating assertions, high-variance evals, time/token tradeoffs

### Test Cases Format

```json
{
  "skill_name": "example-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "User's task prompt",
      "expected_output": "Description of expected result",
      "files": []
    }
  ]
}
```

---

## Improving the Skill

### How to Think About Improvements

1. **Generalize from feedback.** You're creating a skill for use millions of times across many prompts. Don't overfit to the test examples.

2. **Keep the prompt lean.** Remove things not pulling their weight. If something makes the model waste time doing unproductive things, remove it.

3. **Explain the WHY.** LLMs are smart — give them reasoning, not just rules. If you find yourself writing ALWAYS or NEVER in all caps, try explaining the reasoning instead.

4. **Bundle repeated work.** If all test cases independently wrote the same helper script, bundle it in `scripts/` and tell the skill to use it.

### The Iteration Loop

1. Apply improvements to the skill
2. Rerun all test cases into a new `iteration-<N>/` directory
3. Review results
4. Read feedback, improve, repeat

Stop when: user is happy, feedback is all empty, or you're not making meaningful progress.

---

## Description Optimization

The description field determines whether Claude invokes a skill. After creating or improving a skill, optimize it.

### Process

1. Generate 20 eval queries (mix of should-trigger and should-not-trigger)
2. Review queries with user
3. Run optimization: test current description → propose improvements → re-evaluate → iterate (max 5x)
4. Apply best description to SKILL.md

### Good eval queries are:
- Realistic and specific (file paths, personal context, company names, URLs)
- Mix of formal/casual phrasing
- Edge cases (near-misses, ambiguous phrasing)

**Bad:** `"Format this data"`, `"Extract text from PDF"`
**Good:** `"ok so my boss just sent me this xlsx file (Q4 sales final FINAL v2.xlsx) and she wants me to add a column that shows profit margin as %. Revenue is in column C and costs in column D"`

### How Triggering Works

Claude sees all skill names + descriptions and decides whether to load a skill. It only consults skills for tasks it can't handle on its own — simple one-step queries may not trigger even if description matches. Complex, multi-step queries reliably trigger skills.

---

## Principle of Lack of Surprise

Skills must not contain malware, exploit code, or content that could compromise system security. A skill's contents should not surprise the user in their intent if described. Don't create misleading skills or skills designed to facilitate unauthorized access or data exfiltration.
