# Comet Browser — Delegación de tareas web autónomas

## Descripción
Esta skill le enseña a Claude cómo delegar tareas de navegación web a **Perplexity Comet**, el agente de navegador autónomo. Úsala cuando la tarea requiera navegar por internet, investigar en sitios específicos, rellenar formularios, hacer seguimiento de precios, buscar información actualizada o cualquier acción en el navegador.

## Cuándo usar esta skill (triggers)
- "busca en internet", "navega a", "revisa el sitio", "investiga en la web"
- "llena el formulario", "descarga de la página", "scraping"
- "monitorea el precio de", "verifica si hay stock"
- Cualquier tarea que requiera interacción autónoma con páginas web

## Instrucciones paso a paso

### Paso 1: Cargar tools de computer-use
ToolSearch({ query: "computer-use", max_results: 30 })

### Paso 2: Pedir acceso a Comet
mcp__computer-use__request_access({ applications: ["Comet"] })

### Paso 3: Redactar instrucción para Comet
Antes de abrir Comet, redacta una instrucción clara, completa y autosuficiente.

### Paso 4: Copiar instrucción al portapapeles
mcp__computer-use__write_clipboard({ text: "<instrucción completa>" })

### Paso 5: Abrir Comet
mcp__computer-use__open_application({ name: "Comet" })
Espera 2-3 segundos y toma screenshot para verificar que abrió.

### Paso 6: Hacer clic en el campo de input
Toma screenshot, identifica el campo de texto y haz clic en él.

### Paso 7: Pegar y enviar
mcp__computer-use__key({ key: "ctrl+v" })
mcp__computer-use__key({ key: "Return" })

### Paso 8: Monitorear hasta que termine
Screenshots cada 15 segundos. Timeout: 3 minutos.

### Paso 9: Reportar al usuario
**Resultado de Comet:** [resumen]
**Acción completada:** ✅ / ⚠️ parcial / ❌ error

## Notas
- Comet opera autónomamente — no interrumpir mientras trabaja
- Usar solo para navegación real, no para búsquedas simples (esas van con WebSearch)
