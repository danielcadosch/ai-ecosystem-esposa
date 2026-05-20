# ============================================================
# install.ps1 — Instalador del Ecosistema AI (ocp316@gmail.com)
# Claude Pro + Perplexity Pro + Gemini Pro (sin Codex/ChatGPT)
# Ejecutar como Administrador en un PC Windows nuevo:
#   Set-ExecutionPolicy Bypass -Scope Process -Force
#   .\install.ps1
# ============================================================

param(
    [switch]$SkipNodeCheck,
    [switch]$SkipPython
)

$ErrorActionPreference = "Continue"
$BASE = $PSScriptRoot
$installed = @()
$skipped = @()
$failed = @()

function Log-Step { param($msg) Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Log-OK   { param($msg) Write-Host "  [OK] $msg" -ForegroundColor Green;  $script:installed += $msg }
function Log-Skip { param($msg) Write-Host "  [--] $msg (ya existe)" -ForegroundColor Yellow; $script:skipped += $msg }
function Log-Fail { param($msg) Write-Host "  [!!] $msg" -ForegroundColor Red;    $script:failed  += $msg }
function Log-Note { param($msg) Write-Host "  [i]  $msg" -ForegroundColor Magenta }

# ============================================================
# PASO 1 — Node.js
# ============================================================
Log-Step "Verificando Node.js..."
$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
    $nodeVer = node --version
    Log-Skip "Node.js $nodeVer ya instalado"
} else {
    Write-Host "  Node.js no encontrado. Instalando con winget..." -ForegroundColor Yellow
    winget install -e --id OpenJS.NodeJS --silent --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -eq 0) { Log-OK "Node.js instalado via winget" }
    else { Log-Fail "Node.js — instalar manualmente desde https://nodejs.org" }
}

# ============================================================
# PASO 2 — Python
# ============================================================
Log-Step "Verificando Python..."
$pyCmd = Get-Command python -ErrorAction SilentlyContinue
$py310Cmd = Get-Command py -ErrorAction SilentlyContinue
if ($pyCmd) {
    $pyVer = python --version
    Log-Skip "Python $pyVer ya instalado"
} elseif ($py310Cmd) {
    Log-Skip "Python Launcher (py) disponible"
} else {
    Write-Host "  Python no encontrado. Instalando Python 3.11 con winget..." -ForegroundColor Yellow
    winget install Python.Python.3.11 -e --silent --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -eq 0) { Log-OK "Python 3.11 instalado via winget" }
    else { Log-Fail "Python — instalar manualmente desde https://python.org" }
}

# ============================================================
# PASO 3 — Desktop Commander MCP
# ============================================================
Log-Step "Instalando Desktop Commander MCP..."
$dcCheck = npm list -g @wonderwhy-er/desktop-commander 2>$null
if ($dcCheck -match "desktop-commander") {
    Log-Skip "Desktop Commander ya instalado"
} else {
    npm install -g @wonderwhy-er/desktop-commander
    if ($LASTEXITCODE -eq 0) { Log-OK "Desktop Commander MCP (@wonderwhy-er/desktop-commander) instalado" }
    else { Log-Fail "Desktop Commander — verificar npm y reintentar" }
}

# ============================================================
# PASO 4 — Open Interpreter
# ============================================================
if (-not $SkipPython) {
    Log-Step "Instalando Open Interpreter..."
    $pip = Get-Command pip -ErrorAction SilentlyContinue
    $py310 = Get-Command py -ErrorAction SilentlyContinue
    if ($pip) {
        pip install open-interpreter --break-system-packages
        if ($LASTEXITCODE -eq 0) { Log-OK "open-interpreter instalado via pip" }
        else { Log-Fail "open-interpreter — revisar pip" }
    } elseif ($py310) {
        py -3.10 -m pip install open-interpreter
        if ($LASTEXITCODE -eq 0) { Log-OK "open-interpreter instalado via py -3.10" }
        else { Log-Fail "open-interpreter — revisar Python 3.10" }
    } else {
        Log-Fail "Open Interpreter — Python/pip no disponible"
    }
}

# ============================================================
# PASO 5 — Ollama
# ============================================================
Log-Step "Instalando Ollama..."
$ollama = Get-Command ollama -ErrorAction SilentlyContinue
if ($ollama) {
    Log-Skip "Ollama ya instalado"
} else {
    winget install Ollama.Ollama -e --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -eq 0) {
        Log-OK "Ollama instalado via winget"
    } else {
        Log-Fail "Ollama — instalar manualmente desde https://ollama.com"
    }
}

# Pull del modelo por defecto
Log-Step "Descargando modelo Ollama: dolphin-mistral..."
$ollamaCheck = Get-Command ollama -ErrorAction SilentlyContinue
if ($ollamaCheck) {
    ollama pull dolphin-mistral
    if ($LASTEXITCODE -eq 0) { Log-OK "Modelo dolphin-mistral descargado" }
    else { Log-Note "No se pudo descargar dolphin-mistral ahora. Ejecuta manualmente: ollama pull dolphin-mistral" }
} else {
    Log-Note "Ollama no disponible aun en PATH. Ejecuta manualmente despues: ollama pull dolphin-mistral"
}

# ============================================================
# PASO 6 — Claude Ads (skills + agents de publicidad)
# ============================================================
Log-Step "Instalando Claude Ads (AgriciDaniel/claude-ads)..."
$claudeAdsSkill = "$env:USERPROFILE\.claude\skills\ads"
if (Test-Path "$claudeAdsSkill\SKILL.md") {
    Log-Skip "Claude Ads ya instalado en $claudeAdsSkill"
} else {
    $tempDir = [System.IO.Path]::GetTempPath() + "claude-ads-" + [System.Guid]::NewGuid().ToString("N")
    git clone --depth 1 https://github.com/AgriciDaniel/claude-ads $tempDir 2>$null
    if ($LASTEXITCODE -eq 0) {
        & "$tempDir\install.ps1" -Target claude
        if ($LASTEXITCODE -eq 0) { Log-OK "Claude Ads instalado (22 sub-skills + 10 agentes)" }
        else { Log-Fail "Claude Ads — el installer interno fallo" }
        Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
    } else {
        Log-Fail "Claude Ads — no se pudo clonar https://github.com/AgriciDaniel/claude-ads"
    }
}

# ============================================================
# PASO 7 — NotebookLM MCP
# ============================================================
Log-Step "Instalando NotebookLM MCP..."
$pip = Get-Command pip -ErrorAction SilentlyContinue
$py310 = Get-Command py -ErrorAction SilentlyContinue
if ($pip) {
    pip install notebooklm-mcp --break-system-packages
    if ($LASTEXITCODE -eq 0) { Log-OK "notebooklm-mcp instalado via pip" }
    else { Log-Fail "notebooklm-mcp — revisar pip" }
} elseif ($py310) {
    py -3.10 -m pip install notebooklm-mcp
    if ($LASTEXITCODE -eq 0) { Log-OK "notebooklm-mcp instalado via py -3.10" }
    else { Log-Fail "notebooklm-mcp — revisar Python 3.10" }
} else {
    Log-Fail "notebooklm-mcp — Python/pip no disponible"
}

# ============================================================
# PASO 8 — Antigravity (solo extension de Chrome)
# ============================================================
Log-Step "Verificando Antigravity..."
Log-Note "Antigravity es una extension de Chrome, no tiene instalador CLI."
Log-Note "Instala manualmente desde: https://chromewebstore.google.com (busca 'Antigravity')"
$skipped += "Antigravity (requiere instalacion manual desde Chrome Web Store)"

# ============================================================
# PASO 9 — Copiar archivos de configuracion
# ============================================================
Log-Step "Copiando archivos de configuracion..."

# claude_desktop_config.json
$claudeDir = "$env:APPDATA\Claude"
if (-not (Test-Path $claudeDir)) { New-Item -ItemType Directory -Force -Path $claudeDir | Out-Null }
$claudeDst = "$claudeDir\claude_desktop_config.json"
if (Test-Path $claudeDst) {
    $backup = "$claudeDir\claude_desktop_config.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').json"
    Copy-Item $claudeDst $backup
    Write-Host "  [BACKUP] Config anterior guardado en $backup" -ForegroundColor Yellow
}
$claudeSrc = "$BASE\configs\claude_desktop_config.json"
if (Test-Path $claudeSrc) {
    Copy-Item $claudeSrc $claudeDst -Force
    Log-OK "claude_desktop_config.json -> $claudeDst"
} else { Log-Fail "No se encontro $claudeSrc" }

# settings.json
$claudeCodeDir = "$env:USERPROFILE\.claude"
if (-not (Test-Path $claudeCodeDir)) { New-Item -ItemType Directory -Force -Path $claudeCodeDir | Out-Null }
$settingsSrc = "$BASE\configs\settings.json"
if (Test-Path $settingsSrc) {
    Copy-Item $settingsSrc "$claudeCodeDir\settings.json" -Force
    Log-OK "settings.json -> $claudeCodeDir\settings.json"
} else { Log-Note "configs\settings.json no encontrado, omitiendo" }

# open-interpreter config
$oiDir = "$env:USERPROFILE\.config\open-interpreter"
if (-not (Test-Path $oiDir)) { New-Item -ItemType Directory -Force -Path $oiDir | Out-Null }
$oiSrc = "$BASE\configs\open-interpreter\config.yaml"
if (Test-Path $oiSrc) {
    Copy-Item $oiSrc "$oiDir\config.yaml" -Force
    Log-OK "open-interpreter config.yaml -> $oiDir\config.yaml"
} else { Log-Note "configs\open-interpreter\config.yaml no encontrado, omitiendo" }

# ============================================================
# PASO 10 — Copiar skills a ~/.claude/skills/
# ============================================================
Log-Step "Copiando skills a ~/.claude/skills/..."
$skillsDst = "$env:USERPROFILE\.claude\skills"
if (-not (Test-Path $skillsDst)) { New-Item -ItemType Directory -Force -Path $skillsDst | Out-Null }

$skillsSrc = "$BASE\skills"
if (Test-Path $skillsSrc) {
    Get-ChildItem -Path $skillsSrc -Directory | ForEach-Object {
        $dst = "$skillsDst\$($_.Name)"
        if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Force -Path $dst | Out-Null }
        Copy-Item "$($_.FullName)\*" $dst -Recurse -Force
        Log-OK "skill: $($_.Name)"
    }
} else {
    Log-Note "Carpeta skills\ no encontrada en $BASE, omitiendo"
}

# ============================================================
# RESUMEN FINAL
# ============================================================
Write-Host "`n============================================================" -ForegroundColor Magenta
Write-Host " RESUMEN DE INSTALACION" -ForegroundColor Magenta
Write-Host "============================================================" -ForegroundColor Magenta

if ($installed.Count -gt 0) {
    Write-Host "`n[OK] Instalado/copiado:" -ForegroundColor Green
    $installed | ForEach-Object { Write-Host "   - $_" }
}
if ($skipped.Count -gt 0) {
    Write-Host "`n[--] Ya existia o manual:" -ForegroundColor Yellow
    $skipped | ForEach-Object { Write-Host "   - $_" }
}
if ($failed.Count -gt 0) {
    Write-Host "`n[!!] Fallo (accion manual requerida):" -ForegroundColor Red
    $failed | ForEach-Object { Write-Host "   - $_" }
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "=== INSTALLATION COMPLETE ===" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Arms installed: Desktop Commander, Open Interpreter, Ollama, NotebookLM MCP, Claude Ads" -ForegroundColor Green
Write-Host "Skills copied to: ~/.claude/skills/" -ForegroundColor Green
Write-Host "Config copied to: %APPDATA%\Claude\claude_desktop_config.json" -ForegroundColor Green
Write-Host ""
Write-Host "NEXT STEPS:" -ForegroundColor Cyan
Write-Host "  1. Restart Claude Desktop"
Write-Host "  2. Open Cowork"
Write-Host '  3. Tell Claude: "Finaliza mi setup de AI"'
Write-Host ""
Write-Host "MANUAL STEPS REQUIRED:" -ForegroundColor Yellow
Write-Host "  - Antigravity: Install from Chrome Web Store (not available as CLI)"
Write-Host "  - NotebookLM: Run quick-setup and connect your Google account"
Write-Host "  - Perplexity API key: Add to %APPDATA%\Claude\claude_desktop_config.json"
Write-Host "  - Gemini API key: Add to %APPDATA%\Claude\claude_desktop_config.json"
Write-Host "  - Ollama model: If pull failed above, run: ollama pull dolphin-mistral"
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
