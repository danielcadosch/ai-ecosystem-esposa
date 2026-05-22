#!/bin/bash
set -euo pipefail

# Solo corre en entornos remotos (Claude Code en la web)
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

echo '{"async": true, "asyncTimeout": 300000}'

REPO_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
SKILLS_SRC="$REPO_DIR/skills"
AGENTS_SRC="$REPO_DIR/agents"
SKILLS_DST="$HOME/.claude/skills"
AGENTS_DST="$HOME/.claude/agents"

echo "[session-start] Instalando skills desde el repo..."
mkdir -p "$SKILLS_DST" "$AGENTS_DST"

# Copiar skills (idempotente: sobreescribe para mantener actualizados)
if [ -d "$SKILLS_SRC" ]; then
  for skill_dir in "$SKILLS_SRC"/*/; do
    skill_name=$(basename "$skill_dir")
    cp -r "$skill_dir" "$SKILLS_DST/$skill_name"
  done
  echo "[session-start] Skills instalados: $(ls "$SKILLS_DST" | wc -l)"
fi

# Copiar agents
if [ -d "$AGENTS_SRC" ]; then
  cp "$AGENTS_SRC"/*.md "$AGENTS_DST/"
  echo "[session-start] Agents instalados: $(ls "$AGENTS_DST"/*.md 2>/dev/null | wc -l)"
fi

# Instalar markitdown-mcp si no está
if ! command -v markitdown-mcp &>/dev/null; then
  echo "[session-start] Instalando markitdown-mcp..."
  uv tool install markitdown-mcp --quiet
  echo "[session-start] markitdown-mcp instalado"
else
  echo "[session-start] markitdown-mcp ya presente"
fi

echo "[session-start] Listo."
