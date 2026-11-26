# ╔══════════════════════════════════════════════╗
# ║  NEBULA//DRIFT — zsh layer                   ║
# ║  sourced from ~/.zshrc                       ║
# ╚══════════════════════════════════════════════╝

DRIFT_DIR="$HOME/.config/nebula-drift"

# Opening sequence: full | quick | off
export DRIFT_BOOT="${DRIFT_BOOT:-full}"

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
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#513a73'
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[command]='fg=#e2d6ff,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#e2d6ff,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#c850ff,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#c850ff,bold'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#e040fb,bold,underline'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff4d7d,bold'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#e040fb'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#3a86ff'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#3a86ff'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#5cf2b5'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#5cf2b5'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#8a70b8,italic'
fi

# ── Tool colors ────────────────────────────────
export BAT_THEME="ansi"
export LESS="-R"
export EDITOR="${EDITOR:-nvim}"
export EZA_COLORS="di=38;2;224;64;251:ex=38;2;200;80;255;1:ln=38;2;58;134;255"

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
alias stardust='cmatrix -b -C magenta'
alias boot="DRIFT_BOOT=full $DRIFT_DIR/nebula-drift-boot.sh"
alias drift='boot'
alias info='fastfetch'
alias starmap='fastfetch'
alias scan='ss -tulpn'
alias myip='curl -s ifconfig.me; echo'

# ── Prompt ─────────────────────────────────────
command -v starship >/dev/null && eval "$(starship init zsh)"

# ── Opening sequence (once per terminal window) ─
if [[ -o interactive && -z "$DRIFT_BOOT_DONE" ]]; then
  export DRIFT_BOOT_DONE=1
  "$DRIFT_DIR/nebula-drift-boot.sh"
fi
