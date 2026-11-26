# ╔══════════════════════════════════════════════╗
# ║  SERAPH//OS — zsh layer                      ║
# ║  sourced from ~/.zshrc                       ║
# ╚══════════════════════════════════════════════╝

SERAPH_DIR="$HOME/.config/seraph-os"

# Opening sequence: full | quick | off
export SERAPH_BOOT="${SERAPH_BOOT:-full}"

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
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#524d39'
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[command]='fg=#ece4d0,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#ece4d0,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#d8b13a,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#d8b13a,bold'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#6f8fd8,bold,underline'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#e8707a,bold'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#f0e6c8'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#6f8fd8'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#6f8fd8'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#8fd694'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#8fd694'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#8f876d,italic'
fi

# ── Tool colors ────────────────────────────────
export BAT_THEME="ansi"
export LESS="-R"
export EDITOR="${EDITOR:-nvim}"
export EZA_COLORS="di=38;2;240;230;200:ex=38;2;216;177;58;1:ln=38;2;111;143;216"

# ── Aliases ────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first --git'
alias tree='eza --tree --icons --level=3'
alias cat='bat --paging=never --style=plain'
alias grep='grep --color=auto'
alias cls='clear'
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias rain='cmatrix -b -C yellow'
alias embers='cmatrix -b -C yellow'
alias boot="SERAPH_BOOT=full $SERAPH_DIR/seraph-os-boot.sh"
alias bless='boot'
alias info='fastfetch'
alias revelation='fastfetch'
alias scan='ss -tulpn'
alias myip='curl -s ifconfig.me; echo'

# ── Prompt ─────────────────────────────────────
command -v starship >/dev/null && eval "$(starship init zsh)"

# ── Opening sequence (once per terminal window) ─
if [[ -o interactive && -z "$SERAPH_BOOT_DONE" ]]; then
  export SERAPH_BOOT_DONE=1
  "$SERAPH_DIR/seraph-os-boot.sh"
fi
