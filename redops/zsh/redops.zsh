# ╔══════════════════════════════════════════════╗
# ║  RED//OPS — zsh layer                        ║
# ║  sourced from ~/.zshrc                       ║
# ╚══════════════════════════════════════════════╝

OPS_DIR="$HOME/.config/redops"

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
zstyle ':completion:*:descriptions' format '%F{yellow}── %d ──%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Plugins (from pacman) ──────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5a2a30'
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[command]='fg=#e8d6d6,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#e8d6d6,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#ff5c70,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#ff5c70,bold'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#ff1f3d,bold,underline'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff1f3d,bold'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#ffb000'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#2de2e6'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#2de2e6'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#9cff57'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#9cff57'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#5a2a30,italic'
fi

# ── Tool colors ────────────────────────────────
export BAT_THEME="ansi"
export LESS="-R"
export EDITOR="${EDITOR:-nvim}"
export EZA_COLORS="di=38;2;255;176;0:ex=38;2;255;31;61;1:ln=38;2;45;226;230"

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
alias boot="OPS_BOOT=full $OPS_DIR/ops-boot.sh"
alias intel='fastfetch'
alias scan='ss -tulpn'
alias myip='curl -s ifconfig.me; echo'

# ── Prompt ─────────────────────────────────────
command -v starship >/dev/null && eval "$(starship init zsh)"

# ── Opening sequence (once per terminal window) ─
# set OPS_BOOT=quick or off in ~/.zshrc to tone it down
if [[ -o interactive && -z "$OPS_BOOT_DONE" ]]; then
  export OPS_BOOT_DONE=1
  "$OPS_DIR/ops-boot.sh"
fi
