#Requires -Version 5.1
#
# ai-dev-setup: Set up Windows development environment
#

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Debug mode: set DEV_SETUP_DEBUG=1 to enable
$DebugMode = $env:DEV_SETUP_DEBUG -eq "1"
function Write-Dbg($msg) {
    if ($script:DebugMode) {
        Write-Host "  [DEBUG] $msg" -ForegroundColor DarkGray
    }
}

$STEP = 0
$TOTAL = 6

function Write-Step($msg) {
    $script:STEP++
    Write-Host ""
    Write-Host "[$STEP/$TOTAL] $msg" -ForegroundColor Cyan
}

function Write-Done() {
    Write-Host "  ✅ $MSG_DONE" -ForegroundColor Green
}

function Write-Skip() {
    Write-Host "  ⏭  $MSG_SKIP" -ForegroundColor Yellow
}

function Ask-YN($prompt, $default = "Y") {
    if ($default -eq "Y") {
        $answer = Read-Host "  $prompt [Y/n]"
        if ([string]::IsNullOrWhiteSpace($answer)) { $answer = "Y" }
    } else {
        $answer = Read-Host "  $prompt [y/N]"
        if ([string]::IsNullOrWhiteSpace($answer)) { $answer = "N" }
    }
    return $answer -match "^[Yy]"
}

# === Language selection ===
Write-Dbg "PowerShell $($PSVersionTable.PSVersion) | OS: $([System.Environment]::OSVersion.VersionString)"
Write-Dbg "ScriptDir: $ScriptDir"
Write-Host ""
Write-Host "🔧 ai-dev-setup" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Select your language:"
Write-Host ""
Write-Host "  1. English"
Write-Host "  2. 한국어"
Write-Host "  3. 日本語"
Write-Host ""
$langChoice = Read-Host "  Selection (1-3)"

switch ($langChoice) {
    "2" { $UserLang = "ko" }
    "3" { $UserLang = "ja" }
    default { $UserLang = "en" }
}

# Save language selection for Phase 2 (Claude Code setup)
$UserLang | Set-Content "$env:USERPROFILE\.dev-setup-lang"

# Load locale file
$localeFile = "$ScriptDir\claude-code\locale\$UserLang.ps1"
if (Test-Path $localeFile) {
    . $localeFile
} else {
    . "$ScriptDir\claude-code\locale\en.ps1"
}

Write-Host ""
Write-Host "🔧 $MSG_SETUP_WELCOME_WIN" -ForegroundColor White
Write-Host "   $MSG_SETUP_EACH_STEP"
Write-Host ""

# --- 1. winget check ---
Write-Step "$MSG_STEP_WINGET"
if (Get-Command winget -ErrorAction SilentlyContinue) {
    Write-Host "  $MSG_ALREADY_INSTALLED"
} else {
    Write-Host "  ❌ $MSG_WINGET_NOT_INSTALLED"
    Write-Host "  $MSG_WINGET_STORE"
    Write-Host "  $MSG_WINGET_UPDATE"
    Read-Host "  $MSG_WINGET_ENTER"
}
Write-Done

# --- 2. Packages ---
Write-Step "$MSG_STEP_PACKAGES_WIN"

$packages = @(
    @{ id = "Git.Git"; name = "Git" },
    @{ id = "OpenJS.NodeJS.LTS"; name = "Node.js" },
    @{ id = "BurntSushi.ripgrep.MSVC"; name = "ripgrep" }
)

foreach ($pkg in $packages) {
    $installed = winget list --id $pkg.id 2>$null | Select-String $pkg.id
    if ($installed) {
        Write-Host "  $($pkg.name) - $MSG_ALREADY_INSTALLED"
    } else {
        Write-Host "  $($pkg.name) $MSG_INSTALLING"
        Write-Dbg "winget install --id $($pkg.id)"
        winget install --id $pkg.id -e --accept-source-agreements --accept-package-agreements
        Write-Dbg "winget exit code: $LASTEXITCODE"
    }
}

# Refresh PATH so newly installed tools are available in this session
Write-Dbg "PATH refresh: before=$(($env:Path -split ';').Count) entries"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
Write-Dbg "PATH refresh: after=$(($env:Path -split ';').Count) entries"

# Verify Git (recommended for Claude Code)
Write-Dbg "git: $(if (Get-Command git -ErrorAction SilentlyContinue) { (Get-Command git).Source } else { 'NOT FOUND' })"
Write-Dbg "node: $(if (Get-Command node -ErrorAction SilentlyContinue) { (Get-Command node).Source } else { 'NOT FOUND' })"
Write-Dbg "npm: $(if (Get-Command npm -ErrorAction SilentlyContinue) { (Get-Command npm).Source } else { 'NOT FOUND' })"
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host ""
    Write-Host "⚠️  Git installation failed or not found" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  Git is recommended for Claude Code's version control features:"
    Write-Host "  • Track code changes (git status, git diff)"
    Write-Host "  • Auto-generate commits (AI writes commit messages)"
    Write-Host "  • GitHub integration (create PRs, manage issues)"
    Write-Host ""
    Write-Host "  Manual install:"
    Write-Host "  winget install --id Git.Git"
    Write-Host ""
    Write-Host "  Continuing without Git..."
    Write-Host ""
}

# Verify Node.js (critical for AI tools)
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host ""
    Write-Host "❌ Node.js installation failed" -ForegroundColor Red
    Write-Host ""
    Write-Host "$MSG_NODE_REQUIRED"
    Write-Host ""
    Write-Host "$MSG_NODE_MANUAL_INSTALL"
    Write-Host "  winget install --id OpenJS.NodeJS.LTS"
    Write-Host ""
    Write-Host "$MSG_NODE_VERIFY"
    Write-Host "  node --version"
    Write-Host ""
    exit 1
}

Write-Done

# --- 3. D2Coding font ---
Write-Step "$MSG_STEP_D2CODING"
$fontInstalled = winget list --id "Naver.D2Coding" 2>$null | Select-String "D2Coding"
if ($fontInstalled) {
    Write-Host "  $MSG_ALREADY_INSTALLED"
} else {
    Write-Host "  $MSG_INSTALLING"
    winget install --id "Naver.D2Coding" -e --accept-source-agreements --accept-package-agreements 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  $MSG_D2CODING_MANUAL" -ForegroundColor Yellow
        Write-Host "  $MSG_D2CODING_MANUAL_URL"
    }
}
Write-Done

# --- 4. Windows Terminal settings ---
Write-Step "$MSG_STEP_WINTERMINAL"
$wtSettingsDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
$wtSettingsFile = "$wtSettingsDir\settings.json"
Write-Dbg "WT settings: $wtSettingsFile (exists: $(Test-Path $wtSettingsFile))"

if (Test-Path $wtSettingsFile) {
    if (Ask-YN "$MSG_WINTERMINAL_APPLY") {
        # Backup
        $backupFile = "$wtSettingsFile.backup"
        Copy-Item $wtSettingsFile $backupFile -Force
        Write-Host "  → $MSG_WINTERMINAL_BACKUP $backupFile"

        try {
            # Parse JSON (strip single-line comments, protect URLs)
            $rawContent = Get-Content $wtSettingsFile -Raw
            # Only strip comments at line start or after whitespace, not inside strings
            $lines = $rawContent -split "`n"
            $cleanLines = @()
            foreach ($line in $lines) {
                # Remove single-line comments (lines where // appears outside of quotes)
                $trimmed = $line.TrimStart()
                if ($trimmed -match '^\s*//') {
                    continue
                }
                $cleanLines += $line
            }
            $cleanJson = $cleanLines -join "`n"
            # Remove trailing commas before } or ] (JSONC compatibility)
            $cleanJson = $cleanJson -replace ',\s*(\}|\])', '$1'
            Write-Dbg "JSON cleanup: $($lines.Count) lines -> $($cleanLines.Count) lines"
            $settings = $cleanJson | ConvertFrom-Json

            # Dev color scheme
            $devScheme = @{
                name             = "Dev"
                background       = "#282A36"
                foreground       = "#F1F1F0"
                cursorColor      = "#F7F8F8"
                selectionBackground = "#9BBBDC"
                black            = "#000000"
                brightBlack      = "#686868"
                red              = "#EC6768"
                brightRed        = "#ED6A5E"
                green            = "#89F38E"
                brightGreen      = "#89F38E"
                yellow           = "#F4F99D"
                brightYellow     = "#F4F99D"
                blue             = "#76C3FA"
                brightBlue       = "#76C3FA"
                purple           = "#ED6ABD"
                brightPurple     = "#EE73B3"
                cyan             = "#ABECED"
                brightCyan       = "#ABECED"
                white            = "#F1F1F0"
                brightWhite      = "#F1F1F0"
            }

            # Add Dev scheme (replace if exists)
            if (-not $settings.schemes) {
                $settings | Add-Member -NotePropertyName "schemes" -NotePropertyValue @()
            }
            $existingSchemes = @($settings.schemes | Where-Object { $_.name -ne "Dev" })
            $settings.schemes = @($existingSchemes) + @($devScheme)

            # Set defaults: font + theme
            if (-not $settings.profiles.defaults) {
                $settings.profiles | Add-Member -NotePropertyName "defaults" -NotePropertyValue @{}
            }
            $defaults = $settings.profiles.defaults
            $defaults | Add-Member -NotePropertyName "colorScheme" -NotePropertyValue "Dev" -Force
            $defaults | Add-Member -NotePropertyName "font" -NotePropertyValue @{ face = "D2Coding"; size = 11 } -Force
            $defaults | Add-Member -NotePropertyName "opacity" -NotePropertyValue 95 -Force

            # Save
            $settings | ConvertTo-Json -Depth 10 | Set-Content $wtSettingsFile -Encoding UTF8
            Write-Host "  → $MSG_WINTERMINAL_DONE"
            Write-Host "  💡 $MSG_WINTERMINAL_RESTORE $backupFile"
            Write-Done
        } catch {
            # Restore backup on failure
            Write-Dbg "WT settings error: $($_.Exception.Message)"
            Copy-Item $backupFile $wtSettingsFile -Force
            Write-Host "  ⚠️  $MSG_WINTERMINAL_PARSE_FAIL" -ForegroundColor Yellow
            Write-Host "  → $MSG_WINTERMINAL_BACKUP_RESTORED"
            Write-Skip
        }
    } else {
        Write-Skip
    }
} else {
    Write-Host "  $MSG_WINTERMINAL_NOT_INSTALLED"
    if (Ask-YN "$MSG_WINTERMINAL_INSTALL") {
        winget install --id Microsoft.WindowsTerminal -e --accept-source-agreements --accept-package-agreements
        Write-Done
    } else {
        Write-Skip
    }
}

# --- 5. Oh My Posh ---
Write-Step "$MSG_STEP_OHMYPOSH"
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    Write-Host "  $MSG_ALREADY_INSTALLED"
    Write-Done
} elseif (Ask-YN "$MSG_OHMYPOSH_INSTALL") {
    winget install --id JanDeDobbeleer.OhMyPosh -e --accept-source-agreements --accept-package-agreements
    Write-Host "  $MSG_OHMYPOSH_PROFILE"
    Write-Host '  oh-my-posh init pwsh | Invoke-Expression'
    Write-Done
} else {
    Write-Skip
}

# Terminal theme verification guide
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "📋 $MSG_WINTERMINAL_VERIFY_HEADER" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "  💡 $MSG_WINTERMINAL_VERIFY_DESC"
Write-Host ""
Write-Host "  $MSG_WINTERMINAL_MANUAL_SETUP"
Write-Host "     $MSG_WINTERMINAL_MANUAL" -ForegroundColor Yellow
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# --- 6. AI Coding Tools ---
Write-Step "$MSG_STEP_AI_TOOLS"
Write-Host "  $MSG_AI_TOOLS_HINT"
Write-Host "  1. Claude Code"
Write-Host "  2. Gemini CLI"
Write-Host "  3. Codex CLI"

# Check if gh CLI is available for GitHub Copilot CLI
if (Get-Command gh -ErrorAction SilentlyContinue) {
    Write-Host "  4. GitHub Copilot CLI"
} else {
    Write-Host "  4. GitHub Copilot CLI (requires gh)" -ForegroundColor DarkGray
}

Write-Host ""
$aiChoice = Read-Host "  Select tools (comma-separated, e.g., 1,2,3) [1]"
if ([string]::IsNullOrWhiteSpace($aiChoice)) { $aiChoice = "1" }
$choices = $aiChoice -split "," | ForEach-Object { $_.Trim() }

$installedClaude = $false
foreach ($choice in $choices) {
    switch ($choice) {
        "1" {
            # Check npm prerequisite
            if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
                Write-Host "  ❌ Claude Code requires Node.js/npm" -ForegroundColor Red
                Write-Host "     npm not found. Please install Node.js first:"
                Write-Host "     winget install --id OpenJS.NodeJS.LTS"
                continue
            }

            $installedClaude = $true
            if (Get-Command claude -ErrorAction SilentlyContinue) {
                Write-Host "  Claude Code: $MSG_ALREADY_INSTALLED"
                if (Ask-YN "$MSG_CLAUDE_UPDATE_ASK") {
                    Write-Host "  $MSG_UPDATING"
                    try { npm update -g @anthropic-ai/claude-code } catch { Write-Host "  ⚠️  Update failed." -ForegroundColor Yellow }
                }
            } else {
                Write-Host "  $MSG_INSTALLING Claude Code..."
                try { npm install -g @anthropic-ai/claude-code } catch { Write-Host "  ⚠️  Installation failed." -ForegroundColor Yellow }
            }
        }
        "2" {
            # Check npm prerequisite
            if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
                Write-Host "  ❌ Gemini CLI requires Node.js/npm" -ForegroundColor Red
                Write-Host "     npm not found. Please install Node.js first:"
                Write-Host "     winget install --id OpenJS.NodeJS.LTS"
                continue
            }

            if (Get-Command gemini -ErrorAction SilentlyContinue) {
                Write-Host "  Gemini CLI: $MSG_ALREADY_INSTALLED"
            } else {
                Write-Host "  $MSG_INSTALLING Gemini CLI..."
                try { npm install -g @google/gemini-cli } catch { Write-Host "  ⚠️  Installation failed." -ForegroundColor Yellow }
            }
        }
        "3" {
            # Check npm prerequisite
            if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
                Write-Host "  ❌ Codex CLI requires Node.js/npm" -ForegroundColor Red
                Write-Host "     npm not found. Please install Node.js first:"
                Write-Host "     winget install --id OpenJS.NodeJS.LTS"
                continue
            }

            if (Get-Command codex -ErrorAction SilentlyContinue) {
                Write-Host "  Codex CLI: $MSG_ALREADY_INSTALLED"
            } else {
                Write-Host "  $MSG_INSTALLING Codex CLI..."
                try { npm install -g @openai/codex } catch { Write-Host "  ⚠️  Installation failed." -ForegroundColor Yellow }
            }
        }
        "4" {
            # Check gh prerequisite
            if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
                Write-Host "  ❌ GitHub Copilot CLI requires GitHub CLI (gh)" -ForegroundColor Red
                Write-Host "     gh not found. Please install it first:"
                Write-Host "     winget install --id GitHub.cli"
                continue
            }

            if (gh extension list 2>$null | Select-String "gh-copilot") {
                Write-Host "  GitHub Copilot CLI: $MSG_ALREADY_INSTALLED"
            } else {
                Write-Host "  $MSG_INSTALLING GitHub Copilot CLI..."
                try { gh extension install github/gh-copilot } catch { Write-Host "  ⚠️  Installation failed." -ForegroundColor Yellow }
            }
        }
    }
}

if ($choices.Count -eq 0) { Write-Skip } else { Write-Done }

if ($installedClaude) {
    Write-Host ""
    Write-Host "  💡 $MSG_CLAUDE_EXTRA" -ForegroundColor White
    Write-Host "     ~\claude-code-setup\setup-claude.ps1" -ForegroundColor Cyan
}

# === Cleanup ===
# Copy claude-code/ for later setup, then remove entire install directory
# This handles both ZIP download (install.ps1) and git clone cases cleanly
$claudeCodeDir = "$env:USERPROFILE\claude-code-setup"
Write-Dbg "Copying claude-code/ to $claudeCodeDir"
if (Test-Path "$ScriptDir\claude-code") {
    if (Test-Path $claudeCodeDir) { Remove-Item $claudeCodeDir -Recurse -Force }
    New-Item -ItemType Directory -Path $claudeCodeDir -Force | Out-Null
    Copy-Item "$ScriptDir\claude-code\setup-claude.ps1" $claudeCodeDir\
    Copy-Item "$ScriptDir\claude-code\README.md" $claudeCodeDir\ -ErrorAction SilentlyContinue
    Copy-Item "$ScriptDir\claude-code\agents" $claudeCodeDir\ -Recurse
    Copy-Item "$ScriptDir\claude-code\templates" $claudeCodeDir\ -Recurse
    Copy-Item "$ScriptDir\claude-code\examples" $claudeCodeDir\ -Recurse
    Copy-Item "$ScriptDir\claude-code\locale" $claudeCodeDir\ -Recurse

    # Verify critical files were copied
    $requiredFiles = @("setup-claude.ps1")
    $requiredDirs = @("agents", "templates", "locale")
    $copyOk = $true
    foreach ($f in $requiredFiles) {
        if (-not (Test-Path "$claudeCodeDir\$f")) {
            Write-Host "  ⚠️  Missing: $f" -ForegroundColor Yellow
            $copyOk = $false
        }
    }
    foreach ($d in $requiredDirs) {
        if (-not (Test-Path "$claudeCodeDir\$d")) {
            Write-Host "  ⚠️  Missing directory: $d" -ForegroundColor Yellow
            $copyOk = $false
        }
    }
    if (-not $copyOk) {
        Write-Host "  ⚠️  Some Phase 2 files failed to copy. Phase 2 may not work correctly." -ForegroundColor Yellow
    }
}
# Remove entire install directory (with safety check)
Write-Dbg "Cleanup: removing $ScriptDir"
if (-not [string]::IsNullOrWhiteSpace($ScriptDir) -and
    $ScriptDir -ne $env:USERPROFILE -and
    $ScriptDir -ne "C:\" -and
    $ScriptDir -ne $env:SystemRoot -and
    (Test-Path "$ScriptDir\setup.ps1")) {
    Set-Location $env:USERPROFILE
    Remove-Item $ScriptDir -Recurse -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "  ⚠️  Install directory preserved for safety: $ScriptDir" -ForegroundColor Yellow
}

# === Done ===
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor White
Write-Host "✨ $MSG_PHASE1_COMPLETE" -ForegroundColor Green
Write-Host ""
Write-Host "  $MSG_PHASE2_NEXT"
Write-Host ""
Write-Host "  $MSG_PHASE2_DESC_1"
Write-Host "  $MSG_PHASE2_DESC_2"
Write-Host "  $MSG_PHASE2_DESC_3"
Write-Host "  $MSG_PHASE2_DESC_4"
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor White
Write-Host ""

if (Ask-YN $MSG_PHASE2_ASK) {
    Write-Host ""
    Write-Host "  ⚠️  $MSG_PHASE2_RESTART_WARN" -ForegroundColor Yellow
    Write-Host "     $MSG_PHASE2_RESTART_REASON"
    Write-Host ""

    if (Ask-YN $MSG_PHASE2_OPEN_TERM_ASK) {
        Write-Host ""
        Write-Host "  🚀 $MSG_PHASE2_OPENING" -ForegroundColor Cyan
        Write-Host ""

        # Open new PowerShell window with setup-claude.ps1
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "& '$env:USERPROFILE\claude-code-setup\setup-claude.ps1'"

        Write-Host "  ✅ $MSG_PHASE2_OPENED" -ForegroundColor Green
        Write-Host "  ℹ️  $MSG_PHASE2_CLOSE_INFO"
    } else {
        Write-Host ""
        Write-Host "  💡 $MSG_PHASE2_MANUAL"
        Write-Host "     ~\claude-code-setup\setup-claude.ps1"
    }
} else {
    Write-Host ""
    Write-Host "  💡 $MSG_PHASE2_MANUAL_LATER"
    Write-Host "     ~\claude-code-setup\setup-claude.ps1"
}

Write-Host ""
