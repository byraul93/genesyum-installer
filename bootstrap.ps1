# Genesyum Installer — bootstrap thin
# Compilat la Genesyum-Install.exe via ps2exe.
# Descarca install.ps1 din GitHub si il ruleaza.
# Update-uri viitoare la install.ps1 ajung automat la studenti — exe-ul ramane stabil.

$ErrorActionPreference = 'Stop'

# UI: titlu + culori
$Host.UI.RawUI.WindowTitle = 'Genesyum AI Installer'
try {
    $Host.UI.RawUI.BackgroundColor = 'Black'
    $Host.UI.RawUI.ForegroundColor = 'White'
    Clear-Host
} catch {}

function Write-Banner {
    Write-Host ''
    Write-Host '  +========================================================+' -ForegroundColor Cyan
    Write-Host '  |                                                        |' -ForegroundColor Cyan
    Write-Host '  |          GENESYUM AI INSTALLER v1.0                    |' -ForegroundColor Cyan
    Write-Host '  |          Dropshipping mentor — Big 5 markets           |' -ForegroundColor Cyan
    Write-Host '  |                                                        |' -ForegroundColor Cyan
    Write-Host '  +========================================================+' -ForegroundColor Cyan
    Write-Host ''
}

Write-Banner

# Sursa install.ps1 — schimbabila daca pivot URL
$InstallerUrl = 'https://raw.githubusercontent.com/byraul93/genesyum-installer/main/install.ps1'
$LocalPath    = Join-Path $env:TEMP 'genesyum-install.ps1'

Write-Host '  [1/3] Pregatire mediu...' -ForegroundColor Yellow

# TLS 1.2 + ExecutionPolicy doar pe procesul curent
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
try { Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force } catch {}

Write-Host '  [2/3] Descarcare installer din GitHub...' -ForegroundColor Yellow

try {
    Invoke-WebRequest -Uri $InstallerUrl -OutFile $LocalPath -UseBasicParsing
    if (-not (Test-Path $LocalPath) -or (Get-Item $LocalPath).Length -lt 1000) {
        throw "Installer descarcat este gol sau corupt."
    }
    Write-Host "  [OK] Salvat: $LocalPath" -ForegroundColor Green
} catch {
    Write-Host ''
    Write-Host "  [EROARE] Nu am putut descarca installer:" -ForegroundColor Red
    Write-Host "  $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ''
    Write-Host "  Verifica conexiunea la internet si reincearca." -ForegroundColor Yellow
    Write-Host '  Apasa Enter pentru a inchide...' -ForegroundColor Gray
    [void][Console]::ReadLine()
    exit 1
}

Write-Host '  [3/3] Lansare wizard...' -ForegroundColor Yellow
Write-Host ''
Start-Sleep -Seconds 1

# Ruleaza installer-ul descarcat in acelasi proces (mosteneste contextul admin)
try {
    & $LocalPath
    $exitCode = $LASTEXITCODE
    if ($null -eq $exitCode) { $exitCode = 0 }
} catch {
    Write-Host ''
    Write-Host "  [EROARE] Installer a esuat:" -ForegroundColor Red
    Write-Host "  $($_.Exception.Message)" -ForegroundColor Red
    $exitCode = 1
}

Write-Host ''
if ($exitCode -eq 0) {
    Write-Host '  +-------------------------------------------+' -ForegroundColor Green
    Write-Host '  | Instalare COMPLETA. Verifica desktop.     |' -ForegroundColor Green
    Write-Host '  +-------------------------------------------+' -ForegroundColor Green
} else {
    Write-Host '  +-------------------------------------------+' -ForegroundColor Red
    Write-Host '  | Instalare INCOMPLETA. Vezi mesajele sus.  |' -ForegroundColor Red
    Write-Host '  +-------------------------------------------+' -ForegroundColor Red
}

Write-Host ''
Write-Host '  Apasa Enter pentru a inchide fereastra...' -ForegroundColor Gray
try { [void][Console]::ReadLine() } catch { Start-Sleep -Seconds 5 }
exit $exitCode
