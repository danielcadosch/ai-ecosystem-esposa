# CLAUDE.md — Guía de operación para Claude Code

Repositorio: **ai-ecosystem-esposa** (DanielCadosch/ai-ecosystem-esposa)
Propósito: Configuración replicable del ecosistema AI en Windows para ocp316@gmail.com

---

## Ecosistema: herramientas y roles

| Herramienta | Rol | Cuándo delegarle |
|---|---|---|
| **Claude Desktop** | Agente principal (tú) | Siempre — punto de entrada |
| **Desktop Commander** | MCP: control de archivos y terminal | Leer/escribir archivos, ejecutar comandos en la PC del usuario |
| **Perplexity MCP** | MCP: búsqueda web con citación | Búsquedas rápidas con fuentes verificadas |
| **Comet** | Agente: navegación web autónoma | Formularios, scraping, tareas que requieren clic real en el browser |
| **Open Interpreter** | Agente: ejecución de código Python/bash | Scripts en masa, organizar archivos, descargar contenido, procesar datos |
| **Antigravity** | Agente: Gemini paralelo | Tareas largas de investigación para ahorrar tokens Claude; segunda opinión |
| **NotebookLM** | MCP: consulta de documentos propios | Preguntas sobre documentos subidos por el usuario — cero tokens de contexto |
| **Ollama** | Servidor LLM local (localhost:11434) | Inferencia local sin costo; backend de Open Interpreter |

### Jerarquía de delegación (de menor a mayor autonomía)
```
Perplexity MCP  →  búsquedas simples con fuentes
Antigravity     →  investigación larga (paralela, distinto modelo)
Comet           →  navegación real en el browser
Open Interpreter →  ejecución de código/scripts en la PC
```

---

## Skills disponibles y sus triggers

| Skill | Archivo | Triggers clave |
|---|---|---|
| `comet-browser` | `skills/comet-browser/SKILL.md` | "busca en internet", "navega a", "formulario", "scraping" |
| `open-interpreter` | `skills/open-interpreter/SKILL.md` | "organiza", "renombra", "descarga", "script", "procesa CSV" |
| `antigravity` | `skills/antigravity/SKILL.md` | "usa Gemini", "tarea larga", "segunda opinión" |
| `notebooklm` | `skills/notebooklm/SKILL.md` | "busca en mis documentos", "en mi notebook" |
| `perplexity-search` | `skills/perplexity-search/SKILL.md` | "busca con fuentes", "qué dice la web sobre" |
| `ollama-local` | `skills/ollama-local/SKILL.md` | "usa modelo local", "sin API", "offline" |

---

## Estructura de archivos

```
ai-ecosystem-esposa/
├── CLAUDE.md                            ← Esta guía (leída automáticamente por Claude Code)
├── README.md                            ← Guía de usuario/instalación
├── install.ps1                          ← Instalador principal (PASO 3 del setup)
├── bootstrap.ps1                        ← Bootstrap para PC virgen (PASO 1: git, node, python, claude)
├── setup_git.ps1                        ← Inicialización de git local (solo necesario 1 vez)
├── .gitignore                           ← Protege API keys reales
├── .claude/
│   └── settings.json                    ← Permisos preaprobados para Claude Code (este repo)
├── configs/
│   ├── settings.json                    ← Configuración de Claude Code (~/.claude/settings.json)
│   ├── claude_desktop_config.json       ← MCPs de Claude Desktop (%APPDATA%\Claude\)
│   └── open-interpreter/
│       └── config.yaml                  ← Perfil Ollama de Open Interpreter
└── skills/
    ├── comet-browser/SKILL.md
    ├── open-interpreter/SKILL.md
    ├── antigravity/SKILL.md
    ├── notebooklm/SKILL.md
    ├── perplexity-search/SKILL.md       ← NUEVO
    └── ollama-local/SKILL.md            ← NUEVO
```

---

## Destinos de instalación en Windows

| Archivo fuente | Destino en Windows |
|---|---|
| `configs/claude_desktop_config.json` | `%APPDATA%\Claude\claude_desktop_config.json` |
| `configs/settings.json` | `%USERPROFILE%\.claude\settings.json` |
| `configs/open-interpreter/config.yaml` | `%USERPROFILE%\.config\open-interpreter\config.yaml` |
| `skills/*/SKILL.md` | `%USERPROFILE%\.claude\skills\*/SKILL.md` |

---

## Tareas comunes de mantenimiento

### Agregar una nueva skill
1. Crear `skills/<nombre>/SKILL.md` con la plantilla estándar.
2. El `install.ps1` la copiará automáticamente a `~/.claude/skills/` al reinstalar.
3. Documentarla en la tabla de skills de este CLAUDE.md.

### Agregar un nuevo MCP
1. Editar `configs/claude_desktop_config.json` — agregar entrada en `mcpServers`.
2. Si requiere instalación: agregar el paso correspondiente en `install.ps1`.
3. Si tiene skill asociada: crear `skills/<nombre>/SKILL.md`.

### Actualizar el repositorio en la PC
```powershell
cd $env:USERPROFILE\Documents\ai-ecosystem-esposa
git pull origin main
.\install.ps1
```

### Sincronizar cambios al repo
```powershell
git add -A
git commit -m "descripcion del cambio"
git push origin main
```

---

## Seguridad — reglas críticas

- **NUNCA** hacer commit de API keys reales. Los archivos de config usan `TU_API_KEY_AQUI`.
- El `.gitignore` bloquea `*.env` y `.env.*` — no añadir excepciones sin revisar.
- Las keys reales viven solo en la PC del usuario, nunca en el repo.
- Si accidentalmente se commitea una key: rotarla inmediatamente en el proveedor.

---

## Modelos Ollama disponibles (instalar con `ollama pull`)

| Modelo | Uso ideal |
|---|---|
| `dolphin-mistral` | Default: tareas generales, control de PC, sin restricciones |
| `dolphin-llama3:8b` | Mejor razonamiento, tareas complejas |
| `qwen2.5:7b` | Código y programación |
| `qwen2.5vl:7b` | Visión: analizar imágenes y capturas |

---

## Coordinación multi-agente

```
investigación profunda  → Antigravity (Gemini)
acción web real         → Comet (Perplexity)
ejecución de código     → Open Interpreter (Ollama local)
búsqueda con fuentes    → Perplexity MCP (directo, sin app)
documentos del usuario  → NotebookLM MCP
```

**Combos potentes:**
- `Antigravity + Open Interpreter` = investigar → ejecutar
- `Antigravity + Comet` = investigar → actuar en la web
- `Perplexity MCP + NotebookLM` = web + documentos propios
