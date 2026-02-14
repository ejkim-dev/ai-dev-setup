# Japanese locale

# Prerequisites
$MSG_CLAUDE_NOT_INSTALLED = "Claude Codeがインストールされていません。"
$MSG_INSTALL_NOW = "今すぐインストールしますか？"
$MSG_CLAUDE_REQUIRED = "Claude Codeが必要です。先にインストールしてください："
$MSG_CLAUDE_INSTALL_CMD = "  npm install -g @anthropic-ai/claude-code"
$MSG_NODE_NOT_INSTALLED = "Node.jsがインストールされていません。MCPサーバーに必要です。"
$MSG_NODE_INSTALL_ASK = "wingetでNode.jsをインストールしますか？"
$MSG_NPM_NOT_FOUND = "npmが見つかりません。先にNode.jsをインストールしてください。"

# Common
$MSG_DONE = "完了"
$MSG_SKIP = "スキップ"
$MSG_LANG_SET = "言語："
$MSG_ALREADY_INSTALLED = "既にインストールされています。"
$MSG_INSTALLING = "インストール中..."
$MSG_UPDATING = "更新中..."
$MSG_APPLIED = "適用済み"

# Workspace
$MSG_WS_TITLE = "claude-workspace セットアップ"
$MSG_WS_DESC_1 = "Claude Codeのすべての設定を一か所で管理します。"
$MSG_WS_DESC_2 = "エージェント、CLAUDE.md、プロジェクト設定を一元管理し、"
$MSG_WS_DESC_3 = "シンボリックリンクで各プロジェクトに接続します。"
$MSG_WS_TREE_AGENTS = "グローバルエージェント（全プロジェクトで利用可能）"
$MSG_WS_TREE_PROJECTS = "プロジェクト別設定"
$MSG_WS_TREE_TEMPLATES = "MCP、CLAUDE.mdテンプレート"
$MSG_WS_ASK = "claude-workspaceをセットアップしますか？"
$MSG_WS_AGENTS_DONE = "グローバルエージェントをインストール: workspace-manager, translate, doc-writer"
$MSG_WS_TEMPLATES_DONE = "テンプレートのコピー完了"
$MSG_WS_SYMLINK_EXISTS = "~\.claude\agents\ のシンボリックリンクは既に存在します。"
$MSG_WS_FOLDER_EXISTS = "~\.claude\agents\ フォルダが既に存在します。"
$MSG_WS_BACKUP_ASK = "既存フォルダをバックアップしてシンボリックリンクに置き換えますか？"
$MSG_WS_BACKUP_DONE = "既存フォルダをバックアップ: ~\.claude\agents.backup"
$MSG_WS_SYMLINK_DONE = "シンボリックリンク作成: ~\.claude\agents\ → claude-workspace"
$MSG_WS_SYMLINK_NEED_ADMIN = "Windowsでシンボリックリンクを作成するには、開発者モードまたは管理者権限が必要です。"
$MSG_WS_SYMLINK_ENABLE = "開発者モードを有効化: 設定 → 更新とセキュリティ → 開発者向け"
$MSG_WS_SYMLINK_SKIP = "シンボリックリンクをスキップします。代わりにエージェントフォルダをコピーします。"

# Project
$MSG_PROJ_DESC_1 = "プロジェクトをclaude-workspaceに接続すると、"
$MSG_PROJ_DESC_2 = "CLAUDE.md、エージェント、設定を一元管理できます。"
$MSG_PROJ_ASK = "プロジェクトを接続しますか？"
$MSG_PROJ_PATH = "プロジェクトパス（例: C:\projects\my-app）: "
$MSG_PROJ_NOT_FOUND = "パスが見つかりません："
$MSG_PROJ_EXISTS = "既に存在します。スキップします。"
$MSG_PROJ_LINK_CLAUDE = ".claude\ シンボリックリンク作成"
$MSG_PROJ_LINK_CLAUDEMD = "CLAUDE.md シンボリックリンク作成"
$MSG_PROJ_LINK_LOCALMD = "CLAUDE.local.md シンボリックリンク作成"
$MSG_PROJ_GITIGNORE = ".gitignore 更新"
$MSG_PROJ_DONE = "接続完了"
$MSG_PROJ_NAME_CONFLICT = "がワークスペースに既に存在します。別の名前を入力してください（空欄でスキップ）："

# Obsidian
$MSG_OBS_TITLE = "Obsidian"
$MSG_OBS_DESC_1 = "マークダウンでメモやドキュメントを書くアプリです。"
$MSG_OBS_DESC_2 = "作成したドキュメントをClaude Codeで検索できます。（local-rag連携）"
$MSG_OBS_ASK = "Obsidianをインストールしますか？"

# MCP
$MSG_MCP_TITLE = "MCPサーバー"
$MSG_MCP_DESC_1 = "デフォルトのClaude Codeはファイルの読み書きとターミナルのみ使用します。"
$MSG_MCP_DESC_2 = "MCPサーバーを接続すると、ドキュメント検索やJira連携など、"
$MSG_MCP_DESC_3 = "外部サービスをClaudeが直接使用できます。"
$MSG_MCP_ASK = "MCPサーバーをセットアップしますか？"

# local-rag
$MSG_RAG_TITLE = "local-rag（ドキュメント検索）"
$MSG_RAG_DESC = "PDF、マークダウンなどのドキュメントをClaudeで検索できます。"
$MSG_RAG_ASK = "local-ragをセットアップしますか？"
$MSG_RAG_PATH = "プロジェクトパス（例: C:\projects\my-app）: "
$MSG_MCP_FILE_EXISTS = ".mcp.jsonが既に存在します。手動で追加してください："
$MSG_MCP_FILE_REF = "テンプレート参照："
$MSG_MCP_FILE_DONE = "作成完了"

# Completion
$MSG_COMPLETE = "Claude Codeのセットアップが完了しました！"
$MSG_USAGE = "使い方: プロジェクトフォルダで 'claude' と入力"
$MSG_INFO_WORKSPACE = "ワークスペース："
$MSG_INFO_AGENTS = "グローバルエージェント: workspace-manager, translate, doc-writer"
$MSG_INFO_LANGUAGE = "言語："
$MSG_INFO_CONFIG = "設定ファイル："
$MSG_TIP_ADD_PROJECT = "後でプロジェクトを追加するには、Claude Codeで："
$MSG_TIP_ADD_CMD = "「新しいプロジェクトを接続して」→ workspace-managerが処理"

# ============================
# Parent setup script messages
# ============================

# Welcome
$MSG_SETUP_WELCOME_WIN = "Windows開発環境のセットアップを開始します！"
$MSG_SETUP_EACH_STEP = "各ステップでインストールするかどうかを確認します。"

# Steps
$MSG_STEP_WINGET = "winget（パッケージマネージャー）"
$MSG_STEP_GIT = "Git"
$MSG_STEP_PACKAGES_WIN = "パッケージインストール（Node.js, GitHub CLI, ripgrep）"
$MSG_NODE_REQUIRED = "AIコーディングツール（Claude Code、Gemini CLI）にはNode.jsが必要です。"
$MSG_NODE_MANUAL_INSTALL = "Node.jsを手動でインストールしてください："
$MSG_NODE_VERIFY = "インストールを確認してください："
$MSG_STEP_D2CODING = "D2Coding 開発用フォント"
$MSG_STEP_SSH = "SSHキー生成（GitHub接続用）"
$MSG_STEP_WINTERMINAL = "Windows Terminal テーマ設定"
$MSG_STEP_OHMYPOSH = "Oh My Posh（PowerShellテーマ）"
$MSG_STEP_CLAUDE = "Claude Code"
$MSG_STEP_AI_TOOLS = "AIコーディングツール"
$MSG_AI_TOOLS_HINT = "番号をカンマ区切りで入力（例: 1,2）"

# winget
$MSG_WINGET_NOT_INSTALLED = "wingetがインストールされていません。"
$MSG_WINGET_STORE = "→ Microsoft Storeから 'App Installer' をインストールしてください。"
$MSG_WINGET_UPDATE = "→ または Windows 10 1709 以降にアップデートしてください。"
$MSG_WINGET_ENTER = "インストール後、Enterを押してください..."

# SSH
$MSG_SSH_EXISTS = "SSHキーが既に存在します。"
$MSG_SSH_REGISTER = "既存のキーをGitHubに登録しますか？"
$MSG_SSH_COPIED = "SSH公開鍵がクリップボードにコピーされました！"
$MSG_SSH_GITHUB_URL = "→ https://github.com/settings/keys で 'New SSH key' をクリックして貼り付けてください"
$MSG_SSH_ENTER = "登録完了後、Enterを押してください..."
$MSG_SSH_GENERATE = "SSHキーを生成しますか？"
$MSG_SSH_EMAIL = "GitHubのメールアドレスを入力してください: "

# Windows Terminal
$MSG_WINTERMINAL_NOT_INSTALLED = "Windows Terminalがインストールされていません。"
$MSG_WINTERMINAL_INSTALL = "Windows Terminalをインストールしますか？"
$MSG_WINTERMINAL_APPLY = "Windows Terminalに 'Dev' テーマを適用しますか？"
$MSG_WINTERMINAL_BACKUP = "既存設定をバックアップ："
$MSG_WINTERMINAL_DONE = "Dev テーマ + D2Coding フォント適用完了"
$MSG_WINTERMINAL_RESTORE = "元の設定に戻すには："

# Oh My Posh
$MSG_OHMYPOSH_INSTALL = "Oh My Poshをインストールしますか？"
$MSG_OHMYPOSH_PROFILE = "インストール完了。PowerShellプロファイルに以下を追加してください："

# D2Coding
$MSG_D2CODING_MANUAL = "wingetでインストール失敗。手動インストールが必要な場合があります。"
$MSG_D2CODING_MANUAL_URL = "→ https://github.com/naver/d2codingfont/releases"

# Claude Code (parent)
$MSG_CLAUDE_INSTALL = "Claude Codeをインストールしますか？"
$MSG_CLAUDE_UPDATE_ASK = "Claude Codeを更新しますか？"
$MSG_CLAUDE_EXTRA = "Claude Code追加設定（MCP、RAGなど）は後で実行してください："

# Completion (parent)
$MSG_SETUP_COMPLETE = "インストールが完了しました！"
$MSG_OPEN_NEW_TERMINAL = "新しいターミナルウィンドウを開いて確認してください。"
$MSG_CLAUDE_EXTRA_SETUP = "Claude Code追加設定："
$MSG_EXISTING_FOLDER = "既存のai-dev-setupフォルダがあります。更新します。"

# Install script
$MSG_DOWNLOADING = "ai-dev-setupをダウンロード中..."
$MSG_DOWNLOAD_DONE = "ダウンロード完了"
$MSG_EXTRACT_DONE = "展開完了"
$MSG_INSTALL_LOCATION = "インストール先："
$MSG_STARTING_SETUP = "セットアップを開始します..."
