# ╔══════════════════════════════════════════════╗
# ║  ASCEND//SH — zsh layer                      ║
# ║  sourced from ~/.zshrc                       ║
# ╚══════════════════════════════════════════════╝

ASCEND_DIR="$HOME/.config/ascend-sh"

# Opening sequence: full | quick | off
export ASCEND_BOOT="${ASCEND_BOOT:-full}"

# ── History ────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY INC_APPEND_HISTORY
setopt AUTO_CD INTERACTIVE_COMMENTS

# ── Completion ─────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*:descriptions' format '%F{magenta}── %d ──%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Plugins (from pacman) ──────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#4c4063'
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[command]='fg=#ece4ff,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#ece4ff,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#c880ff,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#c880ff,bold'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#f2c8ff,bold,underline'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff7096,bold'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#f2c8ff'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#ffd27a'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#ffd27a'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#8ee6b0'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#8ee6b0'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#8a7aab,italic'
fi

# ── Tool colors ────────────────────────────────
export BAT_THEME="ansi"
export LESS="-R"
export EDITOR="${EDITOR:-nvim}"
export EZA_COLORS="di=38;2;242;200;255:ex=38;2;200;128;255;1:ln=38;2;255;210;122"

# ── Aliases ────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first --git'
alias tree='eza --tree --icons --level=3'
alias cat='bat --paging=never --style=plain'
alias grep='grep --color=auto'
alias cls='clear'
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias rain='cmatrix -b -C magenta'
alias rise='cmatrix -b -C magenta'
alias boot="ASCEND_BOOT=full $ASCEND_DIR/ascend-sh-boot.sh"
alias climb='boot'
alias info='fastfetch'
alias summit='fastfetch'
alias scan='ss -tulpn'
alias myip='curl -s ifconfig.me; echo'

# ── Prompt ─────────────────────────────────────
command -v starship >/dev/null && eval "$(starship init zsh)"

# ── Opening sequence (once per terminal window) ─
if [[ -o interactive && -z "$ASCEND_BOOT_DONE" ]]; then
  export ASCEND_BOOT_DONE=1
  "$ASCEND_DIR/ascend-sh-boot.sh"
fi
