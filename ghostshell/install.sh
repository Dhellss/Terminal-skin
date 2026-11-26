#!/usr/bin/env bash
# GHOST//SHELL installer — Arch Linux
# Usage:  chmod +x install.sh && ./install.sh
set -euo pipefail

G=$'\e[38;2;0;255;156m'; C=$'\e[38;2;0;229;255m'; R=$'\e[38;2;255;46;99m'; N=$'\e[0m'
say()  { printf '%s[ghost]%s %s\n' "$G" "$N" "$1"; }
warn() { printf '%s[ghost]%s %s\n' "$R" "$N" "$1"; }

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"

if ! command -v pacman >/dev/null; then
  warn "pacman not found — this installer is for Arch Linux (or Arch-based distros)."
  exit 1
fi

# 1) Packages ─────────────────────────────────────────────
PKGS=(kitty zsh starship fastfetch eza bat cmatrix
      ttf-jetbrains-mono-nerd zsh-autosuggestions zsh-syntax-highlighting)
say "installing packages: ${PKGS[*]}"
sudo pacman -S --needed --noconfirm "${PKGS[@]}"

# 2) Copy configs (backs up anything that already exists) ─
backup_copy() {            # backup_copy <src> <dest>
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" ]]; then
    mv "$dest" "$dest.bak-$STAMP"
    say "backed up $dest → $dest.bak-$STAMP"
  fi
  cp "$src" "$dest"
  say "installed $dest"
}

backup_copy "$HERE/kitty/kitty.conf"          "$CFG/kitty/kitty.conf"
backup_copy "$HERE/starship/starship.toml"    "$CFG/starship.toml"
backup_copy "$HERE/fastfetch/config.jsonc"    "$CFG/fastfetch/config.jsonc"
backup_copy "$HERE/zsh/ghostshell.zsh"        "$CFG/ghostshell/ghostshell.zsh"
backup_copy "$HERE/zsh/ghost-boot.sh"         "$CFG/ghostshell/ghost-boot.sh"
chmod +x "$CFG/ghostshell/ghost-boot.sh"

if command -v alacritty >/dev/null; then
  backup_copy "$HERE/alacritty/alacritty.toml" "$CFG/alacritty/alacritty.toml"
fi

# 3) Hook into ~/.zshrc (adds one line, does not overwrite) ─
touch "$HOME/.zshrc"
cp "$HOME/.zshrc" "$HOME/.zshrc.bak-$STAMP"

# switch off any other Terminal-skin theme so two themes never stack
for other in "redops/redops.zsh" "nebula-drift/nebula-drift.zsh" "void-signal/void-signal.zsh" "pulsar-wave/pulsar-wave.zsh" "seraph-os/seraph-os.zsh" "cloud9/cloud9.zsh" "eden-root/eden-root.zsh" "ascend-sh/ascend-sh.zsh" "halo-ctl/halo-ctl.zsh" "inferno-sh/inferno-sh.zsh" "abyss-ctl/abyss-ctl.zsh"; do
  re="${other//./[.]}"
  if grep -qE "^[[:space:]]*[^#[:space:]].*${re}" "$HOME/.zshrc"; then
    sed -i --follow-symlinks -E "\\|${re}|{/^[[:space:]]*#/!s/^/# /}" "$HOME/.zshrc"
    say "disabled ${other%%/*} in ~/.zshrc (commented out, not deleted)"
  fi
done

LINE='[[ -f ~/.config/ghostshell/ghostshell.zsh ]] && source ~/.config/ghostshell/ghostshell.zsh'
if grep -qE '^[[:space:]]*\[\[ -f ~/\.config/ghostshell/ghostshell\.zsh' "$HOME/.zshrc"; then
  say "~/.zshrc already loads GHOST//SHELL"
elif grep -qE '^[[:space:]]*#+[[:space:]]*\[\[ -f ~/\.config/ghostshell/ghostshell\.zsh' "$HOME/.zshrc"; then
  sed -i --follow-symlinks -E 's|^[[:space:]]*#+[[:space:]]*(\[\[ -f ~/\.config/ghostshell/ghostshell\.zsh)|\1|' "$HOME/.zshrc"
  say "re-enabled GHOST//SHELL in ~/.zshrc"
else
  printf '\n# GHOST//SHELL\n%s\n' "$LINE" >> "$HOME/.zshrc"
  say "added GHOST//SHELL to ~/.zshrc"
fi

# 4) Default shell → zsh ───────────────────────────────────
if [[ "$(basename "${SHELL:-}")" != "zsh" ]]; then
  read -rp "$(printf '%s[ghost]%s make zsh your default shell? [y/N] ' "$G" "$N")" ans
  if [[ "${ans,,}" == "y" ]]; then
    chsh -s "$(command -v zsh)"
    say "default shell changed — log out and back in to apply."
  fi
fi

printf '\n%s>> GHOST//SHELL installed.%s Open a new kitty window to boot in.\n' "$C" "$N"
