# Google Calendar — Gestión de eventos

## Cuándo usar
- "agenda una reunión", "crea un evento", "qué tengo el lunes"
- "encuentra un horario libre", "mueve la reunión"
- "acepta/rechaza la invitación"

## Tools disponibles

### Ver calendarios
```
mcp__68c285f0__list_calendars({})
```

### Listar eventos (rango de fechas)
```
mcp__68c285f0__list_events({
  calendarId: "primary",
  timeMin: "2026-05-20T00:00:00Z",
  timeMax: "2026-05-27T00:00:00Z"
})
```

### Crear evento
```
mcp__68c285f0__create_event({
  calendarId: "primary",
  summary: "Nombre del evento",
  start: { dateTime: "2026-05-21T10:00:00-03:00" },
  end:   { dateTime: "2026-05-21T11:00:00-03:00" },
  description: "Descripción opcional",
  attendees: [{ email: "invitado@ejemplo.com" }]
})
```

### Encontrar horario disponible
```
mcp__68c285f0__suggest_time({
  calendarId: "primary",
  duration: 60,
  timeMin: "2026-05-21T09:00:00-03:00",
  timeMax: "2026-05-21T18:00:00-03:00"
})
```

### Responder a una invitación
```
mcp__68c285f0__respond_to_event({
  calendarId: "primary",
  eventId: "<id>",
  response: "accepted"  // "accepted" | "declined" | "tentative"
})
```

## Buenas prácticas
- Siempre mostrar el evento creado al usuario para confirmar antes de agregar invitados
- Usar zona horaria `-03:00` (Argentina) salvo que el usuario indique otra
- Ante duda sobre el horario: usar `suggest_time` primero
