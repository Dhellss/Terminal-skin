# ╔══════════════════════════════════════════════╗
# ║  CLOUD//9 — zsh layer                        ║
# ║  sourced from ~/.zshrc                       ║
# ╚══════════════════════════════════════════════╝

CLOUD9_DIR="$HOME/.config/cloud9"

# Opening sequence: full | quick | off
export CLOUD9_BOOT="${CLOUD9_BOOT:-full}"

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
zstyle ':completion:*:descriptions' format '%F{blue}── %d ──%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Plugins (from pacman) ──────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#3b5068'
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[command]='fg=#e3f1ff,bold'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=#e3f1ff,bold'
  ZSH_HIGHLIGHT_STYLES[alias]='fg=#60b8ff,bold'
  ZSH_HIGHLIGHT_STYLES[function]='fg=#60b8ff,bold'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=#d6ebff,bold,underline'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff7a90,bold'
  ZSH_HIGHLIGHT_STYLES[path]='fg=#d6ebff'
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#ffb3d1'
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#ffb3d1'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#7ee0b0'
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#7ee0b0'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#7590ad,italic'
fi

# ── Tool colors ────────────────────────────────
export BAT_THEME="ansi"
export LESS="-R"
export EDITOR="${EDITOR:-nvim}"
export EZA_COLORS="di=38;2;214;235;255:ex=38;2;96;184;255;1:ln=38;2;255;179;209"

# ── Aliases ────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first --git'
alias tree='eza --tree --icons --level=3'
alias cat='bat --paging=never --style=plain'
alias grep='grep --color=auto'
alias cls='clear'
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias rain='cmatrix -b -C blue'
alias drizzle='cmatrix -b -C blue'
alias boot="CLOUD9_BOOT=full $CLOUD9_DIR/cloud9-boot.sh"
alias float='boot'
alias info='fastfetch'
alias sky='fastfetch'
alias scan='ss -tulpn'
alias myip='curl -s ifconfig.me; echo'

# ── Prompt ─────────────────────────────────────
command -v starship >/dev/null && eval "$(starship init zsh)"

# ── Opening sequence (once per terminal window) ─
if [[ -o interactive && -z "$CLOUD9_BOOT_DONE" ]]; then
  export CLOUD9_BOOT_DONE=1
  "$CLOUD9_DIR/cloud9-boot.sh"
fi
