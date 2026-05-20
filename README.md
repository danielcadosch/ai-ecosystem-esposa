# ai-ecosystem-esposa

Configuración de Claude Code para Daniel — optimizado para sesiones remotas y locales.

## Estructura

```
├── CLAUDE.md                     ← Leído automáticamente: MCPs, skills, reglas
├── .claude/settings.json         ← Permisos preaprobados (sin prompts)
├── configs/settings.json         ← Settings globales de Claude Code
└── skills/
    ├── github/                   ← GitHub MCP (remoto)
    ├── n8n/                      ← n8n automatización (remoto)
    ├── google-calendar/          ← Calendar MCP (remoto)
    ├── gmail/                    ← Gmail MCP (remoto)
    ├── google-drive/             ← Drive MCP (remoto)
    ├── meta-ads/                 ← Meta Ads MCP (remoto)
    ├── comet-browser/            ← Comet (local, Claude Desktop)
    ├── open-interpreter/         ← Open Interpreter (local)
    ├── antigravity/              ← Antigravity/Gemini (local)
    ├── notebooklm/               ← NotebookLM MCP (local)
    ├── perplexity-search/        ← Perplexity MCP (local)
    └── ollama-local/             ← Ollama local (local)
```

## MCPs activos en sesiones remotas
| MCP | Namespace |
|---|---|
| GitHub | `mcp__github__*` |
| n8n | `mcp__6fe38136__*` |
| Google Calendar | `mcp__68c285f0__*` |
| Gmail | `mcp__775a5ef3__*` |
| Google Drive | `mcp__6ca765ee__*` |
| Meta Ads | `mcp__c24bc423__*` |

## Instalar settings locales (Claude Desktop en Windows)
```powershell
Copy-Item configs\settings.json "$env:USERPROFILE\.claude\settings.json"
$dst = "$env:USERPROFILE\.claude\skills"
New-Item -ItemType Directory -Force -Path $dst | Out-Null
Copy-Item skills\* $dst -Recurse -Force
```
