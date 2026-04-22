# Build killswitch.mpackage for Mudlet (ZIP archive) — Windows / PowerShell
# Usage (from repo root in PowerShell):
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\build-mpackage.ps1
#   .\scripts\build-mpackage.ps1
#   .\scripts\build-mpackage.ps1 0.2.0
#
# Requires PowerShell 5+ (Compress-Archive). .mpackage is a zip file; we build .zip then rename.

$ErrorActionPreference = 'Stop'

Write-Host '==> Killswitch: building .mpackage (PowerShell) ...'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$Version = if ($args.Count -ge 1 -and $args[0]) { $args[0] } else { '0.1.0' }
$Dist = Join-Path $RepoRoot 'dist'
$Out = Join-Path $Dist "killswitch-$Version.mpackage"
$TempZip = Join-Path $Dist "killswitch-$Version-temp.zip"

foreach ($name in @('config.lua', 'killswitch.xml', 'README.md', 'src')) {
    $p = Join-Path $RepoRoot $name
    if (-not (Test-Path -LiteralPath $p)) {
        throw "Missing: $p — open a terminal in the repo root (folder that contains config.lua)."
    }
}

New-Item -ItemType Directory -Force -Path $Dist | Out-Null
if (Test-Path -LiteralPath $Out) { Remove-Item -LiteralPath $Out -Force }
if (Test-Path -LiteralPath $TempZip) { Remove-Item -LiteralPath $TempZip -Force }

Write-Host "==> Writing: $Out"

Push-Location $RepoRoot
try {
    # Compress-Archive only accepts .zip as destination on Windows PowerShell 5.x
    Compress-Archive -Path 'config.lua', 'killswitch.xml', 'README.md', 'src' `
        -DestinationPath $TempZip -CompressionLevel Optimal -Force
} finally {
    Pop-Location
}

Move-Item -LiteralPath $TempZip -Destination $Out -Force

$len = (Get-Item -LiteralPath $Out).Length
Write-Host "==> Done. Size: $len bytes"
Get-Item -LiteralPath $Out | Select-Object FullName, Length, LastWriteTime | Format-List

Write-Host ''
Write-Host 'Install in Mudlet command line (use your path):'
Write-Host "  lua installPackage([[$(($Out -replace '\\', '/'))]])"
Write-Host ''
