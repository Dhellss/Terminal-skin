# ╔══════════════════════════════════════════════╗
# ║  HALO//CTL — zsh layer                       ║
# ║  sourced from ~/.zshrc                       ║
# ╚══════════════════════════════════════════════╝

HALO_DIR="$HOME/.config/halo-ctl"

# Opening sequence: full | quick | off
export HALO_BOOT="${HALO_BOOT:-full}"

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
zstyle ':completion:*:descriptions' format '%F{white}── %d ──%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Plugins (from pacman) ──────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#424e5b'
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[command]='fg=#eef6ff,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#eef6ff,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#e8f4ff,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#e8f4ff,bold'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#a0c8e0,bold,underline'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff7a85,bold'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#a0c8e0'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#f5d77a'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#f5d77a'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#8de0b5'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#8de0b5'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#7d8c9c,italic'
fi

# ── Tool colors ────────────────────────────────
export BAT_THEME="ansi"
export LESS="-R"
export EDITOR="${EDITOR:-nvim}"
export EZA_COLORS="di=38;2;160;200;224:ex=38;2;232;244;255;1:ln=38;2;245;215;122"

# ── Aliases ────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first --git'
alias tree='eza --tree --icons --level=3'
alias cat='bat --paging=never --style=plain'
alias grep='grep --color=auto'
alias cls='clear'
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias rain='cmatrix -b -C white'
alias radiance='cmatrix -b -C white'
alias boot="HALO_BOOT=full $HALO_DIR/halo-ctl-boot.sh"
alias shine='boot'
alias info='fastfetch'
alias aura='fastfetch'
alias scan='ss -tulpn'
alias myip='curl -s ifconfig.me; echo'

# ── Prompt ─────────────────────────────────────
command -v starship >/dev/null && eval "$(starship init zsh)"

# ── Opening sequence (once per terminal window) ─
if [[ -o interactive && -z "$HALO_BOOT_DONE" ]]; then
  export HALO_BOOT_DONE=1
  "$HALO_DIR/halo-ctl-boot.sh"
fi
