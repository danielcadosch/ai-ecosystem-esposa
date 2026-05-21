---
name: mcp-builder
description: Guide for creating high-quality MCP (Model Context Protocol) servers that enable LLMs to interact with external services through well-designed tools. Use when building MCP servers to integrate external APIs or services, whether in Python (FastMCP) or Node/TypeScript (MCP SDK).
source: https://github.com/anthropics/skills
license: See LICENSE.txt in source repo
---

# MCP Server Development Guide

Create MCP servers that enable LLMs to interact with external services through well-designed tools.
The quality of an MCP server is measured by how well it enables LLMs to accomplish real-world tasks.

---

## Process: 4 Phases

### Phase 1: Deep Research and Planning

#### 1.1 Understand Modern MCP Design

**API Coverage vs. Workflow Tools:**
Balance comprehensive API endpoint coverage with specialized workflow tools. When uncertain, prioritize comprehensive API coverage.

**Tool Naming:** Use consistent prefixes and action-oriented naming.
Example: `github_create_issue`, `github_list_repos`

**Context Management:** Return focused, relevant data. Support pagination.

**Actionable Error Messages:** Guide agents toward solutions with specific suggestions and next steps.

#### 1.2 Study MCP Protocol Documentation

Start with: `https://modelcontextprotocol.io/sitemap.xml`
Fetch pages with `.md` suffix for markdown format.

Key pages: Specification overview, transport mechanisms, tool/resource/prompt definitions.

#### 1.3 Recommended Stack

- **Language**: TypeScript (preferred — broad usage, static typing, good linting, AI models generate it well)
- **Transport**: Streamable HTTP for remote servers (stateless JSON); stdio for local servers

Load SDK docs:
- TypeScript: `https://raw.githubusercontent.com/modelcontextprotocol/typescript-sdk/main/README.md`
- Python: `https://raw.githubusercontent.com/modelcontextprotocol/python-sdk/main/README.md`

#### 1.4 Plan Your Implementation

Prioritize comprehensive API coverage. List endpoints starting with most common operations.

---

### Phase 2: Implementation

#### 2.1 Project Structure
See SDK docs for language-specific setup (package.json, tsconfig.json, module organization).

#### 2.2 Core Infrastructure
Create shared utilities:
- API client with authentication
- Error handling helpers
- Response formatting (JSON/Markdown)
- Pagination support

#### 2.3 Implement Each Tool

**Input Schema** (Zod for TypeScript, Pydantic for Python):
- Include constraints and clear descriptions
- Add examples in field descriptions

**Output Schema:**
- Define `outputSchema` where possible
- Use `structuredContent` in responses (TypeScript SDK)

**Tool Description:** Concise summary + parameter descriptions + return type.

**Annotations:**
- `readOnlyHint`: true/false
- `destructiveHint`: true/false
- `idempotentHint`: true/false
- `openWorldHint`: true/false

**Implementation:**
- Async/await for I/O
- Proper error handling with actionable messages
- Pagination support where applicable

---

### Phase 3: Review and Test

#### 3.1 Code Quality
- No duplicated code (DRY)
- Consistent error handling
- Full type coverage
- Clear tool descriptions

#### 3.2 Build and Test

**TypeScript:**
```bash
npm run build
npx @modelcontextprotocol/inspector  # MCP Inspector
```

**Python:**
```bash
python -m py_compile your_server.py
npx @modelcontextprotocol/inspector
```

---

### Phase 4: Create Evaluations

Create 10 evaluation Q&A pairs that test LLMs can effectively use your MCP server.

**Requirements for each question:**
- Independent (not dependent on other questions)
- Read-only (non-destructive operations only)
- Complex (requires multiple tool calls)
- Realistic (based on real use cases)
- Verifiable (single, clear answer)
- Stable (answer won't change over time)

**Output format:**
```xml
<evaluation>
  <qa_pair>
    <question>Complex, realistic question requiring multiple tool calls</question>
    <answer>The specific, verifiable answer</answer>
  </qa_pair>
</evaluation>
```

---

## Design Principles

**NEVER:**
- Use vague tool descriptions ("handles stuff")
- Return massive unfiltered API dumps — filter and summarize
- Silently fail — actionable error messages always
- Mix read and write operations without clear naming
- Use inconsistent naming across related tools

**ALWAYS:**
- Prefix related tools consistently (`github_*`, `slack_*`)
- Include pagination for list operations
- Return both text and structured data when possible
- Test with MCP Inspector before shipping
