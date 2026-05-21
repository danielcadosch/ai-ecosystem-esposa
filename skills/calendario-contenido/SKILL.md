# Calendario de Contenido — Planificación editorial

## Descripción
Planifica y gestiona el calendario editorial usando Google Calendar para las fechas
y Google Drive para almacenar el plan y los contenidos.

## Cuándo usar (triggers)
- "planifica el contenido del mes", "calendario editorial"
- "qué publicar esta semana", "organiza las publicaciones"
- "agenda los posts", "plan de contenido"

## Proceso estándar

### 1. Definir el mes y objetivos
Preguntar a Daniel:
- ¿Qué mes/período planificar?
- ¿Objetivo principal? (awareness, conversión, engagement)
- ¿Productos/servicios a destacar?
- ¿Fechas especiales o lanzamientos?

### 2. Crear estructura del calendario
Distribución recomendada por semana:
```
Lunes:    Contenido educativo / valor
Miércoles: Caso de éxito / testimonio
Viernes:  Contenido de producto / oferta
```

### 3. Guardar el plan en Drive
```
mcp__6ca765ee__create_file({
  name: "Calendario-Contenido-[MES]-[AÑO].md",
  content: "[tabla del calendario]",
  mimeType: "text/plain"
})
```

### 4. Crear eventos en Calendar
Uno por publicación con:
- Título: plataforma + tipo de contenido
- Descripción: tema, copy, link al asset
```
mcp__68c285f0__create_event({
  calendarId: "primary",
  summary: "[IG] Post educativo — [tema]",
  start: { date: "2026-06-02" },
  end:   { date: "2026-06-02" },
  description: "Copy: [texto] | Asset: [link Drive]"
})
```

## Template de calendario mensual
```
| Fecha | Plataforma | Tipo | Tema | Copy | Estado |
|---|---|---|---|---|---|
| 02/06 | Instagram | Educativo | [tema] | [copy] | Pendiente |
| 04/06 | Facebook | Producto | [tema] | [copy] | Pendiente |
```

## Tipos de contenido por plataforma
| Plataforma | Mejor contenido |
|---|---|
| Instagram Feed | Visual, inspiracional, producto |
| Instagram Stories | Encuestas, detrás de escena, urgencia |
| Facebook | Artículos, videos largos, eventos |
| Email | Nurturing, ofertas, novedades |
