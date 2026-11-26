# ╔══════════════════════════════════════════════╗
# ║  GHOST//SHELL — zsh layer                    ║
# ║  sourced from ~/.zshrc                       ║
# ╚══════════════════════════════════════════════╝

GHOST_DIR="$HOME/.config/ghostshell"

# ── History ────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS SHARE_HISTORY INC_APPEND_HISTORY
setopt AUTO_CD INTERACTIVE_COMMENTS

# ── Completion (case-insensitive, menu select) ─
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Plugins (from pacman) ──────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#1f4d36'
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[command]='fg=#00ff9c,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#00ff9c,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#5cffbe,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#5cffbe,bold'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#b026ff,bold'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff2e63,bold'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#00e5ff,underline'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#e6ff00'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#e6ff00'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#1f4d36'
fi

# ── Tool colors ────────────────────────────────
export BAT_THEME="ansi"          # bat follows the terminal palette
export LESS="-R"
export EDITOR="${EDITOR:-nvim}"

# ── Aliases ────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first --git'
alias tree='eza --tree --icons --level=3'
alias cat='bat --paging=never --style=plain'
alias grep='grep --color=auto'
alias cls='clear'
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias matrix='cmatrix -b -C green'
alias hack='cmatrix -b -C green -u 2'
alias boot="GHOST_BOOT=full $GHOST_DIR/ghost-boot.sh"
alias myip='curl -s ifconfig.me; echo'
alias ports='ss -tulpn'

# ── Prompt ─────────────────────────────────────
command -v starship >/dev/null && eval "$(starship init zsh)"

# ── Boot sequence (once per terminal window) ───
# change to GHOST_BOOT=quick or off in ~/.zshrc if it gets old
if [[ -o interactive && -z "$GHOST_BOOT_DONE" ]]; then
  export GHOST_BOOT_DONE=1
  "$GHOST_DIR/ghost-boot.sh"
fi
