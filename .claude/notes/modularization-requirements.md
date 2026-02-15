# setup.sh Modularization Requirements

## Objective

Refactor `setup.sh` (~1000 lines) into a modular, testable architecture while preserving **exact functionality**. No feature changes, no behavior modifications—only structural improvements.

## Scope

**In scope:**
- Extract reusable utilities to `lib/`
- Separate domain logic to `modules/`
- Create test structure in `test/`
- Reduce main `setup.sh` to orchestration only (~200 lines)
- Update documentation to reflect new structure

**Out of scope:**
- Feature additions or changes
- Windows script (setup.ps1) - will be done separately after macOS
- Performance optimizations (unless zero-cost)
- Locale file content changes (structure only if needed)

## Target Architecture

```
ai-dev-setup/
├── setup.sh                      # [~200 lines] Main orchestration
├── lib/
│   ├── colors.sh                 # [~30 lines] Color codes, formatting
│   ├── core.sh                   # [~50 lines] Global vars, utilities
│   ├── ui.sh                     # [~150 lines] UI components
│   └── installer.sh              # [~100 lines] Package installation
├── modules/
│   ├── xcode.sh                  # [~40 lines] Xcode CLI Tools
│   ├── homebrew.sh               # [~80 lines] Homebrew setup
│   ├── packages.sh               # [~60 lines] Essential packages
│   ├── fonts.sh                  # [~80 lines] Font installation
│   ├── terminal.sh               # [~150 lines] Terminal profiles
│   ├── shell.sh                  # [~120 lines] Oh My Zsh, .zshrc
│   ├── tmux.sh                   # [~50 lines] tmux configuration
│   └── ai-tools.sh               # [~100 lines] AI CLI tools
├── test/
│   ├── unit/
│   │   ├── test_colors.sh
│   │   ├── test_ui.sh
│   │   ├── test_installer.sh
│   │   └── test_*.sh
│   ├── integration/
│   │   └── test_full_install.sh
│   ├── mocks/
│   │   ├── mock_brew.sh
│   │   ├── mock_npm.sh
│   │   └── mock_osascript.sh
│   └── test_runner.sh
├── configs/                      # [unchanged]
├── claude-code/                  # [unchanged]
└── README.md                     # [update with new structure]
```

## Module Specifications

### lib/colors.sh

**Purpose:** Terminal color codes and formatting utilities

**Contents:**
- Color variables (C_CYAN, C_GREEN, C_YELLOW, C_RED, C_RESET)
- Formatting functions if needed

**Dependencies:** None

**Exports:**
```bash
C_CYAN="\033[36m"
C_GREEN="\033[32m"
C_YELLOW="\033[33m"
C_RED="\033[31m"
C_RESET="\033[0m"
```

---

### lib/core.sh

**Purpose:** Global variables and core utilities

**Contents:**
- SCRIPT_DIR detection
- TOTAL step counter
- Platform detection (macOS version, etc.)
- ask_yn function (if still used)
- Common path utilities

**Dependencies:** colors.sh

**Example:**
```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOTAL=5

# Utility: Expand ~ to $HOME
expand_path() {
  local path="$1"
  echo "${path/#\~/$HOME}"
}
```

---

### lib/ui.sh

**Purpose:** All UI components (menus, spinners, prompts)

**Contents:**
- `select_menu()` - Single selection menu
- `select_multi()` - Multi-selection menu with checkboxes
- `spinner()` - Spinner animation
- `run_with_spinner()` - Execute command with spinner
- `ask_yn()` - Y/n prompt (if still used)

**Dependencies:** colors.sh

**Key Functions:**
```bash
select_menu() { ... }         # Single selection
select_multi() { ... }        # Multi-selection with Space/Enter
spinner() { ... }             # Braille spinner animation
run_with_spinner() { ... }   # Run command with spinner feedback
```

---

### lib/installer.sh

**Purpose:** Package installation wrappers

**Contents:**
- `install_brew_package()` - Install with brew, handle errors
- `install_npm_global()` - Install npm package globally
- `check_installed()` - Verify installation
- Common installation error handling

**Dependencies:** colors.sh, ui.sh

**Example:**
```bash
install_brew_package() {
  local package="$1"
  local display_name="$2"

  run_with_spinner "Installing $display_name..." "brew install $package"
  if [ $? -eq 0 ]; then
    echo "  ✅ $display_name"
    return 0
  else
    echo "  ❌ $display_name installation failed"
    return 1
  fi
}
```

---

### modules/xcode.sh

**Purpose:** Xcode Command Line Tools installation

**Contents:**
- Check if Xcode CLI Tools installed
- Install Xcode CLI Tools
- Wait for user confirmation

**Dependencies:** colors.sh, core.sh, ui.sh

**Main Function:**
```bash
install_xcode_tools() {
  # Current Step 1 logic
}
```

---

### modules/homebrew.sh

**Purpose:** Homebrew installation and verification

**Contents:**
- Check if Homebrew installed
- Install Homebrew
- Handle installation failure (admin privileges, manual instructions)
- Verify Homebrew installation

**Dependencies:** colors.sh, core.sh, ui.sh

**Main Function:**
```bash
install_homebrew() {
  # Current Step 2 logic
}
```

---

### modules/packages.sh

**Purpose:** Essential packages installation (Node.js, ripgrep, etc.)

**Contents:**
- Install Node.js (required for AI tools)
- Install ripgrep
- Install tmux
- Install zsh-autosuggestions
- Install zsh-syntax-highlighting
- Verify Node.js installation

**Dependencies:** colors.sh, core.sh, ui.sh, installer.sh

**Main Function:**
```bash
install_essential_packages() {
  # Current Step 3 logic (excluding fonts)
}
```

---

### modules/fonts.sh

**Purpose:** Font installation (D2Coding, D2Coding Nerd Font)

**Contents:**
- Multi-select font menu
- Install D2Coding Nerd Font
- Install D2Coding
- Set SELECTED_FONT variable for terminal config

**Dependencies:** colors.sh, core.sh, ui.sh, installer.sh

**Main Function:**
```bash
install_fonts() {
  # Returns: SELECTED_FONT variable (nerd|d2coding|none)
}
```

---

### modules/terminal.sh

**Purpose:** Terminal.app and iTerm2 configuration

**Contents:**
- Terminal.app profile import (PlistBuddy)
- iTerm2 installation
- iTerm2 profile setup
- Font application logic
- Terminal selection menu (Terminal.app only | iTerm2 | Both | Skip)

**Dependencies:** colors.sh, core.sh, ui.sh, installer.sh, fonts.sh

**Main Function:**
```bash
setup_terminal() {
  local font_choice="$1"  # nerd|d2coding|none
  # Current Step 4 terminal logic
}
```

---

### modules/shell.sh

**Purpose:** Oh My Zsh and shell customization

**Contents:**
- Oh My Zsh installation menu
- .zshrc customization multi-select
- Apply agnoster theme + emoji
- Apply zsh plugins
- Apply command aliases

**Dependencies:** colors.sh, core.sh, ui.sh

**Main Function:**
```bash
setup_shell() {
  # Current Oh My Zsh + .zshrc customization logic
  # Returns: OMZ_INSTALLED variable
}
```

---

### modules/tmux.sh

**Purpose:** tmux installation and configuration

**Contents:**
- tmux installation menu
- .tmux.conf application
- Backup existing config

**Dependencies:** colors.sh, core.sh, ui.sh, installer.sh

**Main Function:**
```bash
setup_tmux() {
  # Current tmux logic
}
```

---

### modules/ai-tools.sh

**Purpose:** AI CLI tools installation (Claude Code, Gemini CLI, etc.)

**Contents:**
- AI tools multi-select menu
- Claude Code installation
- Gemini CLI installation
- Codex CLI installation
- GitHub Copilot CLI installation (with gh check)
- npm availability verification

**Dependencies:** colors.sh, core.sh, ui.sh, installer.sh

**Main Function:**
```bash
install_ai_tools() {
  # Current Step 5 logic
}
```

---

## Main setup.sh Structure

After modularization, `setup.sh` should be ~200 lines:

```bash
#!/bin/bash
set -e

# ===========================
# 1. Bootstrap
# ===========================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source libraries (order matters!)
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/core.sh"
source "$SCRIPT_DIR/lib/ui.sh"
source "$SCRIPT_DIR/lib/installer.sh"

# Source modules
source "$SCRIPT_DIR/modules/xcode.sh"
source "$SCRIPT_DIR/modules/homebrew.sh"
source "$SCRIPT_DIR/modules/packages.sh"
source "$SCRIPT_DIR/modules/fonts.sh"
source "$SCRIPT_DIR/modules/terminal.sh"
source "$SCRIPT_DIR/modules/shell.sh"
source "$SCRIPT_DIR/modules/tmux.sh"
source "$SCRIPT_DIR/modules/ai-tools.sh"

# ===========================
# 2. Language Selection
# ===========================

# [Language selection logic - unchanged]
source "$SCRIPT_DIR/claude-code/locale/$LANG_CODE.sh"

# ===========================
# 3. Welcome
# ===========================

echo "$MSG_SETUP_WELCOME_MAC"
echo "$MSG_SETUP_EACH_STEP"
echo ""

# ===========================
# 4. Installation Steps
# ===========================

# Step 1: Xcode CLI Tools
install_xcode_tools

# Step 2: Homebrew
install_homebrew

# Step 3: Essential Packages
install_essential_packages

# Step 4: Fonts + Terminal
install_fonts
setup_terminal "$SELECTED_FONT"

# Step 5: Shell (Oh My Zsh + .zshrc)
setup_shell

# Step 6: tmux
setup_tmux

# Step 7: AI Tools
install_ai_tools

# ===========================
# 5. Phase 2 Transition
# ===========================

# [Phase 2 setup logic - unchanged]

# ===========================
# 6. Completion
# ===========================

echo ""
echo "$MSG_SETUP_COMPLETE"
```

---

## Test Structure

### test/unit/test_ui.sh

Test select_menu, select_multi, spinner functions:

```bash
#!/bin/bash

source "$(dirname "$0")/../../lib/colors.sh"
source "$(dirname "$0")/../../lib/ui.sh"
source "$(dirname "$0")/../mocks/mock_brew.sh"

# Test select_menu
test_select_menu() {
  # Mock user input: down arrow, Enter
  # Verify MENU_RESULT = 1
}

# Test select_multi
test_select_multi() {
  # Mock user input: Space, down, Space, Enter
  # Verify MULTI_RESULT array
}

# Test spinner
test_spinner() {
  # Verify spinner animation characters
}
```

### test/integration/test_full_install.sh

Full installation test with mocks:

```bash
#!/bin/bash

# Mock all external commands
source "$(dirname "$0")/../mocks/mock_brew.sh"
source "$(dirname "$0")/../mocks/mock_npm.sh"

# Run setup.sh with automated inputs
# Verify expected files created
# Verify locale files sourced correctly
```

### test/mocks/mock_brew.sh

Mock Homebrew commands:

```bash
#!/bin/bash

brew() {
  case "$1" in
    install)
      echo "Mocked: brew install $2"
      return 0
      ;;
    --version)
      echo "Homebrew 4.0.0"
      ;;
  esac
}
```

---

## Migration Plan

### Phase 1: Create lib/ structure (2 tasks)

1. **Extract colors.sh**
   - Move color variables
   - Update all references in setup.sh
   - Test: Colors still work

2. **Extract core.sh**
   - Move SCRIPT_DIR, TOTAL, utilities
   - Update setup.sh to source core.sh
   - Test: Script still runs

3. **Extract ui.sh**
   - Move select_menu, select_multi, spinner functions
   - Update setup.sh to source ui.sh
   - Test: All menus still work

4. **Extract installer.sh**
   - Create install_brew_package, install_npm_global
   - Refactor existing install code to use wrappers
   - Test: Installations still work

**Verification:** setup.sh reduced by ~300 lines, all functions work

---

### Phase 2: Extract modules/ (8 tasks)

1. **Extract xcode.sh** - Step 1 logic
2. **Extract homebrew.sh** - Step 2 logic
3. **Extract packages.sh** - Step 3 logic (Node, ripgrep, tmux, zsh plugins)
4. **Extract fonts.sh** - Font installation logic
5. **Extract terminal.sh** - Terminal.app + iTerm2 logic
6. **Extract shell.sh** - Oh My Zsh + .zshrc logic
7. **Extract tmux.sh** - tmux configuration
8. **Extract ai-tools.sh** - Step 5 logic

**Verification:** setup.sh reduced to ~200 lines, all steps work identically

---

### Phase 3: Testing infrastructure (3 tasks)

1. **Create test structure** - test/unit/, test/integration/, test/mocks/
2. **Write unit tests** - Test lib/ and modules/ functions
3. **Write integration test** - Full setup.sh run with mocks

**Verification:** All tests pass, behavior unchanged

---

### Phase 4: Documentation (2 tasks)

1. **Update README.md** - Document new structure
2. **Create ARCHITECTURE.md** - Explain module design, sourcing order

**Verification:** Documentation accurate and helpful

---

## Quality Criteria

### Functional Requirements

- [ ] All installation steps work identically to original
- [ ] Language selection still works (ko, en, ja)
- [ ] Locale files load correctly
- [ ] All menus respond to keyboard input
- [ ] Spinners animate during installations
- [ ] Error handling preserved
- [ ] Phase 2 transition still works
- [ ] Colors display correctly

### Code Quality

- [ ] Each module < 200 lines
- [ ] Functions have single responsibility
- [ ] No circular dependencies
- [ ] Sourcing order documented
- [ ] All variables properly scoped (local vs global)
- [ ] No global variable pollution
- [ ] Idempotency maintained (re-run safe)

### Testability

- [ ] Each module independently testable
- [ ] Unit tests for lib/ functions
- [ ] Integration test for full flow
- [ ] Mocks provided for external dependencies
- [ ] Test runner executes all tests

### Documentation

- [ ] Each module has header comment
- [ ] Dependencies listed in header
- [ ] README.md updated
- [ ] ARCHITECTURE.md created
- [ ] Migration preserved in git history

---

## Success Metrics

**Before:**
- setup.sh: ~1000 lines
- Testability: Difficult (monolithic)
- Maintainability: Hard to navigate

**After:**
- setup.sh: ~200 lines (orchestration only)
- lib/: 4 files, ~330 lines total
- modules/: 8 files, ~680 lines total
- test/: Full test coverage
- Testability: Easy (isolated modules)
- Maintainability: Clear separation of concerns

---

## Deliverables

1. **Refactored codebase**
   - lib/ folder with 4 files
   - modules/ folder with 8 files
   - Reduced setup.sh (~200 lines)

2. **Test infrastructure**
   - test/unit/ with tests for each module
   - test/integration/ with full flow test
   - test/mocks/ with mock utilities
   - test_runner.sh

3. **Documentation**
   - Updated README.md
   - New ARCHITECTURE.md
   - Module header comments

4. **Verification report**
   - Before/after comparison
   - Test results
   - Behavior verification checklist

---

## Team Delegation

**team-lead**: Coordinate overall modularization effort

**refactor-coordinator**: Lead extraction and module design

**locale-sync**: Verify locale files still load after restructuring

**cross-platform-validator**: Note Windows compatibility patterns for future setup.ps1 refactor

**setup-doc-generator**: Update documentation for new structure

---

## Notes

- **Zero behavior changes**: This is pure refactoring
- **Git commits**: Each phase = separate commit for easy rollback
- **Testing**: Test after each extraction before moving to next
- **Windows**: setup.ps1 will be refactored separately using same patterns
- **Locale files**: Should not need changes, just verify sourcing still works
