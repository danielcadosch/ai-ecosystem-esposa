# ai-ecosystem-esposa

Configuración de Claude Code para Daniel — optimizado para sesiones remotas.

## Estructura

```
├── CLAUDE.md                     ← Leído automáticamente: MCPs, skills, reglas
├── .claude/settings.json         ← Permisos preaprobados (sin prompts)
├── configs/settings.json         ← Settings globales de Claude Code
└── skills/
    ├── github/                   ← GitHub MCP
    ├── n8n/                      ← n8n automatización
    ├── google-calendar/          ← Calendar MCP
    ├── gmail/                    ← Gmail MCP
    ├── google-drive/             ← Drive MCP
    ├── meta-ads/                 ← Meta Ads MCP
    ├── open-interpreter/         ← Ejecución de código (local)
    └── notebooklm/               ← Documentos propios (local)
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

## Instalar settings locales
```powershell
Copy-Item configs\settings.json "$env:USERPROFILE\.claude\settings.json"
$dst = "$env:USERPROFILE\.claude\skills"
New-Item -ItemType Directory -Force -Path $dst | Out-Null
Copy-Item skills\* $dst -Recurse -Force
```
