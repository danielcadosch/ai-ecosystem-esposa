# n8n — Automatización de workflows

## Cuándo usar
- "automatiza", "crea un workflow", "cuando pase X hacer Y"
- Integraciones entre servicios (Gmail → Sheets, Webhook → Slack, etc.)
- Tareas programadas (cron), pipelines de datos

## Flujo obligatorio (en orden, NO saltear pasos)

### 1. Leer el SDK
```
mcp__6fe38136__get_sdk_reference({})
```
Si solo necesitas una sección: pasar `sections: ["guidelines"]` o `["design"]`.

### 2. Buscar nodos necesarios
```
mcp__6fe38136__search_nodes({ queries: ["gmail", "schedule trigger", "if"] })
```
Anotar los `discriminators` (resource/operation/mode) que devuelve.

### 3. Obtener tipos exactos de parámetros (CRÍTICO)
```
mcp__6fe38136__get_node_types({ nodeTypes: ["n8n-nodes-base.gmail", "n8n-nodes-base.scheduleTrigger"] })
```
NUNCA adivinar nombres de parámetros — esto genera workflows inválidos.

### 4. Escribir el código del workflow
Usar los patrones del SDK y los parámetros exactos del paso 3.

### 5. Validar
```
mcp__6fe38136__validate_workflow({ code: "<código>" })
```
Corregir errores y re-validar hasta que sea válido.

### 6. Crear
```
mcp__6fe38136__create_workflow_from_code({ code: "<código>", description: "Qué hace este workflow" })
```

### 7. Publicar (activar)
```
mcp__6fe38136__publish_workflow({ workflowId: "<id>" })
```

## Otros tools útiles
| Tool | Uso |
|---|---|
| `search_workflows` | Buscar workflows existentes |
| `get_workflow_details` | Ver detalle de un workflow |
| `update_workflow` | Modificar workflow existente |
| `execute_workflow` | Ejecutar manualmente |
| `get_execution` | Ver resultado de una ejecución |
| `archive_workflow` | Archivar (desactivar) |
