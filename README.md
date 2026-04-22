# AI Ecosystem — Setup para ocp316@gmail.com

Repositorio de configuración del ecosistema AI para replicar en cualquier PC Windows nuevo.

## Herramientas incluidas

| Herramienta | Plan | Descripción |
|---|---|---|
| **Claude Desktop** | Claude Pro | App principal con MCPs configurados |
| **Desktop Commander** | Incluido | Control de archivos y terminal desde Claude |
| **Perplexity MCP** | Perplexity Pro | Búsqueda web avanzada desde Claude |
| **Antigravity** | Gemini Pro | Agente Gemini para tareas paralelas |
| **Comet** | Perplexity Pro | Agente de navegación web autónoma |
| **Open Interpreter** | Gratis | Ejecutor autónomo de código Python en la PC |
| **Ollama** | Gratis | Servidor local de LLMs |

> **Nota:** Este setup NO incluye Codex CLI / ChatGPT.

## Estructura del repositorio

```
ai-ecosystem-esposa/
├── install.ps1                          <- Script de instalación
├── README.md                            <- Este archivo
├── configs/
│   ├── claude_desktop_config.json       <- MCPs de Claude Desktop
│   ├── settings.json                    <- Configuración de Claude Code
│   └── open-interpreter/
│       └── config.yaml                  <- Perfil Ollama por defecto
└── skills/
    ├── comet-browser/SKILL.md           <- Navegación web con Comet
    ├── open-interpreter/SKILL.md        <- Ejecución de código
    ├── antigravity/SKILL.md             <- Agente Gemini paralelo
    └── notebooklm/SKILL.md              <- Consulta de documentos
```

## Instalación en PC nuevo

### Prerrequisitos
- Windows 10/11
- PowerShell 5.1+
- Python 3.10+ instalado

### Pasos

1. **Clonar el repositorio**
   ```powershell
   git clone https://github.com/ocp316/ai-ecosystem.git
   cd ai-ecosystem
   ```

2. **Permitir ejecución de scripts** (como Administrador)
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   ```

3. **Ejecutar el instalador**
   ```powershell
   .\install.ps1
   ```

4. **Agregar tu Perplexity API key** en:
   ```
   %APPDATA%\Claude\claude_desktop_config.json
   ```
   Reemplaza `TU_API_KEY_AQUI` con tu key real.

5. **Reiniciar Claude Desktop** para que carguen los MCPs.

## Pasos manuales

**Ollama**
- Descargar desde https://ollama.com e instalar
- Luego: `ollama pull dolphin-mistral`

**LM Studio** (opcional)
- Descargar desde https://lmstudio.ai

## Seguridad

- El archivo `configs/claude_desktop_config.json` usa el placeholder `TU_API_KEY_AQUI`
- **Nunca hagas commit de API keys reales**

---
*Setup preparado por Daniel — Abril 2026*
