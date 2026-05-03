# Genesyum AI Installer v1.0.0
# Public installer for Genesyum students
#
# Usage:
#   iex (irm "https://raw.githubusercontent.com/byraul93/genesyum-installer/main/install.ps1")
#
# Cere PAT student (primit prin email/Telegram de la support).
# Configurează: Node + Bun + Claude Code CLI + Shopify CLI + 8 plugins + Telegram bot opțional + 3 shortcut-uri Desktop.

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

# Config
$GENESYUM_PLUGINS_REPO = 'byraul93/genesyum-plugins'  # PRIVAT — cere PAT
$INSTALLER_VERSION     = '1.0.0'

# === UI Helpers ===

function Write-Header($text) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host " $text" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
}
function Write-Step($text) { Write-Host "-> $text" -ForegroundColor Yellow }
function Write-OK($text)   { Write-Host "[OK] $text" -ForegroundColor Green }
function Write-Warn($text) { Write-Host "[!] $text" -ForegroundColor Magenta }
function Write-Err($text)  { Write-Host "[X] $text" -ForegroundColor Red }
function Write-Info($text) { Write-Host "  $text" -ForegroundColor Gray }

function Wait-User($msg = "Apasa ENTER pentru a continua...") {
    Write-Host ""
    Write-Host $msg -ForegroundColor Cyan -NoNewline
    [void][System.Console]::ReadLine()
}

function Test-Command($cmd) {
    $null = Get-Command $cmd -ErrorAction SilentlyContinue
    return $?
}

# === Welcome ===

Clear-Host
Write-Host @"

  ===============================================

     GENESYUM AI INSTALLER v$INSTALLER_VERSION

     Mentor AI dropshipping Big 5 markets
     UK . US . CA . AU . NZ

  ===============================================

"@ -ForegroundColor Cyan

Write-Host "  Bun venit! Acest installer va configura tot ce ai nevoie."
Write-Host ""
Write-Host "  Vei avea nevoie de:"
Write-Host "    1. Token de access Genesyum (primit prin email/Telegram)"
Write-Host "    2. Optional: cont Telegram + bot (pentru access mobil)"
Write-Host ""
Write-Host "  Durata estimata: 10-15 minute" -ForegroundColor Gray
Write-Host ""

Wait-User "Apasa ENTER pentru a incepe (sau Ctrl+C pentru a anula)..."

# === Verificare sistem ===

Write-Header "1. VERIFICARE SISTEM"

if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Err "PowerShell 5.1+ necesar. Versiune actuala: $($PSVersionTable.PSVersion)"
    exit 1
}
Write-OK "PowerShell $($PSVersionTable.PSVersion)"

if (-not [System.Environment]::Is64BitOperatingSystem) {
    Write-Err "Sistem 32-bit detectat. Genesyum cere Windows 64-bit."
    exit 1
}
Write-OK "Windows 64-bit"

try {
    $null = Test-Connection -ComputerName 'github.com' -Count 1 -Quiet -ErrorAction Stop
    Write-OK "Internet activ"
} catch {
    Write-Err "Fara internet. Verifica wifi si reincearca."
    exit 1
}

# === PAT Student ===

Write-Header "2. TOKEN DE ACCESS GENESYUM"

Write-Host ""
Write-Host "  Pentru a descarca plugins-urile Genesyum, ai nevoie de un" -ForegroundColor White
Write-Host "  TOKEN primit prin email sau Telegram de la suport." -ForegroundColor White
Write-Host ""
Write-Host "  Format token: github_pat_11C..." -ForegroundColor Gray
Write-Host ""

$patSecure = Read-Host "  Lipeste token-ul aici" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($patSecure)
$pat  = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
$pat  = $pat.Trim()

if (-not ($pat -match '^github_pat_[A-Za-z0-9_]{40,}$')) {
    Write-Err "Token format invalid. Trebuie sa inceapa cu 'github_pat_'."
    Write-Info "Verifica in email/Telegram ca ai copiat tot token-ul."
    exit 1
}

Write-Step "Verific token-ul..."
try {
    $headers = @{ "Authorization" = "Bearer $pat"; "Accept" = "application/vnd.github+json" }
    $repoInfo = Invoke-RestMethod -Uri "https://api.github.com/repos/$GENESYUM_PLUGINS_REPO" -Headers $headers -ErrorAction Stop
    Write-OK "Token valid - access la $($repoInfo.full_name) confirmat"
} catch {
    Write-Err "Token invalid sau fara access la $GENESYUM_PLUGINS_REPO"
    Write-Info "Contacteaza support@genesyum.com pentru token nou."
    exit 1
}

# === Node.js ===

Write-Header "3. NODE.JS"

if (Test-Command 'node') {
    $nodeVer = (node --version 2>&1).Trim().TrimStart('v')
    $major = [int]($nodeVer.Split('.')[0])
    if ($major -ge 18) {
        Write-OK "Node.js $nodeVer (deja instalat)"
    } else {
        Write-Warn "Node.js $nodeVer prea vechi. Cere min v18."
        Start-Process 'https://nodejs.org'
        Wait-User "Instaleaza Node.js LTS, apoi inchide PowerShell, redeschide ca Admin si ruleaza din nou installer-ul."
        exit 0
    }
} else {
    Write-Step "Node.js NU detectat"
    Start-Process 'https://nodejs.org'
    Write-Info "Pe pagina deschisa, click LTS si instaleaza (accepta default-uri)."
    Wait-User "Dupa install Node.js, INCHIDE PowerShell, REDESCHIDE ca Admin si ruleaza din nou installer-ul."
    exit 0
}

# === Bun ===

Write-Header "4. BUN RUNTIME"

if (Test-Command 'bun') {
    $bunVer = (bun --version 2>&1).Trim()
    Write-OK "Bun $bunVer (deja instalat)"
} else {
    Write-Step "Instalare Bun (poate dura 30-60 sec)..."
    try {
        # Bun installer printeaza output intern; redirect la null
        $bunInstallScript = Invoke-RestMethod 'https://bun.sh/install.ps1'
        # Run intr-un scriptblock izolat ca sa nu ne afecteze sesiunea curenta
        $null = & ([scriptblock]::Create($bunInstallScript)) 2>&1

        # Refresh PATH din ambele scope (User + Machine + adauga manual Bun bin)
        $bunPath = "$env:USERPROFILE\.bun\bin"
        $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
        $userPath    = [Environment]::GetEnvironmentVariable('Path', 'User')
        $env:Path = "$bunPath;$userPath;$machinePath"

        # Re-test bun command (forteaza re-cache)
        Get-Command bun -ErrorAction SilentlyContinue | Out-Null

        if (Test-Path "$bunPath\bun.exe") {
            $bunVer = (& "$bunPath\bun.exe" --version 2>&1).Trim()
            Write-OK "Bun $bunVer instalat"
        } else {
            Write-Err "Bun NU a fost instalat (binary lipsa la $bunPath\bun.exe)"
            Write-Info "Workaround manual: ruleaza in alt PowerShell:"
            Write-Info "  irm bun.sh/install.ps1 | iex"
            Write-Info "Apoi INCHIDE TOATE ferestrele PowerShell, redeschide ca Admin si re-ruleaza installer-ul Genesyum."
            throw "Bun install incomplet"
        }
    } catch {
        Write-Err "Eroare la install Bun: $_"
        Write-Info "Pentru workaround manual, vezi mesajul de mai sus."
        throw
    }
}

# === Claude Code CLI ===

Write-Header "5. CLAUDE CODE CLI"

if (Test-Command 'claude') {
    Write-OK "Claude Code (deja instalat)"
} else {
    Write-Step "Instalare Claude Code CLI (poate dura 1-2 minute)..."
    try {
        $npmOut = npm install -g '@anthropic-ai/claude-code' 2>&1
        if (Test-Command 'claude') {
            Write-OK "Claude Code CLI instalat"
        } else {
            Write-Err "Claude Code instalat dar NU detectat"
            Write-Info $npmOut
            exit 1
        }
    } catch {
        Write-Err "Eroare npm install: $_"
        exit 1
    }
}

# === Shopify CLI ===

Write-Header "6. SHOPIFY CLI"

if (Test-Command 'shopify') {
    Write-OK "Shopify CLI (deja instalat)"
} else {
    Write-Step "Instalare Shopify CLI..."
    try {
        npm install -g '@shopify/cli@latest' 2>&1 | Out-Null
        Write-OK "Shopify CLI instalat"
    } catch {
        Write-Warn "Shopify CLI install esuat - continui (poti reinstala manual: npm install -g @shopify/cli@latest)"
    }
}

# === Backup settings.json ===

Write-Header "7. CONFIGURARE CLAUDE CODE"

$settingsPath = Join-Path $env:USERPROFILE '.claude\settings.json'
$settingsDir  = Split-Path $settingsPath
if (-not (Test-Path $settingsDir)) {
    New-Item -ItemType Directory -Force -Path $settingsDir | Out-Null
}

if (Test-Path $settingsPath) {
    $backupPath = "$settingsPath.bak.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item $settingsPath $backupPath
    Write-OK "Backup settings.json existent: $backupPath"
}

# === VS Code ===

Write-Header "8. VS CODE (canal chat opțional)"

$vsCodeInstalled = Test-Command 'code'
if ($vsCodeInstalled) {
    Write-OK "VS Code detectat"
    Write-Step "Instalare extensie Claude Code in VS Code..."
    try {
        code --install-extension 'anthropic.claude-code' --force 2>&1 | Out-Null
        Write-OK "Extensie instalata"
    } catch {
        Write-Warn "Extensie NU instalata automat - manual din VS Code Extensions"
    }
} else {
    Write-Warn "VS Code NU detectat"
    $resp = Read-Host "  Vrei sa-l instalez? (Y/n)"
    if ($resp -ne 'n' -and $resp -ne 'N') {
        Start-Process 'https://code.visualstudio.com/download'
        Write-Info "Pe pagina deschisa, click 'Windows' si instaleaza."
        Wait-User "Dupa install VS Code, apasa ENTER (poti instala extensia mai tarziu)..."
    } else {
        Write-Info "Skip VS Code"
    }
}

# === Plugins ===

Write-Header "9. PLUGINS CLAUDE CODE"

Write-Step "Adaugare marketplace Genesyum..."
try {
    claude plugin marketplace add $GENESYUM_PLUGINS_REPO --token $pat 2>&1 | Out-Null
    Write-OK "Marketplace genesyum-dev adaugat"
} catch {
    Write-Err "Eroare la add marketplace: $_"
    exit 1
}

$plugins = @(
    @{name='genesyum-core@genesyum-dev';                desc='Core onboarding'},
    @{name='genesyum-nisa@genesyum-dev';                desc='Research nisa'},
    @{name='genesyum-build-ops@genesyum-dev';           desc='Build & operations'},
    @{name='telegram@claude-plugins-official';          desc='Telegram bot bridge'},
    @{name='shopify-ai-toolkit@claude-plugins-official';desc='Shopify GraphQL'},
    @{name='playwright@claude-plugins-official';        desc='Browser automation'},
    @{name='frontend-design@claude-plugins-official';   desc='Custom design layer'},
    @{name='context7@claude-plugins-official';          desc='Live docs lookup'}
)

foreach ($p in $plugins) {
    Write-Step "Install $($p.name) - $($p.desc)"
    try {
        claude plugin install $p.name --scope user 2>&1 | Out-Null
        Write-OK "$($p.name)"
    } catch {
        Write-Warn "$($p.name) NU instalat: $_"
    }
}

# === Telegram Bot ===

Write-Header "10. TELEGRAM BOT (optional)"

$resp = Read-Host "  Vrei sa folosesti Telegram pentru access mobil? (Y/n)"
$skipTelegram = ($resp -eq 'n' -or $resp -eq 'N')

if (-not $skipTelegram) {
    Write-Host ""
    Write-Host "  PASII pentru creare bot:" -ForegroundColor Cyan
    Write-Host "  1. Deschide Telegram pe phone"
    Write-Host "  2. Cauta @BotFather (cont oficial verificat)"
    Write-Host "  3. Trimite: /newbot"
    Write-Host "  4. Numele bot-ului - orice (ex: 'GenyAR Mentor')"
    Write-Host "  5. Username - terminat in 'bot' (ex: 'genyar_tau_bot')"
    Write-Host "  6. Vei primi un TOKEN (format: 123456789:AAH...)"
    Write-Host ""
    Start-Process 'https://t.me/BotFather'

    $tgTokenSecure = Read-Host "  Lipeste TOKEN-ul Telegram aici" -AsSecureString
    $BSTR2 = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($tgTokenSecure)
    $tgToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR2)
    $tgToken = $tgToken.Trim()

    if ($tgToken -match '^\d{8,}:[A-Za-z0-9_-]{30,}$') {
        $tgDir = Join-Path $env:USERPROFILE '.claude\channels\telegram'
        if (-not (Test-Path $tgDir)) {
            New-Item -ItemType Directory -Force -Path $tgDir | Out-Null
        }
        $envPath = Join-Path $tgDir '.env'
        "TELEGRAM_BOT_TOKEN=$tgToken" | Out-File -FilePath $envPath -Encoding ascii -NoNewline
        Write-OK "Token Telegram salvat"
    } else {
        Write-Warn "Token format invalid - skip Telegram setup"
        $skipTelegram = $true
    }
}

# === settings.json ===

Write-Header "11. SETTINGS.JSON"

$settingsContent = @"
{
  "permissions": {
    "allow": [
      "Read", "Glob", "Grep", "TodoWrite", "WebFetch", "WebSearch",
      "Bash(npm install *)", "Bash(npm install -g *)",
      "Bash(node --version)", "Bash(bun --version)",
      "Bash(shopify version*)", "Bash(shopify store auth*)", "Bash(shopify store execute*)",
      "Bash(shopify theme *)",
      "Bash(claude plugin*)",
      "Bash(git status*)", "Bash(git log*)", "Bash(git diff*)",
      "Bash(ls*)", "Bash(pwd)", "Bash(cat *)", "Bash(echo *)",
      "Bash(mkdir -p *)",
      "mcp__plugin_telegram_telegram__reply",
      "mcp__plugin_telegram_telegram__react",
      "mcp__plugin_telegram_telegram__edit_message",
      "mcp__plugin_playwright_playwright__browser_navigate",
      "mcp__plugin_playwright_playwright__browser_snapshot",
      "mcp__plugin_playwright_playwright__browser_click",
      "mcp__plugin_playwright_playwright__browser_type",
      "mcp__plugin_playwright_playwright__browser_evaluate",
      "mcp__plugin_playwright_playwright__browser_take_screenshot",
      "mcp__plugin_playwright_playwright__browser_press_key",
      "mcp__plugin_playwright_playwright__browser_wait_for",
      "mcp__plugin_playwright_playwright__browser_resize",
      "mcp__plugin_playwright_playwright__browser_navigate_back",
      "mcp__plugin_playwright_playwright__browser_hover",
      "mcp__plugin_playwright_playwright__browser_fill_form",
      "mcp__plugin_playwright_playwright__browser_select_option",
      "mcp__plugin_playwright_playwright__browser_scroll",
      "mcp__plugin_playwright_playwright__browser_tabs",
      "mcp__plugin_context7_context7__query-docs",
      "mcp__plugin_context7_context7__resolve-library-id"
    ],
    "deny": [
      "Bash(rm -rf *)", "Bash(del /q *)", "Bash(format *)",
      "Bash(diskpart*)", "Bash(shutdown*)", "Bash(reg delete*)",
      "Bash(git push --force*)", "Bash(git reset --hard*)"
    ]
  },
  "enabledPlugins": {
    "telegram@claude-plugins-official": true,
    "shopify-ai-toolkit@claude-plugins-official": true,
    "playwright@claude-plugins-official": true,
    "frontend-design@claude-plugins-official": true,
    "context7@claude-plugins-official": true,
    "genesyum-core@genesyum-dev": true,
    "genesyum-nisa@genesyum-dev": true,
    "genesyum-build-ops@genesyum-dev": true
  },
  "extraKnownMarketplaces": {
    "claude-plugins-official": {
      "source": {"source": "github", "repo": "anthropics/claude-plugins-official"}
    },
    "genesyum-dev": {
      "source": {"source": "github", "repo": "$GENESYUM_PLUGINS_REPO"}
    }
  },
  "effortLevel": "high",
  "autoUpdatesChannel": "latest"
}
"@

$settingsContent | Out-File -FilePath $settingsPath -Encoding utf8

try {
    $null = Get-Content $settingsPath -Raw | ConvertFrom-Json
    Write-OK "settings.json scris si validat"
} catch {
    Write-Err "settings.json INVALID - $_"
    if ($backupPath -and (Test-Path $backupPath)) {
        Copy-Item $backupPath $settingsPath -Force
        Write-Warn "Restore din backup"
    }
    exit 1
}

# === state.json initial ===

Write-Header "12. GENESYUM STATE"

$genesyumDir = Join-Path $env:USERPROFILE '.genesyum'
if (-not (Test-Path $genesyumDir)) {
    New-Item -ItemType Directory -Force -Path $genesyumDir | Out-Null
}
$statePath = Join-Path $genesyumDir 'state.json'
if (-not (Test-Path $statePath)) {
    '{"schema_version":"2.0.0","student_id":null}' | Out-File -FilePath $statePath -Encoding utf8
    Write-OK "state.json initial creat"
} else {
    Write-OK "state.json existent - pastrat"
}

# === Folder lucru + Desktop shortcuts ===

Write-Header "13. SHORTCUTS DESKTOP"

$desktop = [Environment]::GetFolderPath('Desktop')
$workDir = Join-Path $env:USERPROFILE 'Documents\Genesyum'
if (-not (Test-Path $workDir)) {
    New-Item -ItemType Directory -Force -Path $workDir | Out-Null
    Write-OK "Folder lucru: $workDir"
}

$sc1 = Join-Path $desktop 'Genesyum Terminal.bat'
@"
@echo off
cd /d "$workDir"
title Genesyum - Terminal
echo Pornesc Claude Code...
claude
pause
"@ | Out-File $sc1 -Encoding ascii
Write-OK "'Genesyum Terminal' Desktop"

if ($vsCodeInstalled) {
    $sc2 = Join-Path $desktop 'Genesyum VS Code.bat'
    @"
@echo off
cd /d "$workDir"
code "$workDir"
"@ | Out-File $sc2 -Encoding ascii
    Write-OK "'Genesyum VS Code' Desktop"
}

if (-not $skipTelegram) {
    $sc3 = Join-Path $desktop 'Genesyum Telegram.bat'
    @"
@echo off
cd /d "$workDir"
title Genesyum - Telegram Bot ACTIV
echo NU INCHIDE aceasta fereastra cat folosesti bot-ul!
claude --channels plugin:telegram@claude-plugins-official
pause
"@ | Out-File $sc3 -Encoding ascii
    Write-OK "'Genesyum Telegram' Desktop"
}

# === Final ===

Write-Header "INSTALARE COMPLETA"

Write-Host ""
Write-Host "  GENESYUM AI v1.0.0 instalat cu succes!" -ForegroundColor Green
Write-Host ""
Write-Host "  Folder lucru: $workDir" -ForegroundColor White
Write-Host ""
Write-Host "  CANALE DISPONIBILE:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  TERMINAL - Click 'Genesyum Terminal' pe Desktop"
Write-Host "    Quick chat, comenzi rapide"
Write-Host ""
if ($vsCodeInstalled) {
    Write-Host "  VS CODE - Click 'Genesyum VS Code' pe Desktop"
    Write-Host "    Sesiuni lungi, research"
    Write-Host ""
}
if (-not $skipTelegram) {
    Write-Host "  TELEGRAM - Click 'Genesyum Telegram' pe Desktop"
    Write-Host "    DM la bot din phone"
    Write-Host ""
    Write-Host "  Pas urmator pentru Telegram:" -ForegroundColor Yellow
    Write-Host "    1. Click 'Genesyum Telegram' Desktop"
    Write-Host "    2. Pe phone, DM la bot-ul tau (orice mesaj)"
    Write-Host "    3. Bot trimite cod 6 caractere"
    Write-Host "    4. In terminal: /telegram:access pair <COD>"
    Write-Host "    5. Apoi: /telegram:access policy allowlist"
    Write-Host ""
}
Write-Host "  PRIMUL PAS - porneste orice canal si scrie:" -ForegroundColor Cyan
Write-Host "    /genesyum-core:start" -ForegroundColor White
Write-Host ""
Write-Host "  Suport: support@genesyum.com" -ForegroundColor Gray
Write-Host ""

Wait-User "Apasa ENTER pentru a inchide installer-ul..."
