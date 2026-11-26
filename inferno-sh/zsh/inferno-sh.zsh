# ╔══════════════════════════════════════════════╗
# ║  INFERNO//SH — zsh layer                     ║
# ║  sourced from ~/.zshrc                       ║
# ╚══════════════════════════════════════════════╝

INFERNO_DIR="$HOME/.config/inferno-sh"

# Opening sequence: full | quick | off
export INFERNO_BOOT="${INFERNO_BOOT:-full}"

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
zstyle ':completion:*:descriptions' format '%F{yellow}━━ %d ━━%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Plugins (from pacman) ──────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5f311a'
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[command]='fg=#ffd9b3,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#ffd9b3,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#ff4500,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#ff4500,bold'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#ffb020,bold,underline'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff2a00,bold'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#ffb020'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#ffb020'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#ffb020'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#c2d94c'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#c2d94c'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#a8683f,italic'
fi

# ── Tool colors ────────────────────────────────
export BAT_THEME="ansi"
export LESS="-R"
export EDITOR="${EDITOR:-nvim}"
export EZA_COLORS="di=38;2;255;176;32:ex=38;2;255;69;0;1:ln=38;2;255;176;32"

# ── Aliases ────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first --git'
alias tree='eza --tree --icons --level=3'
alias cat='bat --paging=never --style=plain'
alias grep='grep --color=auto'
alias cls='clear'
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias rain='cmatrix -b -C red'
alias cinders='cmatrix -b -C red'
alias boot="INFERNO_BOOT=full $INFERNO_DIR/inferno-sh-boot.sh"
alias ignite='boot'
alias info='fastfetch'
alias brimstone='fastfetch'
alias scan='ss -tulpn'
alias myip='curl -s ifconfig.me; echo'

# ── Prompt ─────────────────────────────────────
command -v starship >/dev/null && eval "$(starship init zsh)"

# ── Opening sequence (once per terminal window) ─
if [[ -o interactive && -z "$INFERNO_BOOT_DONE" ]]; then
  export INFERNO_BOOT_DONE=1
  "$INFERNO_DIR/inferno-sh-boot.sh"
fi
