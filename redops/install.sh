#!/usr/bin/env bash
# RED//OPS installer — Arch Linux
# Usage:  chmod +x install.sh && ./install.sh
set -euo pipefail

RED=$'\e[38;2;255;31;61m'; AMB=$'\e[38;2;255;176;0m'; N=$'\e[0m'
say()  { printf '%s[ops]%s %s\n' "$RED" "$N" "$1"; }
warn() { printf '%s[ops]%s %s\n' "$AMB" "$N" "$1"; }

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
backup_copy "$HERE/kitty/reticle.png"       "$CFG/kitty/reticle.png"
backup_copy "$HERE/starship/starship.toml"  "$CFG/starship.toml"
backup_copy "$HERE/fastfetch/config.jsonc"  "$CFG/fastfetch/config.jsonc"
backup_copy "$HERE/fastfetch/logo.txt"      "$CFG/fastfetch/logo.txt"
backup_copy "$HERE/zsh/redops.zsh"          "$CFG/redops/redops.zsh"
backup_copy "$HERE/zsh/ops-boot.sh"         "$CFG/redops/ops-boot.sh"
backup_copy "$HERE/zsh/banner.txt"          "$CFG/redops/banner.txt"
chmod +x "$CFG/redops/ops-boot.sh"

# 3) Hook into ~/.zshrc ─────────────────────────────────────
touch "$HOME/.zshrc"
cp "$HOME/.zshrc" "$HOME/.zshrc.bak-$STAMP"

# turn off GHOST//SHELL if it was installed (so the two themes don't stack)
if grep -q "ghostshell/ghostshell.zsh" "$HOME/.zshrc"; then
  sed -i '/ghostshell\/ghostshell.zsh/s/^/# /' "$HOME/.zshrc"
  say "disabled GHOST//SHELL in ~/.zshrc (commented out, not deleted)"
fi

LINE='[[ -f ~/.config/redops/redops.zsh ]] && source ~/.config/redops/redops.zsh'
if ! grep -qF "redops/redops.zsh" "$HOME/.zshrc"; then
  printf '\n# RED//OPS\n%s\n' "$LINE" >> "$HOME/.zshrc"
  say "added RED//OPS to ~/.zshrc"
else
  say "~/.zshrc already loads RED//OPS"
fi

# 4) Default shell → zsh ───────────────────────────────────
if [[ "$(basename "${SHELL:-}")" != "zsh" ]]; then
  read -rp "$(printf '%s[ops]%s make zsh your default shell? [y/N] ' "$RED" "$N")" ans
  if [[ "${ans,,}" == "y" ]]; then
    chsh -s "$(command -v zsh)"
    say "default shell changed — log out and back in to apply."
  fi
fi

printf '\n%s⌖ RED//OPS armed.%s Open a new kitty window.\n' "$RED" "$N"
