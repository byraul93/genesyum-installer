# Build script — compileaza bootstrap.ps1 -> Genesyum-Install.exe via PS2EXE
# Necesita: PS2EXE module (Install-Module ps2exe -Scope CurrentUser)

$root      = $PSScriptRoot
$source    = Join-Path $root 'bootstrap.ps1'
$icon      = Join-Path $root 'assets\icon.ico'
$output    = Join-Path $root 'Genesyum-Install.exe'

if (-not (Test-Path $source)) { throw "Source missing: $source" }
if (-not (Test-Path $icon))   { throw "Icon missing: $icon" }

Import-Module ps2exe -Force

$params = @{
    InputFile      = $source
    OutputFile     = $output
    IconFile       = $icon
    Title          = 'Genesyum AI Installer'
    Description    = 'One-click installer pentru Genesyum AI Mentor — Dropshipping Big 5 markets'
    Company        = 'Genesyum'
    Product        = 'Genesyum AI Plugin'
    Copyright      = 'Copyright (c) 2026 Raul Paclisan / Genesyum'
    Version        = '1.0.0.0'
    RequireAdmin   = $true
    NoConsole      = $false
    NoOutput       = $false
    NoError        = $false
    Verbose        = $true
}

Write-Host "Building: $output" -ForegroundColor Cyan
Invoke-PS2EXE @params

if (Test-Path $output) {
    $size = [math]::Round((Get-Item $output).Length / 1KB, 1)
    Write-Host ""
    Write-Host "[OK] Build reusit: $output ($size KB)" -ForegroundColor Green
} else {
    Write-Host "[EROARE] Build esuat — exe nu a fost generat" -ForegroundColor Red
    exit 1
}
