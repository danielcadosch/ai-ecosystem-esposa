# Open Interpreter — Ejecución autónoma de código en PC

## Descripción
Delega a Open Interpreter cuando la tarea requiere ejecutar código para automatizar acciones en la PC: organizar archivos, descargar contenidos, procesar datos, renombrar en masa, convertir formatos, scraping con Python, o cualquier tarea que requiera scripts.

## Cuándo usar (triggers)
- "organiza", "renombra", "mueve", "copia" archivos en masa
- "descarga", "extrae", "convierte" contenido
- "automatiza", "crea un script para"
- "procesa estos datos", "analiza este CSV/Excel"
- "descarga el video de", "extrae el audio de"
- Cualquier tarea repetitiva que se resuelve mejor con código Python/bash

## Pasos
1. ToolSearch({ query: "computer-use", max_results: 5 })
2. Redactar instrucción completa con rutas, formato esperado y condiciones
3. mcp__computer-use__write_clipboard({ text: "<instrucción>" })
4. mcp__computer-use__request_access({ applications: ["interpreter"] })
5. mcp__computer-use__open_application({ name: "interpreter" })
6. Screenshot → clic en campo → ctrl+v → Enter
7. Si pide confirmación de código: confirmar con "y" + Enter
8. Monitorear con screenshots cada 10s hasta completar (timeout 15min)
9. Reportar: tarea ejecutada, archivos afectados, estado ✅/⚠️/❌

## Modelos recomendados (Ollama local)
- dolphin-mistral:7b — rápido, sin restricciones
- dolphin-llama3:8b — mejor razonamiento
- qwen2.5:7b — excelente para código

## Casos de uso frecuentes
- Organizar archivos por tipo/fecha
- Descargar videos con yt-dlp
- Renombrar archivos en masa
- Convertir PDFs a texto
- Scraping de precios

## Perfiles disponibles
- **Por defecto** (dolphin-mistral/Ollama): `interpreter` — tareas generales, control de PC, scripts
- **Visión/imágenes** (qwen3-vl-8b/LM Studio): `interpreter --profile lmstudio-vision` — analizar capturas, imágenes
- **Texto eficiente** (gemma-4/LM Studio): `interpreter --profile lmstudio-gemma` — redacción, análisis de texto
