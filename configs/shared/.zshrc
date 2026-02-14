# === 기본 설정 ===
export LANG=en_US.UTF-8
export EDITOR=vim

# === 히스토리 ===
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# === zsh 플러그인 ===
# Homebrew로 설치한 플러그인 로드
if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# === 유용한 alias ===
alias ll="ls -la"
alias gs="git status"
alias gl="git log --oneline -20"
