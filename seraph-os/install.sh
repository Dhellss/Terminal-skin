#!/usr/bin/env bash
# SERAPH//OS installer — Arch Linux
# Usage:  chmod +x install.sh && ./install.sh
set -euo pipefail

C1=$'\e[38;2;216;177;58m'; C2=$'\e[38;2;240;204;90m'; N=$'\e[0m'
say()  { printf '%s[seraph]%s %s\n' "$C1" "$N" "$1"; }
warn() { printf '%s[seraph]%s %s\n' "$C2" "$N" "$1"; }

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"

if ! command -v pacman >/dev/null; then
  warn "pacman not found — this installer is for Arch Linux (or Arch-based distros)."
  exit 1
fi

# 1) Packages ─────────────────────────────────────────────
PKGS=(kitty zsh starship fastfetch eza bat cmatrix iproute2
      ttf-jetbrains-mono-nerd zsh-autosuggestions zsh-syntax-highlighting)
say "installing packages: ${PKGS[*]}"
sudo pacman -S --needed --noconfirm "${PKGS[@]}"

# 2) Copy configs (anything existing is backed up first) ──
backup_copy() {            # backup_copy <src> <dest>
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" ]]; then
    mv "$dest" "$dest.bak-$STAMP"
    say "backed up $dest → ${dest##*/}.bak-$STAMP"
  fi
  cp "$src" "$dest"
  say "installed $dest"
}

backup_copy "$HERE/kitty/kitty.conf"        "$CFG/kitty/kitty.conf"
backup_copy "$HERE/kitty/seraph-os.png"     "$CFG/kitty/seraph-os.png"
backup_copy "$HERE/starship/starship.toml"  "$CFG/starship.toml"
backup_copy "$HERE/fastfetch/config.jsonc"  "$CFG/fastfetch/config.jsonc"
backup_copy "$HERE/fastfetch/logo.txt"      "$CFG/fastfetch/logo.txt"
backup_copy "$HERE/zsh/seraph-os.zsh"       "$CFG/seraph-os/seraph-os.zsh"
backup_copy "$HERE/zsh/seraph-os-boot.sh"   "$CFG/seraph-os/seraph-os-boot.sh"
backup_copy "$HERE/zsh/banner.txt"          "$CFG/seraph-os/banner.txt"
chmod +x "$CFG/seraph-os/seraph-os-boot.sh"

# 3) Hook into ~/.zshrc ─────────────────────────────────────
touch "$HOME/.zshrc"
cp "$HOME/.zshrc" "$HOME/.zshrc.bak-$STAMP"

# switch off any other Terminal-skin theme so two themes never stack
for other in "ghostshell/ghostshell.zsh" "redops/redops.zsh" "nebula-drift/nebula-drift.zsh" "void-signal/void-signal.zsh" "pulsar-wave/pulsar-wave.zsh" "cloud9/cloud9.zsh" "eden-root/eden-root.zsh" "ascend-sh/ascend-sh.zsh" "halo-ctl/halo-ctl.zsh" "inferno-sh/inferno-sh.zsh" "abyss-ctl/abyss-ctl.zsh"; do
  re="${other//./[.]}"
  if grep -qE "^[[:space:]]*[^#[:space:]].*${re}" "$HOME/.zshrc"; then
    sed -i --follow-symlinks -E "\|${re}|{/^[[:space:]]*#/!s/^/# /}" "$HOME/.zshrc"
    say "disabled ${other%%/*} in ~/.zshrc (commented out, not deleted)"
  fi
done

LINE='[[ -f ~/.config/seraph-os/seraph-os.zsh ]] && source ~/.config/seraph-os/seraph-os.zsh'
if grep -qE '^[[:space:]]*\[\[ -f ~/\.config/seraph-os/seraph-os\.zsh' "$HOME/.zshrc"; then
  say "~/.zshrc already loads SERAPH//OS"
elif grep -qE '^[[:space:]]*#+[[:space:]]*\[\[ -f ~/\.config/seraph-os/seraph-os\.zsh' "$HOME/.zshrc"; then
  sed -i --follow-symlinks -E 's|^[[:space:]]*#+[[:space:]]*(\[\[ -f ~/\.config/seraph-os/seraph-os\.zsh)|\1|' "$HOME/.zshrc"
  say "re-enabled SERAPH//OS in ~/.zshrc"
else
  printf '\n# SERAPH//OS\n%s\n' "$LINE" >> "$HOME/.zshrc"
  say "added SERAPH//OS to ~/.zshrc"
fi

# 4) Default shell → zsh ───────────────────────────────────
if [[ "$(basename "${SHELL:-}")" != "zsh" ]]; then
  read -rp "$(printf '%s[seraph]%s make zsh your default shell? [y/N] ' "$C1" "$N")" ans
  if [[ "${ans,,}" == "y" ]]; then
    chsh -s "$(command -v zsh)"
    say "default shell changed — log out and back in to apply."
  fi
fi

printf '\n%s† SERAPH//OS has risen. Open a new kitty window.%s\n' "$C1" "$N"
