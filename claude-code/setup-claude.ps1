#Requires -Version 5.1
#
# Claude Code Setup: workspace, agents, MCP servers, Obsidian
#
$ErrorActionPreference = "Continue"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Workspace = "$env:USERPROFILE\claude-workspace"
$ConfigFile = "$Workspace\config.json"

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

# Test if symlinks can be created (Developer Mode or admin)
function Test-SymlinkCapability {
    $testLink = "$env:TEMP\symlink_test_$(Get-Random)"
    $testTarget = "$env:TEMP\symlink_target_$(Get-Random)"
    try {
        New-Item -ItemType Directory -Path $testTarget -Force | Out-Null
        New-Item -ItemType SymbolicLink -Path $testLink -Target $testTarget -ErrorAction Stop | Out-Null
        Remove-Item $testLink -Force
        Remove-Item $testTarget -Force
        return $true
    } catch {
        Remove-Item $testTarget -Force -ErrorAction SilentlyContinue
        return $false
    }
}

Write-Host ""
Write-Host "🤖 Claude Code Setup" -ForegroundColor Cyan
Write-Host ""

# === 0. Language selection (always in English) ===
Write-Host "  Select your language:"
Write-Host ""
Write-Host "  1. English"
Write-Host "  2. 한국어"
Write-Host "  3. 日本語"
Write-Host "  4. Other"
Write-Host ""
$langChoice = Read-Host "  Selection (1-4)"

switch ($langChoice) {
    "1" {
        $UserLang = "en"
        $LangName = "English"
        $LangInstruction = "- Respond in English"
    }
    "2" {
        $UserLang = "ko"
        $LangName = "한국어"
        $LangInstruction = "- 한국어로 대답할 것`n- 코드, 명령어, 기술 용어 등 필요한 경우에만 영어 사용"
    }
    "3" {
        $UserLang = "ja"
        $LangName = "日本語"
        $LangInstruction = "- 日本語で回答すること`n- コード、コマンド、技術用語は英語のまま使用"
    }
    "4" {
        $UserLang = Read-Host "  Language code (e.g., zh, de, fr)"
        $LangName = Read-Host "  Language name (e.g., 中文, Deutsch)"
        $customInstr = Read-Host "  Instruction for Claude (e.g., Respond in Chinese)"
        $LangInstruction = "- $customInstr"
    }
    default {
        $UserLang = "en"
        $LangName = "English"
        $LangInstruction = "- Respond in English"
    }
}

# Load locale file
$localeFile = "$ScriptDir\locale\$UserLang.ps1"
if (Test-Path $localeFile) {
    . $localeFile
} else {
    . "$ScriptDir\locale\en.ps1"
}

Write-Host ""
Write-Host "  → $MSG_LANG_SET $LangName" -ForegroundColor Green

# Track installation options
$OptWorkspace = $false
$OptObsidian = $false
$OptMcpRag = $false
$OptMcpAtlassian = $false
$ConnectedProjects = @()

# --- Prerequisite checks ---
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "  ⚠️  $MSG_NODE_NOT_INSTALLED"
    if (Ask-YN $MSG_NODE_INSTALL_ASK) {
        winget install --id OpenJS.NodeJS.LTS -e --accept-source-agreements --accept-package-agreements
        Write-Done
    }
}

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "  ⚠️  $MSG_NPM_NOT_FOUND"
    Write-Host "  → https://nodejs.org/"
    exit 1
}

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Host "  $MSG_CLAUDE_NOT_INSTALLED"
    if (Ask-YN $MSG_INSTALL_NOW) {
        npm install -g @anthropic-ai/claude-code
        Write-Done
    } else {
        Write-Host "  $MSG_CLAUDE_REQUIRED"
        Write-Host $MSG_CLAUDE_INSTALL_CMD
        exit 1
    }
}

# Check symlink capability
$canSymlink = Test-SymlinkCapability
if (-not $canSymlink) {
    Write-Host ""
    Write-Host "  ⚠️  $MSG_WS_SYMLINK_NEED_ADMIN" -ForegroundColor Yellow
    Write-Host "  $MSG_WS_SYMLINK_ENABLE"
    Write-Host "  $MSG_WS_SYMLINK_SKIP"
    Write-Host ""
}

# === 1. claude-workspace ===
Write-Host ""
Write-Host "[1/4] $MSG_WS_TITLE" -ForegroundColor Cyan
Write-Host ""
Write-Host "  $MSG_WS_DESC_1"
Write-Host "  $MSG_WS_DESC_2"
Write-Host "  $MSG_WS_DESC_3"
Write-Host ""
Write-Host "  ~\claude-workspace\"
Write-Host "  ├── global\agents\    ← $MSG_WS_TREE_AGENTS"
Write-Host "  ├── projects\         ← $MSG_WS_TREE_PROJECTS"
Write-Host "  └── templates\        ← $MSG_WS_TREE_TEMPLATES"
Write-Host ""

if (Ask-YN $MSG_WS_ASK) {
    $OptWorkspace = $true

    New-Item -ItemType Directory -Path "$Workspace\global\agents" -Force | Out-Null
    New-Item -ItemType Directory -Path "$Workspace\projects" -Force | Out-Null
    New-Item -ItemType Directory -Path "$Workspace\templates" -Force | Out-Null

    # Copy global agents
    Copy-Item "$ScriptDir\agents\workspace-manager.md" "$Workspace\global\agents\" -Force
    Copy-Item "$ScriptDir\agents\translate.md" "$Workspace\global\agents\" -Force
    Copy-Item "$ScriptDir\agents\doc-writer.md" "$Workspace\global\agents\" -Force
    Write-Host "  → $MSG_WS_AGENTS_DONE"

    # Copy templates
    if (Test-Path "$ScriptDir\templates") {
        Copy-Item "$ScriptDir\templates\*" "$Workspace\templates\" -Force -ErrorAction SilentlyContinue
    }
    if (Test-Path "$ScriptDir\examples") {
        Copy-Item "$ScriptDir\examples\*" "$Workspace\templates\" -Force -ErrorAction SilentlyContinue
    }
    Write-Host "  → $MSG_WS_TEMPLATES_DONE"

    # Inject language into CLAUDE.local.md template
    $localMdTemplate = "$Workspace\templates\CLAUDE.local.md"
    if (Test-Path $localMdTemplate) {
        $content = Get-Content $localMdTemplate -Raw
        # Replace placeholder with actual multiline instruction
        $resolved = $LangInstruction -replace '`n', "`n"
        $content = $content -replace "__LANGUAGE_INSTRUCTION__", $resolved
        Set-Content -Path $localMdTemplate -Value $content -Encoding UTF8 -NoNewline
    }

    # Symlink ~/.claude/agents/
    $claudeAgentsDir = "$env:USERPROFILE\.claude\agents"
    if ($canSymlink) {
        if (Test-Path $claudeAgentsDir) {
            $item = Get-Item $claudeAgentsDir
            if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                Write-Host "  $MSG_WS_SYMLINK_EXISTS"
            } else {
                Write-Host "  ⚠️  $MSG_WS_FOLDER_EXISTS"
                if (Ask-YN $MSG_WS_BACKUP_ASK) {
                    Rename-Item $claudeAgentsDir "$claudeAgentsDir.backup"
                    New-Item -ItemType SymbolicLink -Path $claudeAgentsDir -Target "$Workspace\global\agents" | Out-Null
                    Write-Host "  → $MSG_WS_BACKUP_DONE"
                    Write-Host "  → $MSG_WS_SYMLINK_DONE"
                }
            }
        } else {
            New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude" -Force | Out-Null
            New-Item -ItemType SymbolicLink -Path $claudeAgentsDir -Target "$Workspace\global\agents" | Out-Null
            Write-Host "  → $MSG_WS_SYMLINK_DONE"
        }
    } else {
        # Fallback: copy agents instead of symlink
        New-Item -ItemType Directory -Path $claudeAgentsDir -Force | Out-Null
        Copy-Item "$Workspace\global\agents\*" $claudeAgentsDir -Force
        Write-Host "  → $MSG_WS_SYMLINK_SKIP"
    }

    Write-Done

    # --- Project connection ---
    Write-Host ""
    Write-Host "  $MSG_PROJ_DESC_1"
    Write-Host "  $MSG_PROJ_DESC_2"
    Write-Host ""

    while (Ask-YN $MSG_PROJ_ASK) {
        $projectPath = Read-Host "  $MSG_PROJ_PATH"

        if (-not (Test-Path $projectPath)) {
            Write-Host "  ❌ $MSG_PROJ_NOT_FOUND $projectPath"
            continue
        }

        $projectName = Split-Path $projectPath -Leaf

        # Handle name collision
        $wsProject = "$Workspace\projects\$projectName"
        if (Test-Path $wsProject) {
            Write-Host "  ⚠️  '$projectName' $MSG_PROJ_NAME_CONFLICT"
            $altName = Read-Host "  →"
            if ([string]::IsNullOrWhiteSpace($altName)) {
                continue
            }
            $projectName = $altName
            $wsProject = "$Workspace\projects\$projectName"
        }

        New-Item -ItemType Directory -Path "$wsProject\.claude\agents" -Force | Out-Null

        if (-not (Test-Path "$wsProject\CLAUDE.md")) {
            Copy-Item "$Workspace\templates\CLAUDE.md" "$wsProject\CLAUDE.md"
        }

        if (-not (Test-Path "$wsProject\CLAUDE.local.md")) {
            Copy-Item "$Workspace\templates\CLAUDE.local.md" "$wsProject\CLAUDE.local.md"
        }

        if ($canSymlink) {
            # .claude/
            if (Test-Path "$projectPath\.claude") {
                Write-Host "  ⚠️  $projectPath\.claude $MSG_PROJ_EXISTS"
            } else {
                New-Item -ItemType SymbolicLink -Path "$projectPath\.claude" -Target "$wsProject\.claude" | Out-Null
                Write-Host "  → $MSG_PROJ_LINK_CLAUDE"
            }

            # CLAUDE.md
            if (Test-Path "$projectPath\CLAUDE.md") {
                Write-Host "  ⚠️  $projectPath\CLAUDE.md $MSG_PROJ_EXISTS"
            } else {
                New-Item -ItemType SymbolicLink -Path "$projectPath\CLAUDE.md" -Target "$wsProject\CLAUDE.md" | Out-Null
                Write-Host "  → $MSG_PROJ_LINK_CLAUDEMD"
            }

            # CLAUDE.local.md
            if (Test-Path "$projectPath\CLAUDE.local.md") {
                Write-Host "  ⚠️  $projectPath\CLAUDE.local.md $MSG_PROJ_EXISTS"
            } else {
                New-Item -ItemType SymbolicLink -Path "$projectPath\CLAUDE.local.md" -Target "$wsProject\CLAUDE.local.md" | Out-Null
                Write-Host "  → $MSG_PROJ_LINK_LOCALMD"
            }
        } else {
            # Fallback: copy files instead of symlink
            Copy-Item "$wsProject\CLAUDE.md" "$projectPath\CLAUDE.md" -Force -ErrorAction SilentlyContinue
            Copy-Item "$wsProject\CLAUDE.local.md" "$projectPath\CLAUDE.local.md" -Force -ErrorAction SilentlyContinue
            Write-Host "  → $MSG_WS_SYMLINK_SKIP"
        }

        # .gitignore
        $gitignore = "$projectPath\.gitignore"
        if (Test-Path $gitignore) {
            $content = Get-Content $gitignore -Raw
            foreach ($entry in @(".claude/", "CLAUDE.local.md", ".claude-data/")) {
                if ($content -notmatch [regex]::Escape($entry)) {
                    Add-Content -Path $gitignore -Value $entry
                }
            }
            Write-Host "  → $MSG_PROJ_GITIGNORE"
        }

        $ConnectedProjects += $projectName

        Write-Host "  ✅ $projectName $MSG_PROJ_DONE" -ForegroundColor Green
        Write-Host ""
    }

} else {
    Write-Skip
}

# === 2. Obsidian ===
Write-Host ""
Write-Host "[2/4] $MSG_OBS_TITLE" -ForegroundColor Cyan
Write-Host ""
Write-Host "  $MSG_OBS_DESC_1"
Write-Host "  $MSG_OBS_DESC_2"
Write-Host ""

if (Ask-YN $MSG_OBS_ASK) {
    $OptObsidian = $true
    winget install --id Obsidian.Obsidian -e --accept-source-agreements --accept-package-agreements
    Write-Done
} else {
    Write-Skip
}

# === 3. MCP Servers ===
Write-Host ""
Write-Host "[3/4] $MSG_MCP_TITLE" -ForegroundColor Cyan
Write-Host ""
Write-Host "  $MSG_MCP_DESC_1"
Write-Host "  $MSG_MCP_DESC_2"
Write-Host "  $MSG_MCP_DESC_3"
Write-Host ""

if (Ask-YN $MSG_MCP_ASK) {

    # --- local-rag ---
    Write-Host ""
    Write-Host "  📚 $MSG_RAG_TITLE" -ForegroundColor Cyan
    Write-Host "  $MSG_RAG_DESC"
    Write-Host ""

    if (Ask-YN $MSG_RAG_ASK) {
        $OptMcpRag = $true
        $ragProject = Read-Host "  $MSG_RAG_PATH"

        if (Test-Path $ragProject) {
            $ragDataDir = Join-Path $ragProject ".claude-data"
            New-Item -ItemType Directory -Path $ragDataDir -Force | Out-Null

            $mcpFile = Join-Path $ragProject ".mcp.json"
            if (Test-Path $mcpFile) {
                Write-Host "  ⚠️  $MSG_MCP_FILE_EXISTS"
                Write-Host "  → $MSG_MCP_FILE_REF $ScriptDir\templates\mcp-local-rag.json"
            } else {
                $template = Get-Content "$ScriptDir\templates\mcp-local-rag.json" -Raw
                $template = $template -replace "__BASE_DIR__", ($ragDataDir -replace "\\", "/")
                Set-Content -Path $mcpFile -Value $template -Encoding UTF8
                Write-Host "  → $mcpFile $MSG_MCP_FILE_DONE"
            }
            Write-Done
        } else {
            Write-Host "  ❌ $MSG_PROJ_NOT_FOUND $ragProject"
        }
    } else {
        Write-Skip
    }

    # --- Atlassian ---
    Write-Host ""
    Write-Host "  🔗 $MSG_ATL_TITLE" -ForegroundColor Cyan
    Write-Host "  $MSG_ATL_DESC"
    Write-Host ""

    if (Ask-YN $MSG_ATL_ASK "N") {
        $OptMcpAtlassian = $true
        $atlUrl = Read-Host "  $MSG_ATL_URL"
        $atlEmail = Read-Host "  $MSG_ATL_EMAIL"
        Write-Host "  $MSG_ATL_TOKEN_DESC"
        Write-Host "  → $MSG_ATL_TOKEN_URL"
        # Mask API token input
        $secureToken = Read-Host "  $MSG_ATL_TOKEN" -AsSecureString
        $atlToken = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken))

        $atlProject = Read-Host "  $MSG_ATL_PATH"

        if (Test-Path $atlProject) {
            $mcpFile = Join-Path $atlProject ".mcp.json"
            if (Test-Path $mcpFile) {
                Write-Host "  ⚠️  $MSG_MCP_FILE_EXISTS"
                Write-Host "  → $MSG_MCP_FILE_REF $ScriptDir\templates\mcp-atlassian.json"
            } else {
                $template = Get-Content "$ScriptDir\templates\mcp-atlassian.json" -Raw
                $template = $template -replace "__ATLASSIAN_URL__", $atlUrl
                $template = $template -replace "__ATLASSIAN_EMAIL__", $atlEmail
                $template = $template -replace "__ATLASSIAN_API_TOKEN__", $atlToken
                Set-Content -Path $mcpFile -Value $template -Encoding UTF8
                Write-Host "  → $mcpFile $MSG_MCP_FILE_DONE"
            }
            Write-Done
        } else {
            Write-Host "  ❌ $MSG_PROJ_NOT_FOUND $atlProject"
        }
    } else {
        Write-Skip
    }

} else {
    Write-Skip
}

# === 4. Save config.json + summary ===
if ($OptWorkspace) {
    New-Item -ItemType Directory -Path $Workspace -Force | Out-Null
    $projectsJson = ($ConnectedProjects | ForEach-Object { "`"$_`"" }) -join ", "

    $configContent = @"
{
  "language": "$UserLang",
  "languageName": "$LangName",
  "os": "windows",
  "installedAt": "$(Get-Date -Format 'yyyy-MM-dd')",
  "options": {
    "workspace": $($OptWorkspace.ToString().ToLower()),
    "obsidian": $($OptObsidian.ToString().ToLower()),
    "mcp": {
      "localRag": $($OptMcpRag.ToString().ToLower()),
      "atlassian": $($OptMcpAtlassian.ToString().ToLower())
    }
  },
  "projects": [$projectsJson]
}
"@

    Set-Content -Path $ConfigFile -Value $configContent -Encoding UTF8
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor White
Write-Host "✨ $MSG_COMPLETE" -ForegroundColor Green
Write-Host ""
Write-Host "  $MSG_USAGE"
Write-Host ""
if ($OptWorkspace -and (Test-Path $Workspace)) {
    Write-Host "  📁 $MSG_INFO_WORKSPACE ~\claude-workspace\"
    Write-Host "  🤖 $MSG_INFO_AGENTS"
    Write-Host "  🌐 $MSG_INFO_LANGUAGE $LangName"
    Write-Host "  ⚙️  $MSG_INFO_CONFIG ~\claude-workspace\config.json"
    Write-Host ""
    Write-Host "  💡 $MSG_TIP_ADD_PROJECT"
    Write-Host "     $MSG_TIP_ADD_CMD"
}
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor White
Write-Host ""
