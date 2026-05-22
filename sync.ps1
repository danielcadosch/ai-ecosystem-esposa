# ============================================================
# sync.ps1 - Sincronizacion bidireccional PC <-> Repo
#
# Uso:
#   .\sync.ps1              # Sync completo (sube y baja)
#   .\sync.ps1 -SoloPC      # Solo descarga repo -> PC
#   .\sync.ps1 -SoloRepo    # Solo sube PC -> repo
#   .\sync.ps1 -DryRun      # Muestra que haria sin ejecutar
# ============================================================

param(
    [switch]$SoloPC,
    [switch]$SoloRepo,
    [switch]$DryRun
)

$ErrorActionPreference = "Continue"

# ---- Rutas -------------------------------------------------
$BASE           = $PSScriptRoot
$CLAUDE_DIR     = "$env:USERPROFILE\.claude"
$APPDATA_CLAUDE = "$env:APPDATA\Claude"

$LOCAL_SKILLS   = "$CLAUDE_DIR\skills"
$LOCAL_AGENTS   = "$CLAUDE_DIR\agents"
$LOCAL_MCP      = "$CLAUDE_DIR\mcp.json"
$LOCAL_SET      = "$CLAUDE_DIR\settings.json"
$LOCAL_DESK     = "$APPDATA_CLAUDE\claude_desktop_config.json"

$REPO_SKILLS    = "$BASE\skills"
$REPO_AGENTS    = "$BASE\agents"
$REPO_MCP       = "$BASE\configs\mcp.json"
$REPO_SET       = "$BASE\configs\settings.json"
$REPO_DESK      = "$BASE\configs\claude_desktop_config.json"

# ---- Contadores --------------------------------------------
$countUp   = 0
$countDown = 0
$logLines  = @()

# ---- Helpers -----------------------------------------------
function Step  { param($m) Write-Host "`n==> $m" -ForegroundColor Cyan }
function Up    { param($m) Write-Host "  [UP  ] $m" -ForegroundColor Blue;    $script:countUp++;   $script:logLines += "[UP] $m" }
function Down  { param($m) Write-Host "  [DOWN] $m" -ForegroundColor Green;   $script:countDown++; $script:logLines += "[DW] $m" }
function Skip  { param($m) Write-Host "  [----] $m" -ForegroundColor DarkGray }
function Dry   { param($m) Write-Host "  [DRY ] $m" -ForegroundColor Yellow }
function Warn  { param($m) Write-Host "  [WARN] $m" -ForegroundColor Yellow }

function EnsureDir {
    param($d)
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Force -Path $d | Out-Null }
}

function BackupFile {
    param($p)
    if (Test-Path $p) {
        $ts  = Get-Date -Format "yyyyMMdd_HHmmss"
        $bak = "$p.bak_$ts"
        Copy-Item $p $bak -Force
        Write-Host "  [BAK ] $bak" -ForegroundColor DarkGray
    }
}

# ============================================================
# PASO 1 - git pull
# ============================================================
Step "PASO 1 - Actualizando desde GitHub..."
if ($DryRun) {
    Dry "git pull (simulado)"
} else {
    Push-Location $BASE
    $branch = git rev-parse --abbrev-ref HEAD 2>$null
    git pull origin $branch 2>&1 | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkGray }
    Pop-Location
}

# ============================================================
# PASO 2 - PC -> Repo (subir lo que no esta en el repo)
# ============================================================
if (-not $SoloPC) {
    Step "PASO 2 - PC -> Repo: skills y agents nuevos..."

    EnsureDir $REPO_SKILLS
    EnsureDir $REPO_AGENTS

    # Skills locales que no existen en el repo
    if (Test-Path $LOCAL_SKILLS) {
        Get-ChildItem -Path $LOCAL_SKILLS -Directory | ForEach-Object {
            $dst = "$REPO_SKILLS\$($_.Name)"
            if (-not (Test-Path $dst)) {
                if ($DryRun) { Dry "Subiria skill: $($_.Name)" }
                else { Copy-Item $_.FullName $dst -Recurse -Force; Up "skill: $($_.Name)" }
            } else {
                Skip "skill ya en repo: $($_.Name)"
            }
        }
    } else {
        Warn "No se encontro $LOCAL_SKILLS"
    }

    # Agents locales que no existen en el repo
    if (Test-Path $LOCAL_AGENTS) {
        Get-ChildItem -Path $LOCAL_AGENTS -Filter "*.md" | ForEach-Object {
            $dst = "$REPO_AGENTS\$($_.Name)"
            if (-not (Test-Path $dst)) {
                if ($DryRun) { Dry "Subiria agent: $($_.Name)" }
                else { Copy-Item $_.FullName $dst -Force; Up "agent: $($_.Name)" }
            } else {
                Skip "agent ya en repo: $($_.Name)"
            }
        }
    } else {
        Warn "No se encontro $LOCAL_AGENTS"
    }

    # Configs: sube si el local es mas reciente
    $configs = @(
        @{ local = $LOCAL_DESK; repo = $REPO_DESK; label = "claude_desktop_config.json" },
        @{ local = $LOCAL_MCP;  repo = $REPO_MCP;  label = "mcp.json" },
        @{ local = $LOCAL_SET;  repo = $REPO_SET;  label = "settings.json" }
    )
    foreach ($c in $configs) {
        if (Test-Path $c.local) {
            $repoExists = Test-Path $c.repo
            $sube = $false
            if ($repoExists) {
                $localTime = (Get-Item $c.local).LastWriteTime
                $repoTime  = (Get-Item $c.repo).LastWriteTime
                if ($localTime -gt $repoTime) { $sube = $true }
            } else {
                $sube = $true
            }
            if ($sube) {
                if ($DryRun) { Dry "Subiria config: $($c.label)" }
                else { Copy-Item $c.local $c.repo -Force; Up "config: $($c.label)" }
            } else {
                Skip "config sin cambios: $($c.label)"
            }
        }
    }
}

# ============================================================
# PASO 3 - Repo -> PC (instalar en el PC)
# ============================================================
if (-not $SoloRepo) {
    Step "PASO 3 - Repo -> PC: instalando skills, agents y configs..."

    EnsureDir $LOCAL_SKILLS
    EnsureDir $LOCAL_AGENTS
    EnsureDir $APPDATA_CLAUDE

    # Skills del repo -> PC
    if (Test-Path $REPO_SKILLS) {
        Get-ChildItem -Path $REPO_SKILLS -Directory | ForEach-Object {
            $dst = "$LOCAL_SKILLS\$($_.Name)"
            if ($DryRun) { Dry "Bajaria skill: $($_.Name)" }
            else { Copy-Item $_.FullName $dst -Recurse -Force; Down "skill: $($_.Name)" }
        }
    }

    # Agents del repo -> PC
    if (Test-Path $REPO_AGENTS) {
        Get-ChildItem -Path $REPO_AGENTS -Filter "*.md" | ForEach-Object {
            if ($DryRun) { Dry "Bajaria agent: $($_.Name)" }
            else { Copy-Item $_.FullName "$LOCAL_AGENTS\$($_.Name)" -Force; Down "agent: $($_.Name)" }
        }
    }

    # Configs del repo -> PC (con backup)
    $configs2 = @(
        @{ repo = $REPO_DESK; local = $LOCAL_DESK; label = "claude_desktop_config.json" },
        @{ repo = $REPO_MCP;  local = $LOCAL_MCP;  label = "mcp.json" },
        @{ repo = $REPO_SET;  local = $LOCAL_SET;  label = "settings.json" }
    )
    foreach ($c in $configs2) {
        if (Test-Path $c.repo) {
            if ($DryRun) { Dry "Bajaria config: $($c.label)" }
            else {
                BackupFile $c.local
                EnsureDir (Split-Path $c.local)
                Copy-Item $c.repo $c.local -Force
                Down "config: $($c.label)"
            }
        }
    }

    # markitdown-mcp
    if (-not $DryRun) {
        $mmd = Get-Command markitdown-mcp -ErrorAction SilentlyContinue
        if (-not $mmd) {
            $uvx = Get-Command uvx -ErrorAction SilentlyContinue
            if ($uvx) {
                Step "Instalando markitdown-mcp..."
                uv tool install markitdown-mcp
                if ($LASTEXITCODE -eq 0) { Down "markitdown-mcp instalado" }
                else { Warn "markitdown-mcp: fallo - instalar manualmente con: uv tool install markitdown-mcp" }
            } else {
                Warn "uvx no encontrado. Instala uv: winget install astral-sh.uv"
            }
        } else {
            Skip "markitdown-mcp ya instalado"
        }
    }
}

# ============================================================
# PASO 4 - git commit + push
# ============================================================
if (-not $SoloPC) {
    Step "PASO 4 - Commiteando cambios al repo..."
    Push-Location $BASE
    $status = git status --porcelain 2>$null
    if ($status) {
        if ($DryRun) {
            Dry "Haria commit de:"
            $status | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
        } else {
            $ts     = Get-Date -Format "yyyy-MM-dd HH:mm"
            $msg    = "sync: PC -> repo [$ts] ($countUp items nuevos)"
            git add .
            git commit -m $msg
            $branch = git rev-parse --abbrev-ref HEAD 2>$null
            git push -u origin $branch
            Write-Host "  [PUSH] $msg" -ForegroundColor Blue
        }
    } else {
        Skip "Sin cambios nuevos para commitear"
    }
    Pop-Location
}

# ============================================================
# RESUMEN
# ============================================================
Write-Host ""
Write-Host "============================================================" -ForegroundColor Magenta
Write-Host " SINCRONIZACION COMPLETA" -ForegroundColor Magenta
Write-Host "============================================================" -ForegroundColor Magenta
Write-Host " Subidos  PC -> Repo : $countUp items" -ForegroundColor Blue
Write-Host " Bajados  Repo -> PC : $countDown items" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "Reinicia Claude Desktop para aplicar los cambios." -ForegroundColor Yellow
Write-Host ""
