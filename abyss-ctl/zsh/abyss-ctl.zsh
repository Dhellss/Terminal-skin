# ╔══════════════════════════════════════════════╗
# ║  ABYSS//CTL — zsh layer                      ║
# ║  sourced from ~/.zshrc                       ║
# ╚══════════════════════════════════════════════╝

ABYSS_DIR="$HOME/.config/abyss-ctl"

# Opening sequence: full | quick | off
export ABYSS_BOOT="${ABYSS_BOOT:-full}"

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
zstyle ':completion:*:descriptions' format '%F{red}━━ %d ━━%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Plugins (from pacman) ──────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#522828'
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[command]='fg=#e8cccc,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#e8cccc,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#e01010,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#e01010,bold'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#f0e6d8,bold,underline'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff4040,bold'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#f0e6d8'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#f0e6d8'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#f0e6d8'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#6fbf3f'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#6fbf3f'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#8f5a5a,italic'
fi

# ── Tool colors ────────────────────────────────
export BAT_THEME="ansi"
export LESS="-R"
export EDITOR="${EDITOR:-nvim}"
export EZA_COLORS="di=38;2;240;230;216:ex=38;2;224;16;16;1:ln=38;2;240;230;216"

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
alias bleed='cmatrix -b -C red'
alias boot="ABYSS_BOOT=full $ABYSS_DIR/abyss-ctl-boot.sh"
alias descend='boot'
alias info='fastfetch'
alias gaze='fastfetch'
alias scan='ss -tulpn'
alias myip='curl -s ifconfig.me; echo'

# ── Prompt ─────────────────────────────────────
command -v starship >/dev/null && eval "$(starship init zsh)"

# ── Opening sequence (once per terminal window) ─
if [[ -o interactive && -z "$ABYSS_BOOT_DONE" ]]; then
  export ABYSS_BOOT_DONE=1
  "$ABYSS_DIR/abyss-ctl-boot.sh"
fi
