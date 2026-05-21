# CLAUDE.md — Gold Standard para sesiones remotas de Claude Code

Usuario: **Daniel** (ocp316@gmail.com) · GitHub: `danielcadosch`  
Repo activo: `danielcadosch/ai-ecosystem-esposa`

---

## REGLA #1 — ToolSearch antes de llamar cualquier MCP

Todos los tools MCP son **deferred**: el schema no está cargado por defecto.  
Siempre hacer ToolSearch primero o la llamada falla con `InputValidationError`.

```
ToolSearch({ query: "select:mcp__github__push_files,mcp__github__get_file_contents" })
```

---

## MCPs disponibles en este entorno

### GitHub — `mcp__github__*`
Restringido al repo `danielcadosch/ai-ecosystem-esposa`.

| Tool | Para qué sirve |
|---|---|
| `mcp__github__get_file_contents` | Leer archivos del repo |
| `mcp__github__push_files` | Subir múltiples archivos en un commit |
| `mcp__github__create_branch` | Crear branches |
| `mcp__github__list_pull_requests` | Ver PRs abiertos |
| `mcp__github__pull_request_read` | Leer PR completo (diff, comentarios) |
| `mcp__github__add_issue_comment` | Comentar en issues/PRs |
| `mcp__github__search_code` | Buscar código en el repo |
| `mcp__github__list_commits` | Ver historial de commits |
| `mcp__github__subscribe_pr_activity` | Escuchar eventos de PR (CI, reviews) |

### n8n Workflow Automation — `mcp__6fe38136__*`

**Flujo obligatorio:** `get_sdk_reference` → `search_nodes` → `get_node_types` → `validate_workflow` → `create_workflow_from_code` → `publish_workflow`

Otros: `search_workflows`, `get_workflow_details`, `update_workflow`, `execute_workflow`, `get_execution`

### Google Calendar — `mcp__68c285f0__*`
`list_calendars`, `list_events`, `get_event`, `create_event`, `update_event`, `delete_event`, `suggest_time`, `respond_to_event`

### Gmail — `mcp__775a5ef3__*`
`search_threads`, `get_thread`, `create_draft`, `list_labels`, `label_thread`, `list_drafts`

### Google Drive — `mcp__6ca765ee__*`
`search_files`, `read_file_content`, `download_file_content`, `create_file`, `get_file_metadata`, `list_recent_files`, `copy_file`

### Meta Ads — `mcp__c24bc423__*`
`ads_get_ad_accounts`, `ads_get_ad_entities`, `ads_insights_performance_trend`, `ads_insights_anomaly_signal`, `ads_create_campaign`, `ads_create_ad_set`, `ads_create_ad`, `ads_create_creative`, `ads_get_creatives`, `ads_get_ad_images`, `ads_get_ad_videos`

---

## Skills disponibles

### Infraestructura & herramientas
| Trigger | Skill |
|---|---|
| "automatiza", "crea un workflow", "n8n" | `skills/n8n/SKILL.md` |
| "sube al repo", "commitea", "PR" | `skills/github/SKILL.md` |
| "agenda", "calendario", "reunión" | `skills/google-calendar/SKILL.md` |
| "busca el email", "redacta un mail" | `skills/gmail/SKILL.md` |
| "busca en Drive", "lee el doc" | `skills/google-drive/SKILL.md` |
| "busca en mis documentos", "notebook" | `skills/notebooklm/SKILL.md` |

### Marketing
| Trigger | Skill |
|---|---|
| "campañas", "ads", "meta", "facebook" | `skills/meta-ads/SKILL.md` |
| "escribe un copy", "headline", "anuncio" | `skills/copy-marketing/SKILL.md` |
| "campaña de email", "nurturing" | `skills/email-marketing/SKILL.md` |
| "calendario editorial", "plan de contenido" | `skills/calendario-contenido/SKILL.md` |
| "audiencia personalizada", "lookalike" | `skills/audiencias-meta/SKILL.md` |
| "reporte de ads", "métricas" | `skills/reportes-marketing/SKILL.md` |
| "A/B test", "testea variantes" | `skills/ab-testing-ads/SKILL.md` |
| "brief", "instrucciones para el diseñador" | `skills/brief-creativo/SKILL.md` |
| "Twitter/X", "grow on X", "thread" | `skills/x-twitter-growth/SKILL.md` |

### Comunidad (Claude Code ecosystem)
| Trigger | Skill | Fuente |
|---|---|---|
| "crea un MCP", "MCP server" | `skills/mcp-builder/SKILL.md` | Anthropic oficial |
| "crea una skill", "mejora esta skill" | `skills/skill-creator/SKILL.md` | Anthropic oficial |
| "evalúa esta skill", "audita el SKILL.md" | `skills/skill-judge/SKILL.md` | softaworks |
| "escribe un plan", "plan antes de implementar" | `skills/writing-plans/SKILL.md` | obra/superpowers |
| "ejecuta el plan con subagentes" | `skills/subagent-driven-development/SKILL.md` | obra/superpowers |
| "verifica antes de decir que terminó" | `skills/verification-before-completion/SKILL.md` | obra/superpowers |
| "despacha agentes en paralelo" | `skills/dispatching-parallel-agents/SKILL.md` | obra/superpowers |
| "agentation", "toolbar de feedback" | `skills/agentation/SKILL.md` | benjitaylor |
| "busca una skill", "encuentra una skill" | `skills/find-skills/SKILL.md` | vercel-labs |

---

## Reglas de eficiencia

- **Lanzar agentes en paralelo** cuando las tareas son independientes.
- **GitHub**: preferir `push_files` (múltiples archivos en un commit) sobre commits individuales.
- **n8n**: NUNCA saltear `get_node_types` — los nombres de parámetros incorrectos generan workflows inválidos.
- **Gmail**: usar `create_draft` y mostrar al usuario antes de cualquier envío. No enviar sin confirmación explícita.
- **Meta Ads**: leer antes de escribir — verificar estructura de cuenta antes de crear o modificar. Siempre crear en estado `PAUSED`.
- **Bash pre-aprobados**: git, ls, find, grep, cat — sin prompts de permiso.

---

## Seguridad

- **NUNCA** commitear API keys reales. Usar placeholders `TU_KEY_AQUI`.
- Si se commitea una key accidentalmente: rotarla de inmediato en el proveedor.
- Antes de cualquier acción destructiva (delete, force push): confirmar con Daniel.
