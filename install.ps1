#
# ai-dev-setup installer (runs without Git)
# Usage: paste this one line in PowerShell
#   irm https://raw.githubusercontent.com/ejkim-dev/ai-dev-setup/main/install.ps1 | iex
#

$ErrorActionPreference = "Stop"
$repo = "ejkim-dev/ai-dev-setup"
$downloadDir = "$env:TEMP\ai-dev-setup"
$zipFile = "$downloadDir\ai-dev-setup.zip"
$installDir = "$env:USERPROFILE\ai-dev-setup"

Write-Host ""
Write-Host "🔧 Downloading ai-dev-setup..." -ForegroundColor Cyan

# Get latest release tag
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/releases/latest" -UseBasicParsing
$version = $release.tag_name
if (-not $version) {
    Write-Host "  ❌ Failed to fetch latest release version." -ForegroundColor Red
    exit 1
}
$versionNum = $version.TrimStart("v")
Write-Host "  📦 Version: $version"

$repoUrl = "https://github.com/$repo/archive/refs/tags/$version.zip"
$extractDir = "$downloadDir\ai-dev-setup-$versionNum"

# Clean up existing temp files
if (Test-Path $downloadDir) { Remove-Item $downloadDir -Recurse -Force }
New-Item -ItemType Directory -Path $downloadDir -Force | Out-Null

# Download ZIP
Invoke-WebRequest -Uri $repoUrl -OutFile $zipFile -UseBasicParsing
Write-Host "  ✅ Download complete" -ForegroundColor Green

# SHA256 verification (if checksum available in release)
$checksumsUrl = "https://github.com/$repo/releases/download/$version/SHA256SUMS"
try {
    Invoke-WebRequest -Uri $checksumsUrl -OutFile "$downloadDir\SHA256SUMS" -UseBasicParsing
    $checksumLine = Get-Content "$downloadDir\SHA256SUMS" | Select-String "source.zip"
    if ($checksumLine) {
        $expectedSha256 = ($checksumLine -split '\s+')[0]
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
    }
} catch {
    Write-Host "  ⚠️  SHA256 checksum not available, skipping verification" -ForegroundColor Yellow
}

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
