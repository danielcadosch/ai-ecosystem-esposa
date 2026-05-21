---
name: skill-judge
description: Evaluate Agent Skill design quality against official specifications and best practices. Use when reviewing, auditing, or improving SKILL.md files and skill packages. Provides multi-dimensional scoring and actionable improvement suggestions.
source: https://github.com/softaworks/agent-toolkit
---

# Skill Judge

Evaluate Agent Skills against official specifications and patterns derived from 17+ official examples.

## Core Philosophy

### What is a Skill?

A Skill is NOT a tutorial. A Skill is a **knowledge externalization mechanism**.

> **Good Skill = Expert-only Knowledge − What Claude Already Knows**

A Skill's value is its **knowledge delta** — the gap between what it provides and what the model already knows.

### Three Types of Knowledge

| Type | Definition | Treatment |
|------|------------|-----------|  
| **Expert** | Claude genuinely doesn't know this | Must keep — this is the Skill's value |
| **Activation** | Claude knows but may not think of | Keep if brief — serves as reminder |
| **Redundant** | Claude definitely knows this | Delete — wastes tokens |

---

## Evaluation Dimensions (120 points total)

### D1: Knowledge Delta (20 pts) — THE CORE DIMENSION

| Score | Criteria |
|-------|----------|
| 0-5 | Explains basics Claude knows |
| 6-10 | Mixed: some expert knowledge diluted by obvious content |
| 11-15 | Mostly expert knowledge with minimal redundancy |
| 16-20 | Pure knowledge delta — every paragraph earns its tokens |

**Red flags** (instant score ≤5): "What is X" sections, step-by-step tutorials for standard ops, generic best practices.

**Green flags**: Decision trees for non-obvious choices, trade-offs only experts know, edge cases from real-world experience.

### D2: Mindset + Appropriate Procedures (15 pts)

Experts have **thinking patterns** + **domain-specific procedural knowledge**.

| Score | Criteria |
|-------|----------|
| 0-3 | Only generic procedures Claude already knows |
| 4-7 | Has domain procedures but lacks thinking frameworks |
| 8-11 | Good balance: thinking patterns + domain-specific workflows |
| 12-15 | Expert-level: shapes thinking AND provides non-obvious procedures |

### D3: Anti-Pattern Quality (15 pts)

Half of expert knowledge is knowing what NOT to do.

| Score | Criteria |
|-------|----------|
| 0-3 | No anti-patterns mentioned |
| 4-7 | Generic warnings ("avoid errors", "be careful") |
| 8-11 | Specific NEVER list with some reasoning |
| 12-15 | Expert-grade anti-patterns with WHY — things only experience teaches |

### D4: Specification Compliance — especially Description (15 pts)

**Description is THE MOST CRITICAL FIELD.** Agent only sees descriptions before deciding to load a skill.

Description must answer THREE questions:
1. **WHAT**: What does this Skill do?
2. **WHEN**: In what situations should it be used?
3. **KEYWORDS**: What terms should trigger this Skill?

| Score | Criteria |
|-------|----------|
| 0-5 | Missing frontmatter or invalid format |
| 6-10 | Has frontmatter but description is vague or incomplete |
| 11-13 | Valid frontmatter, description has WHAT but weak on WHEN |
| 14-15 | Perfect: comprehensive description with WHAT, WHEN, and trigger keywords |

**Description checklist:**
- [ ] Lists specific capabilities (not just "helps with X")
- [ ] Includes explicit trigger scenarios ("Use when...", "When user asks for...")
- [ ] Contains searchable keywords (file extensions, domain terms, action verbs)
- [ ] Includes scenarios where skill MUST be used

### D5: Progressive Disclosure (15 pts)

Three-layer loading system:
```
Layer 1: Metadata (always in memory) — name + description, ~100 tokens
Layer 2: SKILL.md body (loaded after triggering) — ideal < 500 lines
Layer 3: Resources (loaded on demand) — unlimited
```

| Score | Criteria |
|-------|----------|
| 0-5 | Everything in SKILL.md (>500 lines, no structure) |
| 6-10 | Has references but unclear when to load them |
| 11-13 | Good layering with explicit load triggers |
| 14-15 | Decision trees + "MANDATORY" triggers + "Do NOT Load" guidance |

### D6: Freedom Calibration (15 pts)

Match freedom level to task fragility:

| Task Type | Should Have | Example |
|-----------|-------------|--------|
| Creative/Design | High freedom | frontend-design |
| Code review | Medium freedom | code-review |
| File format operations | Low freedom | docx, xlsx |

### D7: Pattern Recognition (10 pts)

5 main design patterns from 17 official Skills:

| Pattern | ~Lines | Use when |
|---------|--------|----------|
| **Mindset** | ~50 | Creative tasks requiring taste |
| **Navigation** | ~30 | Multiple distinct scenarios |
| **Philosophy** | ~150 | Art/creation requiring originality |
| **Process** | ~200 | Complex multi-step projects |
| **Tool** | ~300 | Precise operations on specific formats |

### D8: Practical Usability (15 pts)

| Score | Criteria |
|-------|----------|
| 0-5 | Confusing, incomplete, contradictory |
| 6-10 | Usable but with noticeable gaps |
| 11-13 | Clear guidance for common cases |
| 14-15 | Comprehensive including edge cases and fallbacks |

---

## Grade Scale

| Grade | Score | Meaning |
|-------|-------|---------|
| A | 108+ (90%+) | Excellent — production-ready |
| B | 96-107 (80-89%) | Good — minor improvements needed |
| C | 84-95 (70-79%) | Adequate — clear improvement path |
| D | 72-83 (60-69%) | Below average — significant issues |
| F | <72 (<60%) | Poor — needs fundamental redesign |

---

## Evaluation Protocol

### Step 1: Knowledge Delta Scan
For each section ask: "Does Claude already know this?"
Mark as [E]xpert, [A]ctivation, or [R]edundant.
Good ratio: >70% Expert, <20% Activation, <10% Redundant.

### Step 2: Structure Analysis
- Valid frontmatter?
- Total lines in SKILL.md?
- Reference files and sizes?
- Which pattern does it follow?
- Loading triggers present?

### Step 3: Score Each Dimension
For each dimension: quote evidence → assign score → note improvements.

### Step 4: Generate Report

```markdown
# Skill Evaluation Report: [Skill Name]

## Summary
- **Total Score**: X/120 (X%)
- **Grade**: [A/B/C/D/F]
- **Pattern**: [Mindset/Navigation/Philosophy/Process/Tool]
- **Knowledge Ratio**: E:A:R = X:Y:Z
- **Verdict**: [One sentence]

## Dimension Scores

| Dimension | Score | Max |
|-----------|-------|-----|
| D1: Knowledge Delta | X | 20 |
| D2: Mindset + Procedures | X | 15 |
| D3: Anti-Pattern Quality | X | 15 |
| D4: Specification Compliance | X | 15 |
| D5: Progressive Disclosure | X | 15 |
| D6: Freedom Calibration | X | 15 |
| D7: Pattern Recognition | X | 10 |
| D8: Practical Usability | X | 15 |

## Top 3 Improvements
1. [Highest impact]
2. [Second priority]
3. [Third priority]
```

---

## Common Failure Patterns

| Pattern | Symptom | Fix |
|---------|---------|-----|
| The Tutorial | Explains what PDF is, how Python works | Delete basics. Focus on expert decisions. |
| The Dump | SKILL.md is 800+ lines | Core in SKILL.md (<300), details in references/ |
| Orphan References | References exist but never load | Add "MANDATORY — READ" triggers in workflow |
| The Checkbox | Step 1, Step 2... mechanical procedures | Transform to "Before X, ask yourself..." |
| The Invisible Skill | Great content, rarely triggered | Fix description: WHAT + WHEN + KEYWORDS |
| Wrong Location | "When to use" in body, not description | Move ALL triggering info to description field |

---

## NEVER When Evaluating

- Give high scores just because it "looks professional"
- Let length impress you — a 43-line skill can beat a 500-line skill
- Forgive explaining basics with "it provides helpful context"
- Overlook missing anti-patterns
- Undervalue the description field — poor description = skill never gets used
- Put "when to use" info only in the body

## The Meta-Question

> **"Would an expert in this domain say: 'Yes, this captures knowledge that took me years to learn'?"**

If yes → the Skill has genuine value. If no → it's compressing what Claude already knows.
