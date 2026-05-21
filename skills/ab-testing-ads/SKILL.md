# A/B Testing de Ads — Crear y comparar variantes

## Descripción
Sistematiza la creación de variantes de anuncios en Meta Ads para identificar
qué copy, imagen o audiencia genera mejores resultados.

## Cuándo usar (triggers)
- "testea este ad", "A/B test", "prueba variantes"
- "cuál copy funciona mejor", "testear audiencias"
- "crear versiones del anuncio"

## Qué testear (una variable a la vez)
| Variable | Ejemplos |
|---|---|
| **Copy** | Distintos ángulos: beneficio vs. problema vs. curiosidad |
| **Headline** | Pregunta vs. afirmación vs. número |
| **CTA** | "Comprar ahora" vs. "Ver más" vs. "Obtener descuento" |
| **Audiencia** | Interés A vs. Interés B vs. Lookalike |
| **Formato** | Imagen única vs. carrusel vs. video |

## Proceso estándar

### 1. Definir el test
Preguntar a Daniel:
- ¿Qué variable testear?
- ¿Cuánto presupuesto por variante?
- ¿Cuántos días dura el test?
- ¿Cuál es la métrica de éxito? (CPL, CTR, ROAS)

### 2. Crear las variantes
Crear un ad set por variante (mismo presupuesto):
```
# Variante A
mcp__c24bc423__ads_create_ad_set({
  adAccountId: "act_<id>",
  campaignId: "<id>",
  name: "TEST-[variable]-A",
  dailyBudget: 1000,   // en centavos (1000 = $10)
  status: "PAUSED"
})

# Variante B
# Mismo proceso, distinto nombre: "TEST-[variable]-B"
```

### 3. Crear los ads con sus creativos
Usar skill `copy-marketing` para las variantes de texto.

### 4. Documentar el test en Drive
```
mcp__6ca765ee__create_file({
  name: "ABTest-[variable]-[fecha].md",
  content: "Hipótesis: [qué esperás]\nVariante A: [descripción]\nVariante B: [descripción]\nDuración: X días\nPresupuesto: $X/día por variante"
})
```

### 5. Activar y monitorear
- Activar ambas variantes al mismo tiempo
- Revisar resultados con skill `reportes-marketing` después de 3-5 días
- **No tocar las variantes durante el test** (invalida los resultados)

## Reglas del A/B testing
- Testear **una sola variable** a la vez
- Mínimo **3-5 días** de datos antes de sacar conclusiones
- Mínimo **1000 impresiones** por variante para que sea estadísticamente válido
- El ganador se escala; el perdedor se pausa
