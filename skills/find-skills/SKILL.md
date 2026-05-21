---
name: find-skills
description: Discover and install agent skills from the community. Use when users ask "how do I do X", "find a skill for X", "is there a skill that can...", or want to extend Claude's capabilities. Also trigger when a task would clearly benefit from a specialized community skill.
source: https://github.com/vercel-labs/skills
---

# Find Skills

Help users discover, evaluate, and install agent skills from the community.

## When to Trigger

- "How do I do X?" → Check if a skill exists before doing it manually
- "Find a skill for X" / "Is there a skill that..."
- Any task that would clearly benefit from a community skill
- User wants to extend Claude's capabilities

## Skills CLI Reference

```bash
# Find skills interactively
npx skills find [query]

# Install a skill (global, no confirmation prompt)
npx skills add <owner/repo@skill> -g -y

# Check for updates
npx skills update

# Browse all: https://skills.sh/
```

## Discovery Process

**Step 1**: Check skills.sh leaderboard first — popular skills appear at top.

**Step 2**: Search by domain:
```bash
npx skills find "react performance"
npx skills find "PR review"
npx skills find "database migrations"
```

**Step 3**: Evaluate quality:

| Signal | Good | Caution |
|---|---|---|
| Install count | 1,000+ | < 100 |
| Source | Official org repos | Unknown authors |
| GitHub stars | 100+ | < 10 |
| Last updated | < 3 months | > 1 year |

**Step 4**: Present options with name, function, install count, command, and skills.sh link.

**Step 5**: Offer to install:
```bash
npx skills add anthropics/skills@mcp-builder -g -y
```

## Common Skill Categories

| Domain | Search terms |
|---|---|
| Web dev | "react hooks", "next.js", "tailwind" |
| Testing | "playwright", "jest", "e2e" |
| DevOps | "docker", "CI/CD", "kubernetes" |
| Code quality | "PR review", "refactoring", "audit" |
| Marketing | "copy writing", "SEO", "social media" |
| Productivity | "planning", "documentation", "meetings" |

## Fallback Strategy

1. Try alternative keywords
2. Check adjacent domains
3. If nothing exists: offer direct assistance
4. Suggest creating a custom skill: `npx skills init`
