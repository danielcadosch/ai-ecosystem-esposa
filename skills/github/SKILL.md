# GitHub — Operaciones sobre el repo

## Contexto
Disponible solo en sesiones remotas. Restringido a `danielcadosch/ai-ecosystem-esposa`.

## Regla crítica
Siempre hacer ToolSearch antes de llamar cualquier tool GitHub:
```
ToolSearch({ query: "select:mcp__github__push_files,mcp__github__get_file_contents" })
```

## Operaciones frecuentes

### Leer un archivo del repo
```
mcp__github__get_file_contents({ owner: "danielcadosch", repo: "ai-ecosystem-esposa", path: "CLAUDE.md" })
```

### Subir múltiples archivos en un commit (preferido)
```
mcp__github__push_files({
  owner: "danielcadosch",
  repo: "ai-ecosystem-esposa",
  branch: "main",
  message: "descripción del cambio",
  files: [
    { path: "ruta/archivo.md", content: "contenido" }
  ]
})
```

### Ver PRs abiertos
```
mcp__github__list_pull_requests({ owner: "danielcadosch", repo: "ai-ecosystem-esposa", state: "open" })
```

### Escuchar eventos de un PR (CI, reviews)
```
mcp__github__subscribe_pr_activity({ owner: "danielcadosch", repo: "ai-ecosystem-esposa", pullNumber: 1 })
```

## Buenas prácticas
- Usar `push_files` para múltiples archivos — un solo commit es más limpio
- NUNCA hacer push a main con claves reales en los archivos
- Antes de force push o delete: confirmar con Daniel
- Branch de desarrollo: `claude/create-robust-repo-84aTU`
