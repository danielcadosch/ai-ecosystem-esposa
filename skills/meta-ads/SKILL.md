# Meta Ads — Campañas Facebook e Instagram

## Cuándo usar
- "campañas", "ads", "anuncios de Facebook/Instagram"
- "cómo están rindiendo los ads", "métricas de campañas"
- "crea una campaña", "pausa el ad set"

## Flujo recomendado: siempre leer antes de escribir

### 1. Ver cuentas publicitarias
```
mcp__c24bc423__ads_get_ad_accounts({})
```

### 2. Ver estructura de campañas
```
mcp__c24bc423__ads_get_ad_entities({
  adAccountId: "act_<id>",
  level: "campaign"  // "campaign" | "adset" | "ad"
})
```

### 3. Ver métricas de rendimiento
```
mcp__c24bc423__ads_insights_performance_trend({
  adAccountId: "act_<id>",
  datePreset: "last_7d",  // "last_7d" | "last_30d" | "this_month"
  level: "campaign"
})
```

### 4. Detectar anomalías
```
mcp__c24bc423__ads_insights_anomaly_signal({
  adAccountId: "act_<id>",
  metric: "spend"
})
```

## Crear una campaña (flujo completo)
```
# Paso 1: Crear campaña
mcp__c24bc423__ads_create_campaign({
  adAccountId: "act_<id>",
  name: "Nombre campaña",
  objective: "OUTCOME_TRAFFIC",
  status: "PAUSED"  // siempre empezar en PAUSED
})

# Paso 2: Crear ad set
mcp__c24bc423__ads_create_ad_set({ ... })

# Paso 3: Crear creativo
mcp__c24bc423__ads_create_creative({ ... })

# Paso 4: Crear ad
mcp__c24bc423__ads_create_ad({ ... })

# Paso 5: Activar (solo si Daniel confirma)
mcp__c24bc423__ads_activate_entity({ ... })
```

## Buenas prácticas
- **Siempre crear en estado `PAUSED`** — activar solo con confirmación explícita
- Verificar el `adAccountId` correcto antes de crear cualquier entidad
- Ante presupuestos o cambios de targeting: mostrar resumen y pedir confirmación
