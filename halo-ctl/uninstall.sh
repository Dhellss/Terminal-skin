#!/usr/bin/env bash
# HALO//CTL uninstaller — puts back whatever you had before installing.
# Usage:  chmod +x uninstall.sh && ./uninstall.sh
set -euo pipefail

C1=$'\e[38;2;232;244;255m'; N=$'\e[0m'
say() { printf '%s[halo]%s %s\n' "$C1" "$N" "$1"; }

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"

restore() {                # restore <installed file> <file shipped with this theme>
  local dest="$1" ours="$2" bak
  if [[ -e "$dest" ]] && [[ "$(cksum < "$dest")" != "$(cksum < "$ours")" ]]; then
    cp "$dest" "$dest.edited-$STAMP"          # you changed it — keep a copy
    say "kept your edits in ${dest##*/}.edited-$STAMP"
  fi
  bak=$(ls -1t "$dest".bak-* 2>/dev/null | head -n 1 || true)
  if [[ -n "$bak" ]]; then
    mv -f "$bak" "$dest"
    say "restored $dest from ${bak##*/}"
  elif [[ -e "$dest" ]]; then
    rm -f "$dest"
    say "removed $dest"
  fi
}

restore "$CFG/kitty/kitty.conf"        "$HERE/kitty/kitty.conf"
restore "$CFG/kitty/halo-ctl.png"     "$HERE/kitty/halo-ctl.png"
restore "$CFG/starship.toml"           "$HERE/starship/starship.toml"
restore "$CFG/fastfetch/config.jsonc"  "$HERE/fastfetch/config.jsonc"
restore "$CFG/fastfetch/logo.txt"      "$HERE/fastfetch/logo.txt"
rm -rf "$CFG/halo-ctl" "$HOME/.cache/halo-ctl_sessions"
say "removed $CFG/halo-ctl"

if [[ -f "$HOME/.zshrc" ]] && grep -qE '^[[:space:]]*\[\[ -f ~/\.config/halo-ctl/halo-ctl\.zsh' "$HOME/.zshrc"; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.bak-$STAMP"
  sed -i --follow-symlinks -E 's|^([[:space:]]*\[\[ -f ~/\.config/halo-ctl/halo-ctl\.zsh)|# \1|' "$HOME/.zshrc"
  say "disabled HALO//CTL in ~/.zshrc"
fi

printf '\n%sHALO//CTL removed.%s Open a new terminal. Run any theme'"'"'s install.sh to switch.\n' "$C1" "$N"
