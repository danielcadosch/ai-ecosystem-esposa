# Perplexity Search — Búsqueda web con fuentes citadas

## Descripción
Usa el MCP de Perplexity para hacer búsquedas web directamente desde Claude sin abrir Comet.
Ideal cuando necesitas información actualizada con fuentes verificables en segundos, sin abrir una app externa.

## Cuándo usar (triggers)
- "busca con fuentes", "qué dice internet sobre"
- "precio actual de", "noticias sobre", "últimas novedades"
- "verifica si [información] es correcta"
- Preguntas factuales que Claude puede no saber (post agosto 2025)
- Cuando Perplexity Pro está activo y necesitas fuentes citadas

## Cuándo NO usar (usar Comet en su lugar)
- La tarea requiere clic real en páginas (formularios, descargas)
- Scraping de contenido específico de un sitio
- Acciones que requieren sesión iniciada

## Pasos
1. Llamar a `mcp__perplexity__search` con la consulta
2. Presentar resultado con fuentes al usuario
3. Si se necesita más detalle: usar `mcp__perplexity__search` con query refinada

## Comparativa de herramientas de búsqueda

| Herramienta | Velocidad | Fuentes | Acción web | Costo tokens |
|---|---|---|---|---|
| Perplexity MCP | Muy rápida | Sí, citadas | No | Bajo |
| Comet | Media (abre app) | Según página | Sí | Bajo |
| Antigravity | Lenta (investiga) | Síntesis | No directa | Cero (Gemini) |
| WebSearch nativo | Rápida | Básico | No | Bajo |

## Ejemplo de uso
```
Usuario: "¿Cuál es el precio actual del dólar en Argentina?"
Acción: mcp__perplexity__search({ query: "precio dólar blue Argentina hoy" })
```
