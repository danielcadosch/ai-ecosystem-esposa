# bootstrap.ps1 - AI Ecosystem (Esposa) Setup
# Fully self-contained: works on a brand-new Windows 11 PC with NOTHING installed.
# Right-click -> "Run with PowerShell", or paste into an elevated PowerShell prompt.

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "   AI Ecosystem (Esposa) Bootstrap - Fresh Windows Setup        " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# --- Helper: Refresh PATH in the current session ----------------------------
function Refresh-Path {
    $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('PATH','User')
}

# --- Helper: Run git via absolute path (bypasses stale PATH entirely) -------
function RunGit($workdir, $gitargs) {
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName  = "C:\Program Files\Git\cmd\git.exe"
    $psi.Arguments = $gitargs
    $psi.WorkingDirectory = $workdir
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError  = $true
    $psi.UseShellExecute = $false
    $p   = [System.Diagnostics.Process]::Start($psi)
    $out = $p.StandardOutput.ReadToEnd()
    $err = $p.StandardError.ReadToEnd()
    $p.WaitForExit()
    return @{ out = $out; err = $err; exit = $p.ExitCode }
}

# --- Elevation notice --------------------------------------------------------
$currentPrincipal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
$isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "NOTE: Not running as Administrator. Installs will be per-user where possible." -ForegroundColor Yellow
    Write-Host "      For a cleaner system-wide install, re-run as Administrator." -ForegroundColor Yellow
    Write-Host ""
}

# --- Check that winget is available ------------------------------------------
Write-Host "Checking for winget..." -ForegroundColor Yellow
try {
    $wv = & winget --version 2>&1
    Write-Host "  winget found: $wv" -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host "ERROR: winget (App Installer) is not available on this PC." -ForegroundColor Red
    Write-Host "  - On Windows 11 it should be pre-installed. Try running Windows Update." -ForegroundColor Red
    Write-Host "  - Or install 'App Installer' from the Microsoft Store." -ForegroundColor Red
    Write-Host ""
    exit 1
}

# --- Step 1: Git (MUST be first - everything else depends on it) -------------
Write-Host ""
Write-Host "[1/4] Installing Git..." -ForegroundColor Cyan
winget install --id Git.Git -e --source winget `
    --accept-package-agreements --accept-source-agreements --silent
Refresh-Path
Write-Host "  [OK] Git installed. PATH refreshed." -ForegroundColor Green

# --- Step 2: Node.js LTS -----------------------------------------------------
Write-Host ""
Write-Host "[2/4] Installing Node.js LTS..." -ForegroundColor Cyan
winget install --id OpenJS.NodeJS.LTS -e --source winget `
    --accept-package-agreements --accept-source-agreements --silent
Refresh-Path
Write-Host "  [OK] Node.js LTS installed. PATH refreshed." -ForegroundColor Green

# --- Step 3: Python 3.10 -----------------------------------------------------
Write-Host ""
Write-Host "[3/4] Installing Python 3.10..." -ForegroundColor Cyan
winget install --id Python.Python.3.10 -e --source winget `
    --accept-package-agreements --accept-source-agreements --silent
Refresh-Path
Write-Host "  [OK] Python 3.10 installed. PATH refreshed." -ForegroundColor Green

# --- Step 4: Claude Desktop --------------------------------------------------
Write-Host ""
Write-Host "[4/4] Installing Claude Desktop..." -ForegroundColor Cyan
winget install --id Anthropic.Claude -e --source winget `
    --accept-package-agreements --accept-source-agreements --silent
Refresh-Path
Write-Host "  [OK] Claude Desktop installed. PATH refreshed." -ForegroundColor Green

# --- Clone ai-ecosystem-esposa repository ------------------------------------
Write-Host ""
Write-Host "Cloning ai-ecosystem-esposa repository..." -ForegroundColor Cyan

$targetDir = "$env:USERPROFILE\Documents\ai-ecosystem-esposa"

if (Test-Path $targetDir) {
    Write-Host "  Folder already exists - pulling latest changes..." -ForegroundColor Yellow
    $r = RunGit $targetDir "pull origin main"
    Write-Host $r.out
    if ($r.err) { Write-Host $r.err -ForegroundColor DarkGray }
    if ($r.exit -ne 0) {
        Write-Host "WARNING: git pull returned exit code $($r.exit)" -ForegroundColor Yellow
    }
} else {
    New-Item -ItemType Directory -Path "$env:USERPROFILE\Documents" -Force | Out-Null
    $r = RunGit "$env:USERPROFILE\Documents" "clone https://github.com/DanielCadosch/ai-ecosystem-esposa.git ai-ecosystem-esposa"
    Write-Host $r.out
    if ($r.err) { Write-Host $r.err -ForegroundColor DarkGray }
    if ($r.exit -ne 0) {
        Write-Host "ERROR: git clone failed (exit code $($r.exit))" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "================================================================" -ForegroundColor Green
Write-Host "  Setup complete! All tools installed and repo cloned.          " -ForegroundColor Green
Write-Host "  Repo: $env:USERPROFILE\Documents\ai-ecosystem-esposa          " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
Write-Host ""
