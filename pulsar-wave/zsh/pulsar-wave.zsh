# ╔══════════════════════════════════════════════╗
# ║  PULSAR//WAVE — zsh layer                    ║
# ║  sourced from ~/.zshrc                       ║
# ╚══════════════════════════════════════════════╝

PULSAR_DIR="$HOME/.config/pulsar-wave"

# Opening sequence: full | quick | off
export PULSAR_BOOT="${PULSAR_BOOT:-full}"

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
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#45464c'
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[command]='fg=#f5e6c8,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#f5e6c8,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#ffb300,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#ffb300,bold'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#ff7a00,bold,underline'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff5a4d,bold'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#ff7a00'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#3de0ff'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#3de0ff'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#9be564'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#9be564'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#8a8068,italic'
fi

# ── Tool colors ────────────────────────────────
export BAT_THEME="ansi"
export LESS="-R"
export EDITOR="${EDITOR:-nvim}"
export EZA_COLORS="di=38;2;255;122;0:ex=38;2;255;179;0;1:ln=38;2;61;224;255"

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
alias photons='cmatrix -b -C yellow'
alias boot="PULSAR_BOOT=full $PULSAR_DIR/pulsar-wave-boot.sh"
alias pulse='boot'
alias info='fastfetch'
alias observe='fastfetch'
alias scan='ss -tulpn'
alias myip='curl -s ifconfig.me; echo'

# ── Prompt ─────────────────────────────────────
command -v starship >/dev/null && eval "$(starship init zsh)"

# ── Opening sequence (once per terminal window) ─
if [[ -o interactive && -z "$PULSAR_BOOT_DONE" ]]; then
  export PULSAR_BOOT_DONE=1
  "$PULSAR_DIR/pulsar-wave-boot.sh"
fi
