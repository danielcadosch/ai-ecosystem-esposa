# Audiencias Meta — Gestión avanzada de audiencias

## Descripción
Crea y gestiona audiencias personalizadas y similares en Meta Ads
para maximizar la relevancia y reducir el costo por resultado.

## Cuándo usar (triggers)
- "crea una audiencia", "audiencia personalizada"
- "lookalike", "audiencia similar"
- "excluir clientes actuales", "retargeting"
- "a quién le mostramos el ad"

## Tipos de audiencias

### Custom Audience (audiencia personalizada)
Basada en datos propios:
```
mcp__c24bc423__ads_create_custom_audience({
  adAccountId: "act_<id>",
  name: "Clientes activos — Mayo 2026",
  description: "Lista de clientes que compraron en los últimos 90 días",
  subtype: "CUSTOM"
})
```

### Tipos de subtype más usados
| Subtype | Fuente de datos |
|---|---|
| `CUSTOM` | Lista de emails/teléfonos |
| `WEBSITE` | Pixel de Facebook (visitantes web) |
| `ENGAGEMENT` | Personas que interactuaron con tu página/perfil |
| `APP` | Usuarios de tu app |

### Ver audiencias existentes
```
mcp__c24bc423__ads_get_ad_account_custom_audiences({
  adAccountId: "act_<id>"
})
```

### Actualizar una audiencia (agregar/quitar usuarios)
```
mcp__c24bc423__ads_update_custom_audience_users({
  audienceId: "<id>",
  action: "ADD",   // "ADD" | "REMOVE"
  users: [{ email: "cliente@ejemplo.com" }]
})
```

## Estrategia de audiencias recomendada
```
Cold (tráfico frío)     → Intereses + Lookalike 2-5%
Warm (consideración)    → Visitantes web + Engagement
Hot (retargeting)       → Carritos abandonados + Visitantes de producto
Exclusión               → Clientes actuales (para campañas de adquisición)
```

## Buenas prácticas
- Siempre excluir clientes actuales de campañas de adquisición
- Lookalike: empezar con 1-2%, escalar a 3-5% si el volumen es bajo
- Actualizar listas de clientes cada 30 días
- Crear audiencias de exclusión de compradores recientes (30 días)
