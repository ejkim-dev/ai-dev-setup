#Requires -Version 5.1
#
# Claude Code Setup: workspace, agents, MCP servers, Obsidian
#
$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Workspace = "$env:USERPROFILE\claude-workspace"
$ConfigFile = "$Workspace\config.json"

# Debug mode: set DEV_SETUP_DEBUG=1 to enable
$DebugMode = $env:DEV_SETUP_DEBUG -eq "1"
function Write-Dbg($msg) {
    if ($script:DebugMode) {
        Write-Host "  [DEBUG] $msg" -ForegroundColor DarkGray
    }
}

function Write-Done() {
    Write-Host "  ✅ $MSG_DONE" -ForegroundColor Green
}

function Write-Skip() {
    Write-Host "  ⏭  $MSG_SKIP" -ForegroundColor Yellow
}

# Arrow key based menu selector (replaces Ask-YN)
# Usage: Select-Menu "Yes" "No" | returns 0 or 1
function Select-Menu {
    param([Parameter(Mandatory=$true)][string[]]$Options)

    $selected = 0
    $maxIndex = $Options.Count - 1

    # Show initial menu
    Write-Host ""
    for ($i = 0; $i -lt $Options.Count; $i++) {
        if ($i -eq $selected) {
            Write-Host "  ▸ $($Options[$i])" -ForegroundColor Cyan
        } else {
            Write-Host "    $($Options[$i])"
        }
    }
    Write-Host ""

    while ($true) {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

        switch ($key.VirtualKeyCode) {
            38 {  # Up arrow
                if ($selected -gt 0) {
                    $selected--
                    # Redraw menu
                    $cursorTop = [Console]::CursorTop - $Options.Count - 1
                    [Console]::CursorTop = [Math]::Max(0, $cursorTop)
                    Write-Host ""
                    for ($i = 0; $i -lt $Options.Count; $i++) {
                        if ($i -eq $selected) {
                            Write-Host "  ▸ $($Options[$i])" -ForegroundColor Cyan
                        } else {
                            Write-Host "    $($Options[$i])"
                        }
                    }
                    Write-Host ""
                }
            }
            40 {  # Down arrow
                if ($selected -lt $maxIndex) {
                    $selected++
                    # Redraw menu
                    $cursorTop = [Console]::CursorTop - $Options.Count - 1
                    [Console]::CursorTop = [Math]::Max(0, $cursorTop)
                    Write-Host ""
                    for ($i = 0; $i -lt $Options.Count; $i++) {
                        if ($i -eq $selected) {
                            Write-Host "  ▸ $($Options[$i])" -ForegroundColor Cyan
                        } else {
                            Write-Host "    $($Options[$i])"
                        }
                    }
                    Write-Host ""
                }
            }
            13 {  # Enter
                return $selected
            }
        }
    }
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

# Safety check: validate path before deletion
function Test-SafePath($path) {
    if ([string]::IsNullOrWhiteSpace($path)) { return $false }
    if ($path -eq $env:USERPROFILE) { return $false }
    if ($path -eq "C:\") { return $false }
    if ($path -eq $env:SystemRoot) { return $false }
    if ($path -eq $Workspace) { return $false }
    if ($path -eq "$env:USERPROFILE\.claude") { return $false }
    return $true
}

Write-Dbg "PowerShell $($PSVersionTable.PSVersion) | OS: $([System.Environment]::OSVersion.VersionString)"
Write-Dbg "ScriptDir: $ScriptDir"
Write-Dbg "Workspace: $Workspace"
Write-Host ""
Write-Host "🤖 Claude Code Setup" -ForegroundColor Cyan
Write-Host ""

# === 0. Language selection (always in English) ===
# Check if language was already selected in Phase 1
$langFile = "$env:USERPROFILE\.dev-setup-lang"
if (Test-Path $langFile) {
    $UserLang = Get-Content $langFile
    switch ($UserLang) {
        "ko" {
            $LangName = "한국어"
            $LangInstruction = "- 한국어로 대답할 것`n- 코드, 명령어, 기술 용어 등 필요한 경우에만 영어 사용"
        }
        "ja" {
            $LangName = "日本語"
            $LangInstruction = "- 日本語で回答すること`n- コード、コマンド、技術用語は英語のまま使用"
        }
        default {
            $LangName = "English"
            $LangInstruction = "- Respond in English"
        }
    }
} else {
    # No saved language, ask user
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
$OptMcpFilesystem = $false
$OptMcpSerena = $false
$OptMcpFetch = $false
$OptMcpPuppeteer = $false
$ConnectedProjects = @()

# --- Prerequisite checks ---
Write-Dbg "node: $(if (Get-Command node -ErrorAction SilentlyContinue) { (Get-Command node).Source } else { 'NOT FOUND' })"
Write-Dbg "npm: $(if (Get-Command npm -ErrorAction SilentlyContinue) { (Get-Command npm).Source } else { 'NOT FOUND' })"
Write-Dbg "claude: $(if (Get-Command claude -ErrorAction SilentlyContinue) { (Get-Command claude).Source } else { 'NOT FOUND' })"
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "  ⚠️  $MSG_NODE_NOT_INSTALLED"
    Write-Host "  $MSG_NODE_INSTALL_ASK"
    $choice = Select-Menu "Yes" "No"
    if ($choice -eq 0) {
        try {
            winget install --id OpenJS.NodeJS.LTS -e --accept-source-agreements --accept-package-agreements
            Write-Dbg "winget exit code: $LASTEXITCODE"
            # Refresh PATH so node/npm are available in this session
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
            Write-Dbg "PATH refreshed, npm: $(if (Get-Command npm -ErrorAction SilentlyContinue) { 'FOUND' } else { 'NOT FOUND' })"
            Write-Done
        } catch {
            Write-Host "  ⚠️  Installation failed." -ForegroundColor Yellow
        }
    }
}

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Host "  $MSG_CLAUDE_NOT_INSTALLED"
    Write-Host "  $MSG_INSTALL_NOW"
    $choice = Select-Menu "Yes" "No"
    if ($choice -eq 0) {
        try {
            Write-Host "  Running official Claude Code installer..."
            Write-Dbg "Downloading installer from anthropics/claude-code"

            # Use official Native Installer
            $installerScript = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/anthropics/claude-code/main/install.ps1" -UseBasicParsing | Select-Object -ExpandProperty Content
            Invoke-Expression $installerScript
            Write-Dbg "Installer exit code: $LASTEXITCODE"

            # Refresh PATH so claude command is available in this session
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
            Write-Dbg "PATH refreshed, claude: $(if (Get-Command claude -ErrorAction SilentlyContinue) { 'FOUND' } else { 'NOT FOUND' })"

            # Verify installation succeeded
            if (Get-Command claude -ErrorAction SilentlyContinue) {
                Write-Done
            } else {
                Write-Host ""
                Write-Host "  ⚠️  Claude Code installer ran, but 'claude' not found in PATH yet" -ForegroundColor Yellow
                Write-Host "  $MSG_CLAUDE_RESTART_TERMINAL"
            }
        } catch {
            Write-Host ""
            Write-Host "  ⚠️  Could not install Claude Code automatically" -ForegroundColor Yellow
            Write-Host "  Install it manually from: https://claude.ai/code"
            Write-Host "  Then restart PowerShell to continue."
        }
    } else {
        Write-Host "  Claude Code installation skipped (optional for Phase 2)"
    }
}

# Check symlink capability
$canSymlink = Test-SymlinkCapability
Write-Dbg "Symlink capability: $canSymlink"
if (-not $canSymlink) {
    Write-Host ""
    Write-Host "  ⚠️  $MSG_WS_SYMLINK_NEED_ADMIN" -ForegroundColor Yellow
    Write-Host "  $MSG_WS_SYMLINK_ENABLE"
    Write-Host "  $MSG_WS_SYMLINK_SKIP"
    Write-Host ""
}

# === 1. claude-workspace ===
Write-Host ""
Write-Host "[1/3] $MSG_WS_TITLE" -ForegroundColor Cyan
Write-Host ""
Write-Host "  $MSG_WS_DESC_1"
Write-Host "  $MSG_WS_DESC_2"
Write-Host "  $MSG_WS_DESC_3"
Write-Host ""
Write-Host "  ~\claude-workspace\"
Write-Host "  ├── shared\agents\    ← $MSG_WS_TREE_AGENTS"
Write-Host "  ├── shared\templates\ ← $MSG_WS_TREE_TEMPLATES"
Write-Host "  ├── shared\mcp\       ← MCP configs"
Write-Host "  └── projects\         ← $MSG_WS_TREE_PROJECTS"
Write-Host ""
Write-Host "  $MSG_WS_ASK"
$choice = Select-Menu "Yes" "No"
if ($choice -eq 0) {
    $OptWorkspace = $true

    # Copy setup language resources (for Phase 2 UI messages)
    New-Item -ItemType Directory -Path "$Workspace\setup-lang" -Force | Out-Null
    if (Test-Path "$ScriptDir\locale") {
        Copy-Item "$ScriptDir\locale\*.ps1" "$Workspace\setup-lang\" -Force -ErrorAction SilentlyContinue
    }

    # Create workspace structure (shared/ instead of global/)
    New-Item -ItemType Directory -Path "$Workspace\shared\agents" -Force | Out-Null
    New-Item -ItemType Directory -Path "$Workspace\shared\templates" -Force | Out-Null
    New-Item -ItemType Directory -Path "$Workspace\shared\mcp" -Force | Out-Null
    New-Item -ItemType Directory -Path "$Workspace\projects" -Force | Out-Null

    # Copy shared agents
    foreach ($agentFile in @("workspace-manager.md", "translate.md", "doc-writer.md")) {
        if (Test-Path "$ScriptDir\agents\$agentFile") {
            Copy-Item "$ScriptDir\agents\$agentFile" "$Workspace\shared\agents\" -Force
        }
    }
    Write-Host "  → $MSG_WS_AGENTS_DONE"

    # Copy templates
    if (Test-Path "$ScriptDir\templates") {
        Copy-Item "$ScriptDir\templates\*" "$Workspace\shared\templates\" -Force -ErrorAction SilentlyContinue
    }
    if (Test-Path "$ScriptDir\examples") {
        Copy-Item "$ScriptDir\examples\*" "$Workspace\shared\templates\" -Force -ErrorAction SilentlyContinue
    }
    Write-Host "  → $MSG_WS_TEMPLATES_DONE"

    # Inject language into CLAUDE.local.md template
    $localMdTemplate = "$Workspace\shared\templates\CLAUDE.local.md"
    if (Test-Path $localMdTemplate) {
        $content = Get-Content $localMdTemplate -Raw
        # Replace placeholder with actual multiline instruction
        $resolved = $LangInstruction -replace '`n', "`n"
        $content = $content -replace "__LANGUAGE_INSTRUCTION__", $resolved
        Set-Content -Path $localMdTemplate -Value $content -Encoding UTF8 -NoNewline
    }

    # Create .gitignore for workspace
    $gitignoreContent = @"
# Project-specific (managed separately)
projects/*/

# Setup files (temporary during installation)
setup-lang/

# OS
.DS_Store
Thumbs.db

# Sensitive
*.key
*.pem
*.env
*.secret

# Local overrides
*.local
"@
    Set-Content -Path "$Workspace\.gitignore" -Value $gitignoreContent -Encoding UTF8
    Write-Host "  → .gitignore created"

    # Symlink ~/.claude/agents/
    $claudeAgentsDir = "$env:USERPROFILE\.claude\agents"
    if ($canSymlink) {
        if (Test-Path $claudeAgentsDir) {
            $item = Get-Item $claudeAgentsDir
            if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                Write-Host "  $MSG_WS_SYMLINK_EXISTS"
            } else {
                Write-Host "  ⚠️  $MSG_WS_FOLDER_EXISTS"
                Write-Host "  $MSG_WS_BACKUP_ASK"
                $choice = Select-Menu "Yes" "No"
                if ($choice -eq 0) {
                    Rename-Item $claudeAgentsDir "$claudeAgentsDir.backup"
                    New-Item -ItemType SymbolicLink -Path $claudeAgentsDir -Target "$Workspace\shared\agents" | Out-Null
                    Write-Host "  → $MSG_WS_BACKUP_DONE"
                    Write-Host "  → $MSG_WS_SYMLINK_DONE"
                }
            }
        } else {
            New-Item -ItemType Directory -Path "$env:USERPROFILE\.claude" -Force | Out-Null
            New-Item -ItemType SymbolicLink -Path $claudeAgentsDir -Target "$Workspace\shared\agents" | Out-Null
            Write-Host "  → $MSG_WS_SYMLINK_DONE"
        }
    } else {
        # Fallback: copy agents instead of symlink
        New-Item -ItemType Directory -Path $claudeAgentsDir -Force | Out-Null
        Copy-Item "$Workspace\shared\agents\*" $claudeAgentsDir -Force
        Write-Host "  → $MSG_WS_SYMLINK_SKIP"
    }

    Write-Done

    # --- Project connection ---
    Write-Host ""
    Write-Host "  $MSG_PROJ_DESC_1"
    Write-Host "  $MSG_PROJ_DESC_2"
    Write-Host ""

    while ($true) {
        Write-Host ""
        Write-Host "  $MSG_PROJ_ASK"
        $choice = Select-Menu "Yes" "No"
        if ($choice -ne 0) { break }

        $projectPath = Read-Host "  $MSG_PROJ_PATH"

        # Empty path = skip
        if ([string]::IsNullOrWhiteSpace($projectPath)) {
            Write-Host "  → $MSG_PROJ_SKIP"
            continue
        }

        if (-not (Test-Path $projectPath)) {
            Write-Host "  ❌ $MSG_PROJ_NOT_FOUND $projectPath"
            Write-Host "  → $MSG_PROJ_TRY_AGAIN"
            continue
        }

        # Resolve to full path
        $projectPath = (Resolve-Path $projectPath).Path

        # Check duplicate
        $isDup = $false
        foreach ($cp in $ConnectedProjects) {
            if ($cp.Path -eq $projectPath) {
                $isDup = $true
                break
            }
        }
        if ($isDup) {
            Write-Host "  ⚠️  $MSG_PROJ_ALREADY_CONNECTED"
            Write-Host ""
            continue
        }

        $projectName = Split-Path $projectPath -Leaf

        # Handle name collision with auto-numbering
        $wsProject = "$Workspace\projects\$projectName"
        if (Test-Path $wsProject) {
            Write-Host "  ⚠️  '$projectName' $MSG_PROJ_NAME_CONFLICT"
            Write-Host "  $MSG_PROJ_USE_EXISTING"
            Write-Host "  $MSG_PROJ_USE_EXISTING_YES?"
            $choice = Select-Menu "Use Existing" "Create New"
            if ($choice -ne 0) {
                # Create new with auto-numbering
                $counter = 1
                while (Test-Path "$Workspace\projects\${projectName}_${counter}") {
                    $counter++
                }
                $projectName = "${projectName}_${counter}"
                $wsProject = "$Workspace\projects\$projectName"
                Write-Host "  → $MSG_PROJ_AUTO_NAMED '$projectName'"
            }
        }

        New-Item -ItemType Directory -Path "$wsProject\.claude\agents" -Force | Out-Null

        if (-not (Test-Path "$wsProject\CLAUDE.md")) {
            if (Test-Path "$Workspace\shared\templates\CLAUDE.md") {
                Copy-Item "$Workspace\shared\templates\CLAUDE.md" "$wsProject\CLAUDE.md"
            }
        }

        if (-not (Test-Path "$wsProject\CLAUDE.local.md")) {
            if (Test-Path "$Workspace\shared\templates\CLAUDE.local.md") {
                Copy-Item "$Workspace\shared\templates\CLAUDE.local.md" "$wsProject\CLAUDE.local.md"
            }
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

        $ConnectedProjects += @{ Name = $projectName; Path = $projectPath }

        Write-Host "  ✅ $projectName $MSG_PROJ_DONE" -ForegroundColor Green
        Write-Host ""
    }

} else {
    Write-Skip
}

# === 2. MCP Servers (5 servers, project-specific) ===
Write-Host ""
Write-Host "[2/3] $MSG_MCP_TITLE" -ForegroundColor Cyan
Write-Host ""
Write-Host "  $MSG_MCP_DESC_1"
Write-Host "  $MSG_MCP_DESC_2"
Write-Host "  $MSG_MCP_DESC_3"
Write-Host ""
Write-Host "  $MSG_MCP_ASK"
$choice = Select-Menu "Yes" "No"
if ($choice -eq 0) {
    Write-Host ""
    Write-Host "  $MSG_MCP_SELECT_PROMPT"
    Write-Host ""
    Write-Host "  📦 $MSG_MCP_RECOMMENDED_HEADER"
    Write-Host "  $MSG_MCP_RECOMMENDED_DESC_1"
    Write-Host "  $MSG_MCP_RECOMMENDED_DESC_2"
    Write-Host "  $MSG_MCP_RECOMMENDED_DESC_3"
    Write-Host ""
    Write-Host "  $MSG_MCP_ADDITIONAL_HEADER"
    Write-Host "  $MSG_MCP_ADDITIONAL_DESC_1"
    Write-Host "  $MSG_MCP_ADDITIONAL_DESC_2"
    Write-Host ""
    Write-Host "  1. $MSG_MCP_SERVER_LOCALRAG $MSG_RECOMMENDED"
    Write-Host "  2. $MSG_MCP_SERVER_FILESYSTEM $MSG_RECOMMENDED"
    Write-Host "  3. $MSG_MCP_SERVER_SERENA $MSG_RECOMMENDED"
    Write-Host "  4. $MSG_MCP_SERVER_FETCH"
    Write-Host "  5. $MSG_MCP_SERVER_PUPPETEER"
    Write-Host ""
    Write-Host "  $MSG_MCP_SELECT_HINT"
    $mcpChoice = Read-Host "  Selection [1,2,3]"
    if ([string]::IsNullOrWhiteSpace($mcpChoice)) { $mcpChoice = "1,2,3" }

    $mcpSelections = $mcpChoice -split "," | ForEach-Object { $_.Trim() }
    $McpServers = @()

    foreach ($sel in $mcpSelections) {
        switch ($sel) {
            "1" { $OptMcpRag = $true; $McpServers += "local-rag"; Write-Host ("  → " + ($MSG_MCP_INSTALLING_PREFIX -f "local-rag")) }
            "2" { $OptMcpFilesystem = $true; $McpServers += "filesystem"; Write-Host ("  → " + ($MSG_MCP_INSTALLING_PREFIX -f "filesystem")) }
            "3" { $OptMcpSerena = $true; $McpServers += "serena"; Write-Host ("  → " + ($MSG_MCP_INSTALLING_PREFIX -f "serena")) }
            "4" { $OptMcpFetch = $true; $McpServers += "fetch"; Write-Host ("  → " + ($MSG_MCP_INSTALLING_PREFIX -f "fetch")) }
            "5" { $OptMcpPuppeteer = $true; $McpServers += "puppeteer"; Write-Host ("  → " + ($MSG_MCP_INSTALLING_PREFIX -f "puppeteer")) }
        }
    }

    if ($McpServers.Count -gt 0) {
        Write-Host ""
        Write-Host ("  " + ($MSG_MCP_INSTALLING_COUNT -f $McpServers.Count))
        Write-Host ""

        if ($ConnectedProjects.Count -gt 0) {
            foreach ($proj in $ConnectedProjects) {
                $mcpProjectPath = $proj.Path
                $mcpProjectName = $proj.Name

                Write-Host ""
                Write-Host ("  " + ($MSG_MCP_PROJECT_ASK_EACH -f $mcpProjectName))
                $choice = Select-Menu "Yes" "No"
                if ($choice -eq 0) {
                    $mcpFile = Join-Path $mcpProjectPath ".mcp.json"

                    if (Test-Path $mcpFile) {
                        Write-Host "  ⚠️  $MSG_MCP_FILE_EXISTS"
                    } else {
                        Write-Host ("  → " + ($MSG_MCP_CREATING_FILE -f $mcpFile))

                        # Build .mcp.json dynamically
                        $mcpConfig = @{ mcpServers = @{} }

                        foreach ($server in $McpServers) {
                            switch ($server) {
                                "local-rag" {
                                    $ragDataDir = Join-Path $mcpProjectPath ".claude-data"
                                    New-Item -ItemType Directory -Path $ragDataDir -Force | Out-Null
                                    $mcpConfig.mcpServers["local-rag"] = @{
                                        command = "npx"
                                        args = @("-y", "@local-rag/mcp-server")
                                        env = @{ DATA_PATH = ($ragDataDir -replace "\\", "/") }
                                    }
                                }
                                "filesystem" {
                                    $mcpConfig.mcpServers["filesystem"] = @{
                                        command = "npx"
                                        args = @("-y", "@modelcontextprotocol/server-filesystem", ($mcpProjectPath -replace "\\", "/"))
                                    }
                                }
                                "serena" {
                                    $mcpConfig.mcpServers["serena"] = @{
                                        command = "npx"
                                        args = @("-y", "@serena/mcp-server")
                                    }
                                }
                                "fetch" {
                                    $mcpConfig.mcpServers["fetch"] = @{
                                        command = "npx"
                                        args = @("-y", "@modelcontextprotocol/server-fetch")
                                    }
                                }
                                "puppeteer" {
                                    $mcpConfig.mcpServers["puppeteer"] = @{
                                        command = "npx"
                                        args = @("-y", "@modelcontextprotocol/server-puppeteer")
                                    }
                                }
                            }
                        }

                        Write-Dbg ".mcp.json servers: $($McpServers -join ', ')"
                        $mcpConfig | ConvertTo-Json -Depth 5 | Set-Content -Path $mcpFile -Encoding UTF8
                        Write-Host ("  ✅ " + ($MSG_MCP_FILE_CREATED -f $McpServers.Count)) -ForegroundColor Green
                    }
                }
                Write-Host ""
            }
        } else {
            Write-Host "  $MSG_MCP_NO_PROJECTS"
        }

        Write-Done
    } else {
        Write-Host "  $MSG_MCP_NO_SERVERS"
        Write-Skip
    }

} else {
    Write-Skip
}

# === 3. Obsidian ===
Write-Host ""
Write-Host "[3/3] $MSG_OBS_TITLE" -ForegroundColor Cyan
Write-Host ""
Write-Host "  $MSG_OBS_DESC_1"
Write-Host "  $MSG_OBS_DESC_2"
Write-Host ""
Write-Host "  $MSG_OBS_ASK"
$choice = Select-Menu "Yes" "No"
if ($choice -eq 0) {
    $OptObsidian = $true
    try {
        winget install --id Obsidian.Obsidian -e --accept-source-agreements --accept-package-agreements
        Write-Done
    } catch {
        Write-Host "  ⚠️  Installation failed." -ForegroundColor Yellow
        Write-Skip
    }
} else {
    Write-Skip
}

# === Save config.json + summary ===
if ($OptWorkspace) {
    New-Item -ItemType Directory -Path $Workspace -Force | Out-Null
    $projectsArray = @()
    foreach ($proj in $ConnectedProjects) {
        $projectsArray += @{ name = $proj.Name; path = $proj.Path }
    }

    $configObj = @{
        language = $UserLang
        languageName = $LangName
        os = "windows"
        installedAt = (Get-Date -Format 'yyyy-MM-dd')
        options = @{
            workspace = $OptWorkspace
            obsidian = $OptObsidian
            mcp = @{
                localRag = $OptMcpRag
                filesystem = $OptMcpFilesystem
                serena = $OptMcpSerena
                fetch = $OptMcpFetch
                puppeteer = $OptMcpPuppeteer
            }
        }
        projects = $projectsArray
    }

    $configObj | ConvertTo-Json -Depth 5 | Set-Content -Path $ConfigFile -Encoding UTF8
    Write-Dbg "config.json saved: $ConfigFile"

    # Verify config.json was created
    if (-not (Test-Path $ConfigFile)) {
        Write-Host "  ⚠️  config.json creation failed" -ForegroundColor Yellow
    }
}

# === Next Steps Guide ===
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor White

if ($OptWorkspace -and (Test-Path $Workspace)) {
    Write-Host ""
    Write-Host "  📁 $MSG_INFO_WORKSPACE ~\claude-workspace\"
    Write-Host "  🤖 $MSG_INFO_AGENTS"
    Write-Host "  🌐 $MSG_INFO_LANGUAGE $LangName"
    Write-Host "  ⚙️  $MSG_INFO_CONFIG ~\claude-workspace\config.json"
    Write-Host ""
    Write-Host "  📖 $MSG_NEXT_STEPS"
    Write-Host ""
    Write-Host "  $MSG_STEP_1_TITLE"
    Write-Host "     $MSG_STEP_1_DESC"
    Write-Host "     $MSG_STEP_1_NOTE"
    Write-Host ""
    Write-Host "  $MSG_STEP_2_TITLE"
    Write-Host "     $MSG_STEP_2_DESC"
    Write-Host ""
    Write-Host "  $MSG_STEP_3_TITLE"
    Write-Host "     $MSG_STEP_3_DESC"
    Write-Host "     $MSG_STEP_3_NOTE"
    Write-Host ""
    Write-Host "  📚 $MSG_DOCS_AVAILABLE"
    Write-Host ""
}

# === Cleanup ===
# Remove setup language resources (no longer needed)
if (Test-Path "$Workspace\setup-lang") {
    Remove-Item "$Workspace\setup-lang" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "  🧹 Setup language resources removed"
}

# Remove installation directory (with safety check)
Write-Dbg "Cleanup: removing $ScriptDir"
if ((Test-SafePath $ScriptDir) -and (Test-Path "$ScriptDir\setup-claude.ps1")) {
    Set-Location $env:USERPROFILE
    Remove-Item $ScriptDir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "  🧹 Installation files removed: ~\claude-code-setup\"
} else {
    Write-Host "  ⚠️  Installation directory preserved for safety: $ScriptDir"
}

Write-Host ""
Write-Host "  💡 Version control your workspace:"
Write-Host "     cd ~\claude-workspace"
Write-Host "     git init"
Write-Host "     git add ."
Write-Host "     git commit -m `"Initial Claude workspace`""
Write-Host ""
Write-Host "✨ $MSG_COMPLETE" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor White
Write-Host ""
