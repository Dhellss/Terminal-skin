#!/usr/bin/env bash
# ghost-boot — fake "hacker boot sequence" kapag nag-open ka ng terminal.
# Pure visuals lang ito, walang ginagawang totoo sa system mo.
#
#   GHOST_BOOT=full   → full typing animation (default)
#   GHOST_BOOT=quick  → fastfetch lang
#   GHOST_BOOT=off    → wala

mode="${GHOST_BOOT:-full}"
[[ "$mode" == "off" ]] && exit 0

G=$'\e[38;2;0;255;156m'   # green
C=$'\e[38;2;0;229;255m'   # cyan
R=$'\e[38;2;255;46;99m'   # red
D=$'\e[38;2;31;77;54m'    # dim green
B=$'\e[1m'
N=$'\e[0m'

type_out() {               # type_out "text" [delay]
  local s="$1" d="${2:-0.006}" i
  for ((i = 0; i < ${#s}; i++)); do
    printf '%s' "${s:i:1}"
    sleep "$d"
  done
}

ts=0
step() {                   # step "message"
  ts=$(( ts + RANDOM % 400 + 50 ))   # fake kernel timestamp (ms), always goes up
  printf '%s[%4d.%03d]%s ' "$D" $(( ts / 1000 )) $(( ts % 1000 )) "$N"
  printf '%s' "$G"; type_out "$1"; printf '%s' "$N"
  local dots=$(( 44 - ${#1} )); (( dots < 2 )) && dots=2
  printf '%s%*s%s' "$D" "$dots" '' "$N" | tr ' ' '.'
  sleep 0.05
  printf ' %s[ %sOK%s ]%s\n' "$G" "$B" "$N$G" "$N"
}

clear

if [[ "$mode" == "full" ]]; then
  printf '%s' "$C"; type_out ">> ghost//shell v1.0 — initializing session" 0.01; printf '%s\n\n' "$N"
  step "mounting encrypted volumes"
  step "loading kernel modules"
  step "spawning daemon: ghostd"
  step "routing traffic through tor relays"
  step "spoofing hardware fingerprint"
  step "bypassing mainframe firewall"
  printf '\n'

  user_line="ACCESS GRANTED  ::  welcome back, ${USER:-ghost}"
  width=$(( ${#user_line} + 6 ))
  bar=$(printf '═%.0s' $(seq 1 "$width"))
  printf '%s%s╔%s╗%s\n' "$B" "$G" "$bar" "$N"
  printf '%s%s║   %s%s%s   ║%s\n' "$B" "$G" "$R" "$user_line" "$G" "$N"
  printf '%s%s╚%s╝%s\n' "$B" "$G" "$bar" "$N"
  sleep 0.4
  clear
fi

command -v fastfetch >/dev/null && fastfetch
