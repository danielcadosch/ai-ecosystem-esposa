# NotebookLM Skill

## What is NotebookLM?

NotebookLM is a Google AI tool that lets you query your own uploaded documents with high accuracy.
It is connected to Claude via MCP and allows deep retrieval from notebooks **without
loading any documents into Claude's context window** — zero token cost for document retrieval.

---

## When to Use NotebookLM

Use the NotebookLM MCP tools when the user asks about content from their uploaded notebooks.

**Do NOT** use NotebookLM for:
- General knowledge questions Claude can answer directly
- Tasks that require creating files, writing code, or doing math

---

## How to Use (MCP Tool Reference)

The NotebookLM MCP exposes tools under the `mcp__notebooklm__` namespace. Typical usage:

1. **Identify the right notebook** from the user's notebook directory.
2. **Call the query tool** with the notebook ID and the user's question.
3. **Return the answer** to the user, citing it came from their NotebookLM notebook.

---

## Key Benefit

**NotebookLM does the document retrieval — Claude does the reasoning.**
Notebooks worth of material are always accessible without burning context window space.
