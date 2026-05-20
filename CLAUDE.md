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
Construir, validar y publicar workflows de automatización.

**Flujo obligatorio para crear un workflow:**
1. `get_sdk_reference` — leer patrones y guías del SDK
2. `search_nodes` — buscar nodos por servicio (ej: "gmail", "schedule")
3. `get_node_types` — obtener tipos exactos de parámetros (NO saltear este paso)
4. `validate_workflow` — validar el código antes de crear
5. `create_workflow_from_code` — crear en n8n
6. `publish_workflow` — activar

Otros tools útiles: `search_workflows`, `get_workflow_details`, `update_workflow`, `execute_workflow`, `get_execution`

### Google Calendar — `mcp__68c285f0__*`

| Tool | Uso |
|---|---|
| `list_calendars` | Ver calendarios disponibles |
| `list_events` | Listar eventos en un rango de fechas |
| `get_event` | Leer un evento específico |
| `create_event` | Crear evento |
| `update_event` | Modificar evento existente |
| `delete_event` | Eliminar evento |
| `suggest_time` | Encontrar horario disponible |
| `respond_to_event` | Aceptar/rechazar invitación |

### Gmail — `mcp__775a5ef3__*`

| Tool | Uso |
|---|---|
| `search_threads` | Buscar emails (soporta operadores Gmail) |
| `get_thread` | Leer conversación completa |
| `create_draft` | Crear borrador (NO envía automáticamente) |
| `list_labels` | Ver etiquetas disponibles |
| `label_thread` | Etiquetar conversación |
| `list_drafts` | Ver borradores existentes |

### Google Drive — `mcp__6ca765ee__*`

| Tool | Uso |
|---|---|
| `search_files` | Buscar archivos por nombre/tipo/contenido |
| `read_file_content` | Leer contenido de un archivo |
| `download_file_content` | Descargar archivo |
| `create_file` | Crear archivo nuevo |
| `get_file_metadata` | Ver metadatos (permisos, fechas, dueño) |
| `list_recent_files` | Archivos abiertos/modificados recientemente |
| `copy_file` | Copiar archivo |

### Meta Ads — `mcp__c24bc423__*`

| Tool | Uso |
|---|---|
| `ads_get_ad_accounts` | Ver cuentas publicitarias |
| `ads_get_ad_entities` | Ver campañas / ad sets / ads |
| `ads_insights_performance_trend` | Métricas de rendimiento en el tiempo |
| `ads_insights_anomaly_signal` | Detectar anomalías en métricas |
| `ads_create_campaign` | Crear campaña |
| `ads_create_ad_set` | Crear conjunto de anuncios |
| `ads_create_ad` | Crear anuncio |
| `ads_create_creative` | Crear pieza creativa |
| `ads_get_creatives` | Ver creativos existentes |
| `ads_get_ad_images` / `ads_get_ad_videos` | Assets disponibles |

---

## Skills disponibles

| Trigger | Skill |
|---|---|
| "automatiza", "crea un workflow", "n8n" | `skills/n8n/SKILL.md` |
| "sube al repo", "commitea", "PR" | `skills/github/SKILL.md` |
| "agenda", "calendario", "reunión", "evento" | `skills/google-calendar/SKILL.md` |
| "busca el email", "redacta un mail", "gmail" | `skills/gmail/SKILL.md` |
| "busca en Drive", "lee el doc", "archivo de Google" | `skills/google-drive/SKILL.md` |
| "campañas", "ads", "facebook", "instagram", "meta" | `skills/meta-ads/SKILL.md` |
| "busca en mis documentos", "en mi notebook" | `skills/notebooklm/SKILL.md` |

---

## Reglas de eficiencia

- **Lanzar agentes en paralelo** cuando las tareas son independientes.
- **GitHub**: preferir `push_files` (múltiples archivos en un commit) sobre commits individuales.
- **n8n**: NUNCA saltear `get_node_types` — los nombres de parámetros incorrectos generan workflows inválidos.
- **Gmail**: usar `create_draft` y mostrar al usuario antes de cualquier envío. No enviar sin confirmación explícita.
- **Meta Ads**: leer antes de escribir — verificar estructura de cuenta antes de crear o modificar.
- **Bash pre-aprobados**: git, ls, find, grep, cat — sin prompts de permiso.

---

## Seguridad

- **NUNCA** commitear API keys reales. Usar placeholders `TU_KEY_AQUI`.
- Si se commitea una key accidentalmente: rotarla de inmediato en el proveedor.
- Antes de cualquier acción destructiva (delete, force push): confirmar con Daniel.
