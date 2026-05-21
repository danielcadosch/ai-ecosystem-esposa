# ============================================================
# sync.ps1 — Sincronización bidireccional PC <-> Repo
#
# Qué hace:
#   1. PULL  — Trae los últimos cambios del repo remoto
#   2. PC -> REPO — Sube skills y agents locales que no están en el repo
#   3. REPO -> PC — Baja configs, skills y agents del repo a tu PC
#   4. PUSH — Commitea y sube los cambios nuevos a GitHub
#
# Cómo correrlo:
#   Set-ExecutionPolicy Bypass -Scope Process -Force
#   .\sync.ps1
#
# Parámetros opcionales:
#   .\sync.ps1 -SoloPC     # Solo descarga repo -> PC (no sube nada)
#   .\sync.ps1 -SoloRepo   # Solo sube PC -> repo (no descarga nada)
#   .\sync.ps1 -DryRun     # Muestra qué haría sin hacer nada
# ============================================================

param(
    [switch]$SoloPC,
    [switch]$SoloRepo,
    [switch]$DryRun
)

$ErrorActionPreference = "Continue"

# ── Rutas ────────────────────────────────────────────────────
$BASE         = $PSScriptRoot
$CLAUDE_DIR   = "$env:USERPROFILE\.claude"
$APPDATA_CLAUDE = "$env:APPDATA\Claude"

$LOCAL_SKILLS = "$CLAUDE_DIR\skills"
$LOCAL_AGENTS = "$CLAUDE_DIR\agents"
$LOCAL_MCP    = "$CLAUDE_DIR\mcp.json"
$LOCAL_SET    = "$CLAUDE_DIR\settings.json"
$LOCAL_DESK   = "$APPDATA_CLAUDE\claude_desktop_config.json"

$REPO_SKILLS  = "$BASE\skills"
$REPO_AGENTS  = "$BASE\agents"
$REPO_MCP     = "$BASE\configs\mcp.json"
$REPO_SET     = "$BASE\configs\settings.json"
$REPO_DESK    = "$BASE\configs\claude_desktop_config.json"

# ── Helpers ──────────────────────────────────────────────────
$added   = [System.Collections.Generic.List[string]]::new()
$synced  = [System.Collections.Generic.List[string]]::new()
$skipped = [System.Collections.Generic.List[string]]::new()

function Log-Step  { param($m) Write-Host "`n==> $m" -ForegroundColor Cyan }
function Log-Up    { param($m) Write-Host "  [UP  ] $m" -ForegroundColor Blue;   $script:added.Add($m)   }
function Log-Down  { param($m) Write-Host "  [DOWN] $m" -ForegroundColor Green;  $script:synced.Add($m)  }
function Log-Skip  { param($m) Write-Host "  [----] $m" -ForegroundColor DarkGray; $script:skipped.Add($m) }
function Log-Dry   { param($m) Write-Host "  [DRY ] $m" -ForegroundColor Yellow  }
function Log-Warn  { param($m) Write-Host "  [WARN] $m" -ForegroundColor Yellow  }

function Backup-File {
    param($path)
    if (Test-Path $path) {
        $ts  = Get-Date -Format "yyyyMMdd_HHmmss"
        $bak = "$path.bak_$ts"
        Copy-Item $path $bak -Force
        Write-Host "  [BAK ] $path -> $bak" -ForegroundColor DarkGray
    }
}

function Ensure-Dir { param($d) if (-not (Test-Path $d)) { New-Item -ItemType Directory -Force -Path $d | Out-Null } }

# ── PASO 1: git pull ──────────────────────────────────────────
Log-Step "PASO 1 — Actualizando repo desde GitHub..."
if ($DryRun) {
    Log-Dry "git pull origin (simulado)"
} else {
    Push-Location $BASE
    git pull origin (git rev-parse --abbrev-ref HEAD) 2>&1 | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkGray }
    Pop-Location
}

# ── PASO 2: PC -> REPO (subir skills/agents locales nuevos) ───
if (-not $SoloPC) {
    Log-Step "PASO 2 — PC -> Repo: skills y agents locales nuevos..."

    Ensure-Dir $REPO_SKILLS
    Ensure-Dir $REPO_AGENTS

    # Skills: copiar carpetas locales que no existen en el repo
    if (Test-Path $LOCAL_SKILLS) {
        Get-ChildItem -Path $LOCAL_SKILLS -Directory | ForEach-Object {
            $dst = "$REPO_SKILLS\$($_.Name)"
            if (-not (Test-Path $dst)) {
                if ($DryRun) { Log-Dry "Subiría skill: $($_.Name)" }
                else {
                    Copy-Item $_.FullName $dst -Recurse -Force
                    Log-Up "skill: $($_.Name)"
                }
            } else {
                Log-Skip "skill ya en repo: $($_.Name)"
            }
        }
    } else {
        Log-Warn "No se encontró $LOCAL_SKILLS — sin skills locales que subir"
    }

    # Agents: copiar .md locales que no existen en el repo
    if (Test-Path $LOCAL_AGENTS) {
        Get-ChildItem -Path $LOCAL_AGENTS -Filter "*.md" | ForEach-Object {
            $dst = "$REPO_AGENTS\$($_.Name)"
            if (-not (Test-Path $dst)) {
                if ($DryRun) { Log-Dry "Subiría agent: $($_.Name)" }
                else {
                    Ensure-Dir $REPO_AGENTS
                    Copy-Item $_.FullName $dst -Force
                    Log-Up "agent: $($_.Name)"
                }
            } else {
                Log-Skip "agent ya en repo: $($_.Name)"
            }
        }
    } else {
        Log-Warn "No se encontró $LOCAL_AGENTS — sin agents locales que subir"
    }

    # Config files: subir si el local es más reciente que el del repo
    foreach ($pair in @(
        @{ local = $LOCAL_DESK; repo = $REPO_DESK; label = "claude_desktop_config.json" },
        @{ local = $LOCAL_MCP;  repo = $REPO_MCP;  label = "mcp.json"                  },
        @{ local = $LOCAL_SET;  repo = $REPO_SET;  label = "settings.json"             }
    )) {
        if ((Test-Path $pair.local) -and (Test-Path $pair.repo)) {
            $localTime = (Get-Item $pair.local).LastWriteTime
            $repoTime  = (Get-Item $pair.repo).LastWriteTime
            if ($localTime -gt $repoTime) {
                if ($DryRun) { Log-Dry "Subiría config (más reciente en PC): $($pair.label)" }
                else {
                    Copy-Item $pair.local $pair.repo -Force
                    Log-Up "config (PC más reciente): $($pair.label)"
                }
            } else {
                Log-Skip "config (repo más reciente): $($pair.label)"
            }
        } elseif (Test-Path $pair.local) {
            if ($DryRun) { Log-Dry "Subiría config (no existe en repo): $($pair.label)" }
            else {
                Copy-Item $pair.local $pair.repo -Force
                Log-Up "config (nuevo en repo): $($pair.label)"
            }
        }
    }
}

# ── PASO 3: REPO -> PC (instalar en el PC) ────────────────────
if (-not $SoloRepo) {
    Log-Step "PASO 3 — Repo -> PC: instalando skills, agents y configs..."

    Ensure-Dir $LOCAL_SKILLS
    Ensure-Dir $LOCAL_AGENTS
    Ensure-Dir $APPDATA_CLAUDE

    # Skills del repo -> PC
    if (Test-Path $REPO_SKILLS) {
        Get-ChildItem -Path $REPO_SKILLS -Directory | ForEach-Object {
            $dst = "$LOCAL_SKILLS\$($_.Name)"
            if ($DryRun) {
                Log-Dry "Bajaría skill: $($_.Name)"
            } else {
                Copy-Item $_.FullName $dst -Recurse -Force
                Log-Down "skill: $($_.Name)"
            }
        }
    }

    # Agents del repo -> PC
    if (Test-Path $REPO_AGENTS) {
        Get-ChildItem -Path $REPO_AGENTS -Filter "*.md" | ForEach-Object {
            if ($DryRun) {
                Log-Dry "Bajaría agent: $($_.Name)"
            } else {
                Copy-Item $_.FullName "$LOCAL_AGENTS\$($_.Name)" -Force
                Log-Down "agent: $($_.Name)"
            }
        }
    }

    # Configs del repo -> PC (con backup)
    foreach ($pair in @(
        @{ repo = $REPO_DESK; local = $LOCAL_DESK; label = "claude_desktop_config.json" },
        @{ repo = $REPO_MCP;  local = $LOCAL_MCP;  label = "mcp.json"                  },
        @{ repo = $REPO_SET;  local = $LOCAL_SET;  label = "settings.json"             }
    )) {
        if (Test-Path $pair.repo) {
            if ($DryRun) {
                Log-Dry "Bajaría config: $($pair.label)"
            } else {
                Backup-File $pair.local
                $localDir = Split-Path $pair.local
                Ensure-Dir $localDir
                Copy-Item $pair.repo $pair.local -Force
                Log-Down "config: $($pair.label)"
            }
        }
    }

    # markitdown-mcp: instalar si no está
    if (-not $DryRun) {
        $uvx = Get-Command uvx -ErrorAction SilentlyContinue
        $mmd = Get-Command markitdown-mcp -ErrorAction SilentlyContinue
        if ($uvx -and -not $mmd) {
            Log-Step "Instalando markitdown-mcp via uv..."
            uv tool install markitdown-mcp
            if ($LASTEXITCODE -eq 0) { Log-Down "markitdown-mcp instalado" }
            else { Log-Warn "markitdown-mcp: fallo uv tool install — instalar manualmente" }
        } elseif ($mmd) {
            Log-Skip "markitdown-mcp ya instalado"
        } else {
            Log-Warn "uvx no encontrado — instala uv: winget install astral-sh.uv"
        }
    }
}

# ── PASO 4: git commit + push ─────────────────────────────────
if (-not $SoloPC) {
    Log-Step "PASO 4 — Commiteando cambios en el repo..."

    Push-Location $BASE
    $status = git status --porcelain
    if ($status) {
        if ($DryRun) {
            Log-Dry "Haría commit de los siguientes cambios:"
            $status | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
        } else {
            $ts  = Get-Date -Format "yyyy-MM-dd HH:mm"
            $msg = "sync: PC -> repo [$ts] — $($added.Count) items nuevos"
            git add .
            git commit -m $msg
            $branch = git rev-parse --abbrev-ref HEAD
            git push -u origin $branch
            Write-Host "  [PUSH] $msg" -ForegroundColor Blue
        }
    } else {
        Log-Skip "Sin cambios nuevos para commitear"
    }
    Pop-Location
}

# ── RESUMEN ───────────────────────────────────────────────────
Write-Host "`n============================================================" -ForegroundColor Magenta
Write-Host " SINCRONIZACIÓN COMPLETA" -ForegroundColor Magenta
Write-Host "============================================================" -ForegroundColor Magenta

if ($added.Count -gt 0) {
    Write-Host "`n[UP  ] Subidos PC -> Repo ($($added.Count)):" -ForegroundColor Blue
    $added | ForEach-Object { Write-Host "   - $_" }
}
if ($synced.Count -gt 0) {
    Write-Host "`n[DOWN] Bajados Repo -> PC ($($synced.Count)):" -ForegroundColor Green
    $synced | ForEach-Object { Write-Host "   - $_" }
}
if ($skipped.Count -gt 0) {
    Write-Host "`n[----] Sin cambios ($($skipped.Count)):" -ForegroundColor DarkGray
    $skipped | ForEach-Object { Write-Host "   - $_" }
}

Write-Host ""
Write-Host "Reinicia Claude Desktop para aplicar los cambios de config." -ForegroundColor Yellow
Write-Host "============================================================`n" -ForegroundColor Magenta
