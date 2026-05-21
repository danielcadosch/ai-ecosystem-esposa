# Brief Creativo — Instrucciones para diseñadores y creadores

## Descripción
Claude genera briefs creativos estructurados para comunicarle a diseñadores,
videomakers o agencias exactamente qué crear. El brief se guarda en Drive.

## Cuándo usar (triggers)
- "crea un brief", "instrucciones para el diseñador"
- "qué le digo al diseñador", "brief para el video"
- "necesito armar el brief de la campaña"

## Proceso estándar

### 1. Recopilar información
Preguntar a Daniel:
- ¿Qué se está creando? (imagen, video, carrusel, banner)
- ¿Para qué plataforma y formato?
- ¿Objetivo del ad? (vender, generar leads, awareness)
- ¿Producto/servicio y propuesta de valor clave?
- ¿Audiencia objetivo? (edad, intereses, dolor principal)
- ¿Hay marca gráfica? (colores, tipografía, logo)
- ¿Fecha de entrega?

### 2. Generar el brief

```markdown
# Brief Creativo — [Nombre de la campaña]
Fecha: [fecha]
Entrega: [fecha límite]

## Objetivo
[Qué debe lograr este creativo: clicks, ventas, awareness]

## Plataforma y formato
- Plataforma: [Facebook / Instagram / etc.]
- Formato: [1080x1080 / 9:16 Stories / 1200x628 / etc.]
- Tipo: [Imagen estática / Carrusel / Video / GIF]

## Audiencia
- Edad: [rango]
- Perfil: [descripción breve]
- Dolor principal: [qué problema tiene]
- Deseo: [qué quiere lograr]

## Mensaje principal
- Propuesta de valor: [en una frase]
- Headline: [texto del título]
- Copy: [texto del cuerpo]
- CTA: [botón de acción]

## Elementos visuales
- Colores: [paleta]
- Tipografía: [fuente si aplica]
- Logo: [sí/no, posición]
- Imágenes/videos: [descripción de lo que se necesita]
- Estilo: [moderno, cálido, urgente, premium, etc.]

## Ejemplos de referencia
[Links o descripciones de ads que funcionaron o gustan]

## Notas adicionales
[Restricciones, textos exactos que no pueden cambiar, etc.]
```

### 3. Guardar en Drive
```
mcp__6ca765ee__create_file({
  name: "Brief-[campaña]-[fecha].md",
  content: "[brief completo]",
  mimeType: "text/plain"
})
```

## Tips
- Incluir siempre ejemplos de referencia — reduce revisiones a la mitad
- Especificar el formato exacto en píxeles para evitar errores de tamaño
- Un brief por pieza creativa, no uno para todo
