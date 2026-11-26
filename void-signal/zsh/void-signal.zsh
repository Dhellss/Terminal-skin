# ╔══════════════════════════════════════════════╗
# ║  VOID//SIGNAL — zsh layer                    ║
# ║  sourced from ~/.zshrc                       ║
# ╚══════════════════════════════════════════════╝

VOID_DIR="$HOME/.config/void-signal"

# Opening sequence: full | quick | off
export VOID_BOOT="${VOID_BOOT:-full}"

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
zstyle ':completion:*:descriptions' format '%F{cyan}── %d ──%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Plugins (from pacman) ──────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#2e515e'
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[command]='fg=#cfeef4,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#cfeef4,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#00f5ff,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#00f5ff,bold'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#b0e0e8,bold,underline'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff5470,bold'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#b0e0e8'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#b0e0e8'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#b0e0e8'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#3dffb4'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#3dffb4'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#5f8b99,italic'
fi

# ── Tool colors ────────────────────────────────
export BAT_THEME="ansi"
export LESS="-R"
export EDITOR="${EDITOR:-nvim}"
export EZA_COLORS="di=38;2;176;224;232:ex=38;2;0;245;255;1:ln=38;2;176;224;232"

# ── Aliases ────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first --git'
alias tree='eza --tree --icons --level=3'
alias cat='bat --paging=never --style=plain'
alias grep='grep --color=auto'
alias cls='clear'
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias rain='cmatrix -b -C cyan'
alias static='cmatrix -b -C cyan'
alias boot="VOID_BOOT=full $VOID_DIR/void-signal-boot.sh"
alias signal='boot'
alias info='fastfetch'
alias trace='fastfetch'
alias scan='ss -tulpn'
alias myip='curl -s ifconfig.me; echo'

# ── Prompt ─────────────────────────────────────
command -v starship >/dev/null && eval "$(starship init zsh)"

# ── Opening sequence (once per terminal window) ─
if [[ -o interactive && -z "$VOID_BOOT_DONE" ]]; then
  export VOID_BOOT_DONE=1
  "$VOID_DIR/void-signal-boot.sh"
fi
