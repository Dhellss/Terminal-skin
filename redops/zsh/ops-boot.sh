#!/usr/bin/env bash
# ops-boot — RED//OPS opening sequence
# The banner "decrypts" from random noise, then shows a briefing with
# REAL info about your machine (user, host, kernel, IP, session count).
#
#   OPS_BOOT=full   → decrypt animation + briefing + fastfetch (default)
#   OPS_BOOT=quick  → fastfetch only
#   OPS_BOOT=off    → nothing

mode="${OPS_BOOT:-full}"
[[ "$mode" == "off" ]] && exit 0
[[ "$mode" == "quick" ]] && { command -v fastfetch >/dev/null && fastfetch; exit 0; }

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RED=$'\e[38;2;255;31;61m'; AMB=$'\e[38;2;255;176;0m'; CYN=$'\e[38;2;45;226;230m'
DIM=$'\e[38;2;61;20;25m'; MUT=$'\e[38;2;138;90;96m'; WHT=$'\e[38;2;232;214;214m'
B=$'\e[1m'; N=$'\e[0m'
NOISE='!@#$%&*<>/\|=+?01░▒▓'

mapfile -t BANNER < "$DIR/banner.txt"
H=${#BANNER[@]}

clear
printf '\e[?25l'                      # hide cursor while animating
trap 'printf "\e[?25h"' EXIT

# ── 1) decrypt the banner ───────────────────────
FRAMES=14
for ((f = 0; f <= FRAMES; f++)); do
  for line in "${BANNER[@]}"; do
    out=""
    for ((i = 0; i < ${#line}; i++)); do
      ch="${line:i:1}"
      if [[ "$ch" == " " ]]; then
        out+=" "
      elif (( RANDOM % FRAMES < f )); then
        out+="$RED$ch"
      else
        out+="$DIM${NOISE:RANDOM%${#NOISE}:1}"
      fi
    done
    printf '  %s%s\e[K\n' "$out" "$N"
  done
  (( f < FRAMES )) && { sleep 0.045; printf '\e[%dA' "$H"; }
done

# ── 2) briefing with real data ─────────────────
count_file="$HOME/.cache/redops_sessions"
mkdir -p "${count_file%/*}"
n=$(( $(cat "$count_file" 2>/dev/null || echo 0) + 1 ))
echo "$n" > "$count_file"

ip=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for (i = 1; i <= NF; i++) if ($i == "src") print $(i + 1)}')
up=$(uptime -p 2>/dev/null | sed 's/^up //')

field() { printf '%s%s %s%s%s' "$MUT" "$1" "$WHT" "$2" "$N"; }
sep="${DIM}  ::  ${N}"

printf '\n  %s%s⟦ SESSION #%03d ⟧%s  ' "$B" "$AMB" "$n" "$N"
printf '%s%s%s%s%s\n' "$(field operator "${USER:-ghost}")" "$sep" "$(field node "$(uname -n)")" "$sep" "$(field kernel "$(uname -r)")"
printf '  %s%s⟦ LINK ⟧%s         ' "$B" "$CYN" "$N"
if [[ -n "$ip" ]]; then
  printf '%s%s%s\n' "$(field uplink "$ip")" "$sep" "$(field uptime "${up:-?}")"
else
  printf '%s%s%s\n' "${RED}no uplink — offline${N}" "$sep" "$(field uptime "${up:-?}")"
fi
printf '  %s%s\n\n' "$DIM" "$(printf '─%.0s' $(seq 1 60))$N"

# ── 3) system intel ────────────────────────────
command -v fastfetch >/dev/null && fastfetch
