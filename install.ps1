#
# ai-dev-setup installer (runs without Git)
# Usage: paste this one line in PowerShell
#   irm https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.ps1 | iex
#

$ErrorActionPreference = "Stop"
$version = "1.0.0"
$repoUrl = "https://github.com/ejkim-dev/ai-dev-setup/archive/refs/tags/v$version.zip"
$expectedSha256 = "031b7c84dab1c3bbd49c02315669ba476d6bf4444aaab7b46d0d9f4d6cb2662f"
$downloadDir = "$env:TEMP\ai-dev-setup"
$zipFile = "$downloadDir\ai-dev-setup.zip"
$extractDir = "$downloadDir\ai-dev-setup-$version"
$installDir = "$env:USERPROFILE\ai-dev-setup"

Write-Host ""
Write-Host "🔧 Downloading ai-dev-setup..." -ForegroundColor Cyan

# Clean up existing temp files
if (Test-Path $downloadDir) { Remove-Item $downloadDir -Recurse -Force }
New-Item -ItemType Directory -Path $downloadDir -Force | Out-Null

# Download ZIP
Invoke-WebRequest -Uri $repoUrl -OutFile $zipFile -UseBasicParsing
Write-Host "  ✅ Download complete" -ForegroundColor Green

# SHA256 verification
$actualSha256 = (Get-FileHash -Path $zipFile -Algorithm SHA256).Hash.ToLower()
if ($actualSha256 -ne $expectedSha256) {
    Write-Host "  ❌ SHA256 mismatch!" -ForegroundColor Red
    Write-Host "     Expected: $expectedSha256"
    Write-Host "     Actual:   $actualSha256"
    Write-Host "     Download may be corrupted or tampered with."
    Remove-Item $downloadDir -Recurse -Force
    exit 1
}
Write-Host "  ✅ SHA256 verified" -ForegroundColor Green

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
