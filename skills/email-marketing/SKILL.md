# Email Marketing — Campañas y secuencias de nurturing

## Descripción
Diseña y ejecuta campañas de email marketing usando Gmail MCP para borradores
y n8n para automatizar secuencias.

## Cuándo usar (triggers)
- "crea una secuencia de emails", "campaña de email"
- "email de bienvenida", "flujo de nurturing"
- "newsletter", "email de re-engagement"
- "automatiza el envío de emails"

## Tipos de campañas

### Secuencia de bienvenida (3-5 emails)
```
Email 1 (día 0): Bienvenida + promesa de valor
Email 2 (día 2): Historia/caso de éxito
Email 3 (día 5): Objeción principal resuelta
Email 4 (día 8): Oferta o siguiente paso
Email 5 (día 12): Seguimiento / urgencia
```

### Re-engagement (usuarios inactivos)
```
Email 1: "¿Sigues ahí?" — valor gratuito
Email 2: Pregunta directa sobre sus necesidades
Email 3: Última oportunidad / oferta especial
```

## Pasos con Gmail MCP
1. Redactar el copy de cada email (usar skill `copy-marketing`)
2. Crear borrador:
```
mcp__775a5ef3__create_draft({
  to: ["destinatario@ejemplo.com"],
  subject: "Asunto del email",
  body: "Cuerpo del email"
})
```
3. Mostrar borrador a Daniel para aprobación
4. **Nunca enviar sin confirmación explícita**

## Automatizar con n8n
Para secuencias automáticas usar la skill `n8n` con nodos:
- `Gmail Trigger` — disparador por nuevo lead
- `Wait` — para los delays entre emails
- `Gmail` — para el envío de cada email
- `If` — para ramificar según si abrió o no el email anterior

## KPIs a trackear
| Métrica | Benchmark bueno |
|---|---|
| Open rate | > 25% |
| Click rate | > 3% |
| Unsubscribe | < 0.5% |
| Conversión | Depende del objetivo |
