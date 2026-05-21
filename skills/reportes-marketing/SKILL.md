# Reportes de Marketing — Métricas y análisis de rendimiento

## Descripción
Consolida métricas de Meta Ads y las exporta a Google Drive como reporte.
Permite tomar decisiones basadas en datos sin salir del chat.

## Cuándo usar (triggers)
- "cómo están las campañas", "reporte de ads"
- "cuánto gastamos", "métricas de la semana"
- "rendimiento de los anuncios", "CPC, CPM, ROAS"
- "genera un reporte", "resumen de marketing"

## Proceso estándar

### 1. Obtener métricas de Meta Ads
```
mcp__c24bc423__ads_insights_performance_trend({
  adAccountId: "act_<id>",
  datePreset: "last_7d",   // "last_7d" | "last_30d" | "this_month" | "last_month"
  level: "campaign"        // "campaign" | "adset" | "ad"
})
```

### 2. Detectar anomalías
```
mcp__c24bc423__ads_insights_anomaly_signal({
  adAccountId: "act_<id>",
  metric: "spend"   // "spend" | "impressions" | "clicks" | "ctr"
})
```

### 3. Analizar y resumir
Claude interpreta los datos y genera:
- Resumen ejecutivo (3-5 líneas)
- Tabla de KPIs por campaña
- Campañas con mejor y peor rendimiento
- Recomendaciones concretas

### 4. Guardar en Drive
```
mcp__6ca765ee__create_file({
  name: "Reporte-Marketing-[fecha].md",
  content: "[reporte completo]",
  mimeType: "text/plain"
})
```

## KPIs clave a incluir en el reporte
| KPI | Descripción | Benchmark referencia |
|---|---|---|
| CPM | Costo por 1000 impresiones | < $10 USD |
| CPC | Costo por clic | < $1 USD |
| CTR | % de clics sobre impresiones | > 1% |
| CPL | Costo por lead | Depende del negocio |
| ROAS | Retorno sobre inversión en ads | > 3x |
| Frecuencia | Veces que vio el ad cada persona | < 3 (evitar fatiga) |

## Cadencia recomendada
- **Semanal**: KPIs principales + anomalías
- **Mensual**: Análisis profundo + comparativa mes anterior
- **Por campaña**: Al finalizar cada campaña puntual
