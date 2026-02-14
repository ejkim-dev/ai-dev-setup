#
# ai-dev-setup installer (runs without Git)
# Usage: paste this one line in PowerShell
#   irm https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.ps1 | iex
#

$ErrorActionPreference = "Stop"
$repoUrl = "https://github.com/ejkim-dev/ai-dev-setup/archive/refs/heads/main.zip"
$downloadDir = "$env:TEMP\ai-dev-setup"
$zipFile = "$downloadDir\ai-dev-setup.zip"
$extractDir = "$downloadDir\ai-dev-setup-main"
$installDir = "$env:USERPROFILE\ai-dev-setup"

Write-Host ""
Write-Host "🔧 Downloading ai-dev-setup..." -ForegroundColor Cyan

# Clean up existing temp files
if (Test-Path $downloadDir) { Remove-Item $downloadDir -Recurse -Force }
New-Item -ItemType Directory -Path $downloadDir -Force | Out-Null

# Download ZIP
Invoke-WebRequest -Uri $repoUrl -OutFile $zipFile -UseBasicParsing
Write-Host "  ✅ Download complete" -ForegroundColor Green

# Extract
Expand-Archive -Path $zipFile -DestinationPath $downloadDir -Force
Write-Host "  ✅ Extraction complete" -ForegroundColor Green

# Move to install directory
if (Test-Path $installDir) {
    Write-Host "  Existing ai-dev-setup folder found. Updating."
    Remove-Item $installDir -Recurse -Force
}
Move-Item $extractDir $installDir -Force

# Clean up temp files
Remove-Item $downloadDir -Recurse -Force

Write-Host ""
Write-Host "  📁 Install location: $installDir" -ForegroundColor White
Write-Host ""
Write-Host "  Starting setup..." -ForegroundColor Cyan
Write-Host ""

# Run setup
Set-Location $installDir
& "$installDir\setup.ps1"
