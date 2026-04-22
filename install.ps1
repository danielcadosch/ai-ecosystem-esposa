# install.ps1 — AI Ecosystem para ocp316@gmail.com
# Claude Pro + Perplexity Pro + Gemini Pro (sin Codex/ChatGPT)
# Ejecutar como Administrador con: Set-ExecutionPolicy Bypass -Scope Process -Force

Write-Host "=== Instalando AI Ecosystem ===" -ForegroundColor Cyan

# 1. Instalar Node.js si no está presente
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "[1/5] Instalando Node.js..." -ForegroundColor Yellow
    winget install OpenJS.NodeJS.LTS -e --silent
} else {
    Write-Host "[1/5] Node.js ya instalado: $(node --version)" -ForegroundColor Green
}

# 2. Instalar Python si no está presente
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "[2/5] Instalando Python..." -ForegroundColor Yellow
    winget install Python.Python.3.11 -e --silent
} else {
    Write-Host "[2/5] Python ya instalado: $(python --version)" -ForegroundColor Green
}

# 3. Instalar Open Interpreter
Write-Host "[3/5] Instalando Open Interpreter..." -ForegroundColor Yellow
pip install open-interpreter --upgrade

# 4. Copiar configuraciones de Claude Desktop
Write-Host "[4/5] Copiando configuraciones de Claude Desktop..." -ForegroundColor Yellow
$claudeConfigDir = "$env:APPDATA\Claude"
if (-not (Test-Path $claudeConfigDir)) { New-Item -ItemType Directory -Path $claudeConfigDir | Out-Null }

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Copy-Item "$scriptDir\configs\claude_desktop_config.json" "$claudeConfigDir\claude_desktop_config.json" -Force
Write-Host "    Recuerda reemplazar TU_API_KEY_AQUI con tu Perplexity API key real" -ForegroundColor Magenta

# 5. Copiar skills a la carpeta de Claude
Write-Host "[5/5] Copiando skills..." -ForegroundColor Yellow
$skillsDir = "$env:APPDATA\Claude\skills"
if (-not (Test-Path $skillsDir)) { New-Item -ItemType Directory -Path $skillsDir | Out-Null }
Copy-Item "$scriptDir\skills\*" $skillsDir -Recurse -Force

Write-Host ""
Write-Host "=== Instalacion completada ===" -ForegroundColor Green
Write-Host "Proximos pasos:" -ForegroundColor Cyan
Write-Host "  1. Edita %APPDATA%\Claude\claude_desktop_config.json y pon tu Perplexity API key"
Write-Host "  2. Instala Ollama desde https://ollama.com"
Write-Host "  3. Ejecuta: ollama pull dolphin-mistral"
Write-Host "  4. Reinicia Claude Desktop"
