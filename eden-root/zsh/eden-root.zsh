# ╔══════════════════════════════════════════════╗
# ║  EDEN//ROOT — zsh layer                      ║
# ║  sourced from ~/.zshrc                       ║
# ╚══════════════════════════════════════════════╝

EDEN_DIR="$HOME/.config/eden-root"

# Opening sequence: full | quick | off
export EDEN_BOOT="${EDEN_BOOT:-full}"

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
zstyle ':completion:*:descriptions' format '%F{green}── %d ──%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Plugins (from pacman) ──────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#385946'
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[command]='fg=#e2f2e4,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#e2f2e4,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#50d890,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#50d890,bold'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#e8f0d0,bold,underline'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff6b6b,bold'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#e8f0d0'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#e8d27a'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#e8d27a'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#50d890'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#50d890'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#72a084,italic'
fi

# ── Tool colors ────────────────────────────────
export BAT_THEME="ansi"
export LESS="-R"
export EDITOR="${EDITOR:-nvim}"
export EZA_COLORS="di=38;2;232;240;208:ex=38;2;80;216;144;1:ln=38;2;232;210;122"

# ── Aliases ────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first --git'
alias tree='eza --tree --icons --level=3'
alias cat='bat --paging=never --style=plain'
alias grep='grep --color=auto'
alias cls='clear'
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias rain='cmatrix -b -C green'
alias vines='cmatrix -b -C green'
alias boot="EDEN_BOOT=full $EDEN_DIR/eden-root-boot.sh"
alias genesis='boot'
alias info='fastfetch'
alias garden='fastfetch'
alias scan='ss -tulpn'
alias myip='curl -s ifconfig.me; echo'

# ── Prompt ─────────────────────────────────────
command -v starship >/dev/null && eval "$(starship init zsh)"

# ── Opening sequence (once per terminal window) ─
if [[ -o interactive && -z "$EDEN_BOOT_DONE" ]]; then
  export EDEN_BOOT_DONE=1
  "$EDEN_DIR/eden-root-boot.sh"
fi
