#!/usr/bin/env bash
# nebula-drift-boot — NEBULA//DRIFT opening sequence
# Warp streaks, then the banner condenses out of stardust, a launch log,
# and a briefing with REAL info about your machine and session count.
#
#   DRIFT_BOOT=full   → full sequence (default)
#   DRIFT_BOOT=quick  → fastfetch only
#   DRIFT_BOOT=off    → nothing
# Press ctrl+c at any time to skip.

mode="${DRIFT_BOOT:-full}"
[[ "$mode" == "off" ]] && exit 0
if [[ "$mode" == "quick" || ! -t 1 ]]; then
  command -v fastfetch >/dev/null && fastfetch
  exit 0
fi

# multibyte-safe string slicing needs a UTF-8 locale
case "${LC_ALL:-${LC_CTYPE:-${LANG:-}}}" in
  *[Uu][Tt][Ff]-8* | *[Uu][Tt][Ff]8*) ;;
  *) export LC_ALL=C.UTF-8 ;;
esac

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
P=$'\e[38;2;200;80;255m'; S=$'\e[38;2;224;64;251m'; A=$'\e[38;2;58;134;255m'
W=$'\e[38;2;226;214;255m'; M=$'\e[38;2;138;112;184m'; D=$'\e[38;2;43;22;69m'; L=$'\e[38;2;58;134;255m'
OK=$'\e[1;38;2;200;80;255m'; EDGE=$'\e[1;38;2;255;255;255m'
B=$'\e[1m'; N=$'\e[0m'
ROWC=($'\e[1;38;2;200;80;255m' $'\e[1;38;2;203;78;255m' $'\e[1;38;2;205;77;254m' $'\e[1;38;2;208;75;254m' $'\e[1;38;2;210;73;253m' $'\e[1;38;2;213;72;253m' $'\e[1;38;2;215;70;252m' $'\e[1;38;2;218;68;252m' $'\e[1;38;2;220;66;252m')
NOISE=('·' '∙' '⋆' '°' '˙' '∘')
NN=${#NOISE[@]}
NOISE_P=100                 # % of hidden cells that flicker with noise
NAME='NEBULA//DRIFT'
RULE6='──────'
LETTERS='D R I F T'
SUBW=29

COLS=$(tput cols 2>/dev/null || echo 80)
ROWS=$(tput lines 2>/dev/null || echo 24)

rep() { printf -v REP '%*s' "$2" ''; REP=${REP// /$1}; }   # rep <char> <n> → $REP

mapfile -t BANNER 2>/dev/null < "$DIR/banner.txt"
BW=0
for l in "${BANNER[@]}"; do (( ${#l} > BW )) && BW=${#l}; done
if (( ${#BANNER[@]} == 0 || BW + 4 > COLS || ROWS < 22 )); then
  BANNER=("$NAME"); BW=${#NAME}; ROWC=("$P")    # small window: one-line title instead
fi
H=${#BANNER[@]}
PAD=$(( (COLS - BW) / 2 )); (( PAD < 2 )) && PAD=2
printf -v pad '%*s' "$PAD" ''

printf '\e[H\e[2J\e[?25l'                    # clear + hide the cursor while animating
trap 'printf "\e[?25h\e[0m"' EXIT
trap 'exit 130' INT

intro() {                                      # warp: stars stretch into streaks
  local f i len x h=$(( ROWS - 2 < 16 ? ROWS - 2 : 16 )) n=28
  local -a sx sy
  for ((i = 0; i < n; i++)); do sx[i]=$(( RANDOM % (COLS - 2) )); sy[i]=$(( 1 + RANDOM % h )); done
  for ((f = 1; f <= 9; f++)); do
    printf '\e[H\e[2J'
    for ((i = 0; i < n; i++)); do
      len=$(( f * f / 4 + 1 )); x=${sx[i]}
      (( x + len >= COLS )) && len=$(( COLS - x - 1 ))
      (( len < 1 )) && continue
      rep '─' $(( len - 1 ))
      if (( i % 3 )); then c=$M; else c=$D; fi
      printf '\e[%d;%dH%s%s%s·' "${sy[i]}" $(( x + 1 )) "$c" "$REP" "$S"
    done
    sleep 0.035
  done
  printf '\e[H\e[2J%s' "$N"
}

# ── banner reveal ──────────────────────────────
FRAMES=14
reveal_state() {                               # sets st: 0 hidden · 1 edge · 2 shown
  (( RANDOM % FRAMES < $1 )) && st=2 || st=0
}
render() {
  local f=$1 y x line out ch j
  for ((y = 0; y < H; y++)); do
    line="${BANNER[y]}"; out=""
    for ((x = 0; x < ${#line}; x++)); do
      ch="${line:x:1}"
      if [[ "$ch" == " " ]]; then out+=" "; continue; fi
      reveal_state "$f" "$x" "$y"
      case $st in
        2) out+="${ROWC[y]}$ch" ;;
        1) out+="$EDGE$ch$N" ;;
        *) if (( RANDOM % 100 < NOISE_P )); then out+="$D${NOISE[RANDOM % NN]}"; else out+=" "; fi ;;
      esac
    done
    j=""
    :
    printf '%s%s%s%s\e[K\n' "$pad" "$j" "$out" "$N"
  done
}

step() {                                       # step "message" — a typed launch-log line
  local msg="$1" i dots
  printf '%s%s✶%s ' "$pad" "$M" "$W"
  for ((i = 0; i < ${#msg}; i += 5)); do printf '%s' "${msg:i:5}"; sleep 0.008; done
  dots=$(( BW - ${#msg} - 14 )); (( dots < 3 )) && dots=3
  rep '·' "$dots"
  printf ' %s%s %s⟦ %sLOCK%s ⟧%s\n' "$D" "$REP" "$M" "$OK" "$M" "$N"
  sleep 0.03
}

(( ROWS >= 20 && COLS >= 40 )) && intro

for ((f = 0; f <= FRAMES; f++)); do
  render "$f"
  (( f < FRAMES )) && { sleep 0.035; printf '\e[%dA' "$H"; }
done

# subtitle, centered under the banner
SP=$(( (COLS - SUBW) / 2 )); (( SP < 2 )) && SP=2
printf '%*s%s%s  %s//  %s%s%s%s  %s%s%s\n\n' "$SP" '' "$D" "$RULE6" "$M" "$B" "$S" "$LETTERS" "$N" "$D" "$RULE6" "$N"

step "calibrating star charts"
step "folding the warp field"
step "plotting drift vector"

# tall window keeps the whole show; otherwise clear before the briefing
if (( ROWS < H + 34 )); then sleep 0.25; printf '\e[H\e[2J'; else printf '\n'; fi

# ── briefing with real data ────────────────────
count_file="$HOME/.cache/nebula-drift_sessions"
mkdir -p "${count_file%/*}"
n=$(cat "$count_file" 2>/dev/null); [[ "$n" =~ ^[0-9]+$ ]] || n=0
n=$(( n + 1 )); echo "$n" > "$count_file"

ip=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for (i = 1; i <= NF; i++) if ($i == "src") print $(i + 1)}')
up=$(uptime -p 2>/dev/null | sed 's/^up //')

field() { printf '%s%s %s%s%s' "$M" "$1" "$W" "$2" "$N"; }
sep="${D}  ::  ${N}"
printf -v l1 '⟦ DRIFT #%03d ⟧' "$n"
l2='⟦ BEACON ⟧'
printf -v gap '%*s' $(( ${#l1} - ${#l2} > 0 ? ${#l1} - ${#l2} : 0 )) ''

printf '  %s%s%s%s  ' "$B" "$P" "$l1" "$N"
printf '%s%s%s%s%s\n' "$(field pilot "${USER:-$(id -un)}")" "$sep" "$(field vessel "$(uname -n)")" "$sep" "$(field core "$(uname -r)")"
printf '  %s%s%s%s%s  ' "$B" "$L" "$l2" "$N" "$gap"
if [[ -n "$ip" ]]; then
  printf '%s%s%s\n' "$(field signal "$ip")" "$sep" "$(field 'adrift' "${up:-?}")"
else
  printf '%s%s%s\n' "${P}no beacon — drifting alone${N}" "$sep" "$(field 'adrift' "${up:-?}")"
fi
rep '─' 60
printf '  %s%s%s\n\n' "$D" "$REP" "$N"

# ── system info ────────────────────────────────
command -v fastfetch >/dev/null && fastfetch
