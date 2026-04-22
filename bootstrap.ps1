# ============================================================
# bootstrap.ps1 — Wife's Fresh PC Setup
# Run this by pasting into any PowerShell window.
# Sets up: Node.js, Git, Python 3.10, Claude Desktop, Desktop Commander MCP
# ============================================================

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AI Ecosystem Bootstrap (Esposa)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ── Helper: run winget silently and report result ──────────────────────────
function Install-WithWinget {
    param([string]$PackageId, [string]$FriendlyName)
    Write-Host "→ Checking $FriendlyName..." -NoNewline
    $check = winget list --id $PackageId -e 2>$null
    if ($check -match $PackageId) {
        Write-Host " already installed ✓" -ForegroundColor Green
    } else {
        Write-Host " installing..." -ForegroundColor Yellow
        winget install $PackageId -e --accept-source-agreements --accept-package-agreements
        Write-Host "  $FriendlyName installed ✓" -ForegroundColor Green
    }
}

# ── 1. Check winget ────────────────────────────────────────────────────────
Write-Host "[1/5] Checking prerequisites..." -ForegroundColor Cyan
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Warning "winget not found! It ships with Windows 11 / App Installer."
    Write-Warning "Please install it from the Microsoft Store (search 'App Installer') and re-run."
    exit 1
}

# ── 2. Install core tools ──────────────────────────────────────────────────
Write-Host ""
Write-Host "[2/5] Installing core tools via winget..." -ForegroundColor Cyan
Install-WithWinget "OpenJS.NodeJS.LTS"   "Node.js LTS"
Install-WithWinget "Git.Git"             "Git"
Install-WithWinget "Python.Python.3.10"  "Python 3.10"
Install-WithWinget "Anthropic.Claude"    "Claude Desktop"

# Refresh PATH so newly installed tools are available in this session
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path","User")

# ── 3. Install Desktop Commander MCP ──────────────────────────────────────
Write-Host ""
Write-Host "[3/5] Installing Desktop Commander MCP..." -ForegroundColor Cyan
try {
    npm install -g @modelcontextprotocol/server-desktop-commander
    Write-Host "  Desktop Commander MCP installed ✓" -ForegroundColor Green
} catch {
    Write-Warning "npm install failed, trying npx initialisation instead..."
    npx -y @modelcontextprotocol/server-desktop-commander --help 2>$null
}

# ── 4. Write / merge Claude Desktop config ────────────────────────────────
Write-Host ""
Write-Host "[4/5] Configuring Claude Desktop (MCP servers)..." -ForegroundColor Cyan
$configDir  = "$env:APPDATA\Claude"
$configFile = "$configDir\claude_desktop_config.json"

$desktopCommanderEntry = @{
    command = "npx"
    args    = @("-y", "@modelcontextprotocol/server-desktop-commander")
}

if (-not (Test-Path $configDir)) {
    New-Item -ItemType Directory -Path $configDir -Force | Out-Null
}

if (Test-Path $configFile) {
    Write-Host "  Config file exists — merging desktop-commander entry..."
    try {
        $existing = Get-Content $configFile -Raw | ConvertFrom-Json
        if (-not $existing.mcpServers) {
            $existing | Add-Member -NotePropertyName "mcpServers" -NotePropertyValue ([PSCustomObject]@{})
        }
        if (-not $existing.mcpServers.'desktop-commander') {
            $existing.mcpServers | Add-Member -NotePropertyName "desktop-commander" `
                -NotePropertyValue ([PSCustomObject]$desktopCommanderEntry)
            $existing | ConvertTo-Json -Depth 10 | Set-Content $configFile -Encoding UTF8
            Write-Host "  desktop-commander entry added to existing config ✓" -ForegroundColor Green
        } else {
            Write-Host "  desktop-commander already in config ✓" -ForegroundColor Green
        }
    } catch {
        Write-Warning "Could not parse existing config. Creating backup and overwriting."
        Copy-Item $configFile "$configFile.bak"
        $newConfig = @{ mcpServers = @{ "desktop-commander" = $desktopCommanderEntry } }
        $newConfig | ConvertTo-Json -Depth 10 | Set-Content $configFile -Encoding UTF8
    }
} else {
    $newConfig = @{ mcpServers = @{ "desktop-commander" = $desktopCommanderEntry } }
    $newConfig | ConvertTo-Json -Depth 10 | Set-Content $configFile -Encoding UTF8
    Write-Host "  Claude Desktop config created ✓" -ForegroundColor Green
}

# ── 5. Clone / pull ai-ecosystem-esposa repo ──────────────────────────────
Write-Host ""
Write-Host "[5/5] Syncing ai-ecosystem-esposa repo..." -ForegroundColor Cyan
$repoUrl  = "https://github.com/danielcadosch/ai-ecosystem-esposa.git"
$repoPath = "$env:USERPROFILE\Documents\ai-ecosystem-esposa"

if (Test-Path "$repoPath\.git") {
    Write-Host "  Repo already cloned — pulling latest..."
    git -C $repoPath pull
} else {
    Write-Host "  Cloning repo to $repoPath..."
    git clone $repoUrl $repoPath
}
Write-Host "  Repo ready ✓" -ForegroundColor Green

# ── Done ───────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  ✅  Bootstrap complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Restart Claude Desktop completely (quit from system tray, reopen)"
Write-Host "  2. Open Cowork"
Write-Host "  3. Tell Claude:"
Write-Host '     "Termina el setup desde C:\Users\<tu-usuario>\Documents\ai-ecosystem-esposa\install.ps1"'
Write-Host ""
