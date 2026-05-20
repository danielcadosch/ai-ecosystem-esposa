# Ollama Local — Inferencia LLM sin costo ni internet

## Descripción
Usa el servidor Ollama local (localhost:11434) para ejecutar modelos de lenguaje en la PC
sin gastar tokens de Claude ni Perplexity, y sin necesidad de conexión a internet.
Disponible como MCP en Claude Desktop y como backend de Open Interpreter.

## Cuándo usar (triggers)
- "usa un modelo local", "sin gastar tokens", "offline"
- Tareas repetitivas de generación de texto donde el costo importa
- Datos sensibles que no deben salir de la PC
- Generación en masa (muchos archivos, muchos ítems)
- Backend para Open Interpreter cuando procesa scripts largos

## Modelos disponibles (instalar con `ollama pull <modelo>`)

| Modelo | RAM aprox. | Uso ideal |
|---|---|---|
| `dolphin-mistral` | ~5 GB | Default general, sin restricciones de contenido |
| `dolphin-llama3:8b` | ~5 GB | Mejor razonamiento, instrucciones complejas |
| `qwen2.5:7b` | ~5 GB | Código Python, bash, scripts |
| `qwen2.5vl:7b` | ~5 GB | Visión: analizar imágenes y screenshots |
| `gemma2:9b` | ~6 GB | Redacción, análisis de texto |

## Pasos — vía MCP de Claude Desktop
1. Verificar que Ollama está corriendo: `ollama list` en terminal
2. Llamar `mcp__ollama__generate` o `mcp__ollama__chat` con el modelo deseado
3. Presentar resultado al usuario

## Pasos — vía Open Interpreter (para código)
Usar la skill `open-interpreter` con perfil Ollama por defecto.
El perfil en `configs/open-interpreter/config.yaml` usa `dolphin-mistral` automáticamente.

## Pasos — arrancar Ollama si está apagado
```powershell
# Desde terminal en la PC del usuario:
ollama serve          # inicia el servidor en :11434
ollama pull <modelo>  # si el modelo no está descargado aún
```

## Notas
- Ollama corre en segundo plano al iniciar Windows (si se instaló el servicio)
- Los modelos se guardan en `%USERPROFILE%\.ollama\models` (~5-15 GB cada uno)
- Si hay errores de conexión: verificar que Ollama está corriendo en localhost:11434
