# Gmail — Búsqueda y redacción de emails

## Cuándo usar
- "busca el email de", "encontrá el mail sobre"
- "redacta un mail", "escribe una respuesta"
- "etiqueta esta conversación", "archiva esto"

## IMPORTANTE — Nunca enviar sin confirmación explícita
Usar siempre `create_draft`. Mostrar el borrador al usuario y esperar su OK antes de cualquier envío.

## Tools disponibles

### Buscar emails (soporta operadores Gmail)
```
mcp__775a5ef3__search_threads({
  query: "from:ejemplo@gmail.com subject:factura after:2026/01/01",
  maxResults: 10
})
```
Operadores útiles: `from:`, `to:`, `subject:`, `after:`, `before:`, `has:attachment`, `label:`, `is:unread`

### Leer una conversación completa
```
mcp__775a5ef3__get_thread({ threadId: "<id>" })
```

### Crear borrador
```
mcp__775a5ef3__create_draft({
  to: ["destinatario@ejemplo.com"],
  subject: "Asunto",
  body: "Cuerpo del email",
  cc: [],
  replyToThreadId: "<id>"  // solo si es una respuesta
})
```

### Ver etiquetas y etiquetar
```
mcp__775a5ef3__list_labels({})
mcp__775a5ef3__label_thread({ threadId: "<id>", labelIds: ["<labelId>"] })
```

## Buenas prácticas
- Siempre leer el thread completo antes de redactar una respuesta
- Mostrar el borrador formateado al usuario antes de confirmar envío
- Para búsquedas amplias: empezar con pocos resultados (`maxResults: 5`) y refinar
