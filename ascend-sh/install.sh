#!/usr/bin/env bash
# ASCEND//SH installer — Arch Linux
# Usage:  chmod +x install.sh && ./install.sh
set -euo pipefail

C1=$'\e[38;2;200;128;255m'; C2=$'\e[38;2;255;210;122m'; N=$'\e[0m'
say()  { printf '%s[ascend]%s %s\n' "$C1" "$N" "$1"; }
warn() { printf '%s[ascend]%s %s\n' "$C2" "$N" "$1"; }

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
backup_copy "$HERE/kitty/ascend-sh.png"     "$CFG/kitty/ascend-sh.png"
backup_copy "$HERE/starship/starship.toml"  "$CFG/starship.toml"
backup_copy "$HERE/fastfetch/config.jsonc"  "$CFG/fastfetch/config.jsonc"
backup_copy "$HERE/fastfetch/logo.txt"      "$CFG/fastfetch/logo.txt"
backup_copy "$HERE/zsh/ascend-sh.zsh"       "$CFG/ascend-sh/ascend-sh.zsh"
backup_copy "$HERE/zsh/ascend-sh-boot.sh"   "$CFG/ascend-sh/ascend-sh-boot.sh"
backup_copy "$HERE/zsh/banner.txt"          "$CFG/ascend-sh/banner.txt"
chmod +x "$CFG/ascend-sh/ascend-sh-boot.sh"

# 3) Hook into ~/.zshrc ─────────────────────────────────────
touch "$HOME/.zshrc"
cp "$HOME/.zshrc" "$HOME/.zshrc.bak-$STAMP"

# switch off any other Terminal-skin theme so two themes never stack
for other in "ghostshell/ghostshell.zsh" "redops/redops.zsh" "nebula-drift/nebula-drift.zsh" "void-signal/void-signal.zsh" "pulsar-wave/pulsar-wave.zsh" "seraph-os/seraph-os.zsh" "cloud9/cloud9.zsh" "eden-root/eden-root.zsh" "halo-ctl/halo-ctl.zsh" "inferno-sh/inferno-sh.zsh" "abyss-ctl/abyss-ctl.zsh"; do
  re="${other//./[.]}"
  if grep -qE "^[[:space:]]*[^#[:space:]].*${re}" "$HOME/.zshrc"; then
    sed -i --follow-symlinks -E "\|${re}|{/^[[:space:]]*#/!s/^/# /}" "$HOME/.zshrc"
    say "disabled ${other%%/*} in ~/.zshrc (commented out, not deleted)"
  fi
done

LINE='[[ -f ~/.config/ascend-sh/ascend-sh.zsh ]] && source ~/.config/ascend-sh/ascend-sh.zsh'
if grep -qE '^[[:space:]]*\[\[ -f ~/\.config/ascend-sh/ascend-sh\.zsh' "$HOME/.zshrc"; then
  say "~/.zshrc already loads ASCEND//SH"
elif grep -qE '^[[:space:]]*#+[[:space:]]*\[\[ -f ~/\.config/ascend-sh/ascend-sh\.zsh' "$HOME/.zshrc"; then
  sed -i --follow-symlinks -E 's|^[[:space:]]*#+[[:space:]]*(\[\[ -f ~/\.config/ascend-sh/ascend-sh\.zsh)|\1|' "$HOME/.zshrc"
  say "re-enabled ASCEND//SH in ~/.zshrc"
else
  printf '\n# ASCEND//SH\n%s\n' "$LINE" >> "$HOME/.zshrc"
  say "added ASCEND//SH to ~/.zshrc"
fi

# 4) Default shell → zsh ───────────────────────────────────
if [[ "$(basename "${SHELL:-}")" != "zsh" ]]; then
  read -rp "$(printf '%s[ascend]%s make zsh your default shell? [y/N] ' "$C1" "$N")" ans
  if [[ "${ans,,}" == "y" ]]; then
    chsh -s "$(command -v zsh)"
    say "default shell changed — log out and back in to apply."
  fi
fi

printf '\n%s▴ ASCEND//SH ready. Open a new kitty window and climb.%s\n' "$C1" "$N"
