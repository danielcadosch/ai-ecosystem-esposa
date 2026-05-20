# Google Drive — Archivos y documentos

## Cuándo usar
- "busca en Drive", "encontrá el archivo", "abrí el doc"
- "leé el contenido de", "qué dice el documento"
- "crea un archivo en Drive"

## Tools disponibles

### Buscar archivos
```
mcp__6ca765ee__search_files({
  query: "nombre del archivo o palabras clave",
  mimeType: "application/vnd.google-apps.document"  // opcional: filtrar por tipo
})
```
Tipos útiles: `application/vnd.google-apps.document` (Docs), `application/vnd.google-apps.spreadsheet` (Sheets), `application/pdf`

### Leer contenido de un archivo
```
mcp__6ca765ee__read_file_content({ fileId: "<id>" })
```

### Ver archivos recientes
```
mcp__6ca765ee__list_recent_files({ maxResults: 10 })
```

### Crear archivo
```
mcp__6ca765ee__create_file({
  name: "nombre-archivo.txt",
  content: "contenido",
  mimeType: "text/plain",
  parentId: "<id-carpeta>"  // opcional
})
```

### Ver metadatos y permisos
```
mcp__6ca765ee__get_file_metadata({ fileId: "<id>" })
mcp__6ca765ee__get_file_permissions({ fileId: "<id>" })
```

## Buenas prácticas
- Buscar antes de crear para evitar duplicados
- `read_file_content` devuelve el texto plano — para Docs/Sheets complejos puede ser truncado
- Siempre confirmar con Daniel antes de modificar o mover archivos importantes
