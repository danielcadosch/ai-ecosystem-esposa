# setup_git.ps1 — Ejecutar como Administrador (clic derecho > Run as Administrator)
# Inicializa el repo git de ai-ecosystem-esposa y prepara el push a GitHub

$repoPath = "C:\Users\Danie\Documents\ai-ecosystem-esposa"
$git = "C:\Program Files\Git\cmd\git.exe"

Write-Host "=== Setup Git: ai-ecosystem-esposa ===" -ForegroundColor Cyan

# 1. Tomar ownership y dar permisos completos a daniel
Write-Host "[1/5] Fijando permisos de la carpeta..." -ForegroundColor Yellow
takeown /f $repoPath /r /d y | Out-Null
icacls $repoPath /grant "daniel:(OI)(CI)F" /T | Out-Null
Write-Host "      Permisos OK" -ForegroundColor Green

# 2. Git init
Write-Host "[2/5] Inicializando git..." -ForegroundColor Yellow
Set-Location $repoPath
& $git init
& $git config user.email "ocp316@gmail.com"
& $git config user.name "esposa"

# 3. Crear .gitignore
Write-Host "[3/5] Creando .gitignore..." -ForegroundColor Yellow
@"
# Ignorar configs con API keys reales (solo subir los placeholders)
*.env
.env.*
"@ | Set-Content "$repoPath\.gitignore"

# 4. Stage y commit
Write-Host "[4/5] Haciendo commit inicial..." -ForegroundColor Yellow
& $git add -A
& $git commit -m "Initial setup: AI ecosystem for ocp316@gmail.com (Claude Pro + Perplexity Pro + Gemini Pro)"

# 5. Agregar remote y push
Write-Host "[5/5] Configurando remote..." -ForegroundColor Yellow
& $git remote add origin https://github.com/ocp316/ai-ecosystem.git

Write-Host ""
Write-Host "=== Listo para push ===" -ForegroundColor Green
Write-Host "Para hacer push, ejecuta:" -ForegroundColor Cyan
Write-Host '  git -C "C:\Users\Danie\Documents\ai-ecosystem-esposa" push -u origin master' -ForegroundColor White
Write-Host ""
Write-Host "IMPORTANTE: Necesitas un Personal Access Token de GitHub (cuenta ocp316)." -ForegroundColor Magenta
Write-Host "Cuando pida password, usa el PAT (no tu password de GitHub)." -ForegroundColor Magenta
Write-Host "Si la cuenta ocp316 no existe aun, crea el repo en github.com primero." -ForegroundColor Magenta
