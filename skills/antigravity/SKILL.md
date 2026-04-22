# Antigravity — Agente autónomo Gemini para tareas de PC

## Descripción
Delega a Antigravity cuando necesites un agente basado en Gemini para ejecutar tareas sin gastar tokens de Claude/Anthropic. Ideal para tareas largas de investigación o cuando Claude ya está ocupado en otra tarea paralela.

## Cuándo usar (triggers)
- "usa Antigravity para", "que lo haga Gemini"
- Tareas largas donde quieres ahorrar tokens de Claude
- Investigación exhaustiva en paralelo
- Segunda opinión con modelo diferente

## Pasos
1. ToolSearch({ query: "computer-use", max_results: 30 })
2. Redactar instrucción autosuficiente (Antigravity no tiene contexto previo)
3. mcp__computer-use__write_clipboard({ text: "<instrucción>" })
4. mcp__computer-use__request_access({ applications: ["Antigravity"] })
5. mcp__computer-use__open_application({ name: "Antigravity" })
6. Esperar 3s → screenshot → clic en campo → ctrl+v → Enter
7. Monitorear con screenshots cada 15s (timeout 5min)
8. Capturar resultado con scroll si es largo
9. Reportar resultado al usuario

## Coordinación con el ecosistema
- Antigravity + Open Interpreter = investigación + ejecución
- Antigravity + Comet = investigación + acción web
- Para navegación: preferir Comet
