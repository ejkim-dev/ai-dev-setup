# === General settings ===
export LANG=en_US.UTF-8
export EDITOR=vim

# === History ===
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# === zsh plugins ===
# Load plugins installed via Homebrew
if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# === Prompt customization (agnoster theme) ===
prompt_context() {
  emojis=("🔥" "👑" "😎" "🍺" "🐵" "🦄" "🌈" "🚀" "🐧" "🎉" "🐱" "🐶" "🦋" "🔅")
  RAND_EMOJI_N=$(( $RANDOM % ${#emojis[@]} + 1))
  prompt_segment black default "%(!.%{%F{yellow}%}.) $USER ${emojis[$RAND_EMOJI_N]} "
}

# === Useful aliases ===
alias ll="ls -la"
alias gs="git status"
alias gl="git log --oneline -20"
