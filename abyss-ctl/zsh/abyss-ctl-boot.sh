#!/usr/bin/env bash
# abyss-ctl-boot — ABYSS//CTL opening sequence
# The screen tears and glitches, something opens its eyes,
# then a briefing with REAL info about your machine and session count.
#
#   ABYSS_BOOT=full   → full sequence (default)
#   ABYSS_BOOT=quick  → fastfetch only
#   ABYSS_BOOT=off    → nothing
# Press ctrl+c at any time to skip.

mode="${ABYSS_BOOT:-full}"
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
P=$'\e[38;2;224;16;16m'; S=$'\e[38;2;240;230;216m'; A=$'\e[38;2;122;0;0m'
W=$'\e[38;2;232;204;204m'; M=$'\e[38;2;143;90;90m'; D=$'\e[38;2;42;6;6m'; L=$'\e[38;2;240;230;216m'
OK=$'\e[1;38;2;240;230;216m'; EDGE=$'\e[1;38;2;240;230;216m'
B=$'\e[1m'; N=$'\e[0m'
ROWC=($'\e[1;38;2;224;16;16m' $'\e[1;38;2;226;36;35m' $'\e[1;38;2;227;56;54m' $'\e[1;38;2;229;77;73m' $'\e[1;38;2;230;97;92m' $'\e[1;38;2;232;117;110m' $'\e[1;38;2;233;137;129m' $'\e[1;38;2;235;157;148m' $'\e[1;38;2;236;178;167m' $'\e[1;38;2;238;198;186m')
NOISE=('░' '▒' '▓' '@' '!' ':' '·')
NN=${#NOISE[@]}
NOISE_P=100                 # % of hidden cells that flicker with noise
NAME='ABYSS//CTL'
RULE6='━━━━━━'
LETTERS='C T L'
SUBW=25

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

intro() {                                      # glitch: the screen tears, eyes open
  local f i y x len cx=$(( COLS / 2 )) cy=$(( (ROWS < 20 ? ROWS : 20) / 2 ))
  local -a G=('░' '▒' '▓' '█')
  for ((f = 0; f < 8; f++)); do
    printf '\e[H\e[2J'
    for ((i = 0; i < 6; i++)); do
      y=$(( 1 + RANDOM % (cy * 2) )); x=$(( 1 + RANDOM % (COLS / 2) )); len=$(( 4 + RANDOM % (COLS / 3) ))
      rep "${G[RANDOM % 4]}" "$len"
      if (( RANDOM % 2 )); then c=$D; else c=$P; fi
      printf '\e[%d;%dH%s%s' "$y" "$x" "$c" "$REP"
    done
    (( f >= 5 )) && printf '\e[%d;%dH%s◉   ◉' "$cy" $(( cx - 2 )) "$S"
    sleep 0.06
  done
  printf '\e[H\e[2J%s' "$N"
}

# ── banner reveal ──────────────────────────────
FRAMES=14
reveal_state() {                               # sets st: 0 hidden · 1 edge · 2 shown
  if (( RANDOM % FRAMES < $1 )); then
    if (( $1 < FRAMES && RANDOM % 5 == 0 )); then st=1; else st=2; fi
  else st=0; fi
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
    (( f < FRAMES && RANDOM % 4 == 0 )) && j="  "
    printf '%s%s%s%s\e[K\n' "$pad" "$j" "$out" "$N"
  done
}

step() {                                       # step "message" — a typed launch-log line
  local msg="$1" i dots
  printf '%s%s‡%s ' "$pad" "$M" "$W"
  for ((i = 0; i < ${#msg}; i += 5)); do printf '%s' "${msg:i:5}"; sleep 0.008; done
  dots=$(( BW - ${#msg} - 14 )); (( dots < 3 )) && dots=3
  rep '·' "$dots"
  printf ' %s%s %s[ %sGONE%s ]%s\n' "$D" "$REP" "$M" "$OK" "$M" "$N"
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

step "severing the last light"
step "falling past the floor"
step "the abyss gazes back"

# tall window keeps the whole show; otherwise clear before the briefing
if (( ROWS < H + 34 )); then sleep 0.25; printf '\e[H\e[2J'; else printf '\n'; fi

# ── briefing with real data ────────────────────
count_file="$HOME/.cache/abyss-ctl_sessions"
mkdir -p "${count_file%/*}"
n=$(cat "$count_file" 2>/dev/null); [[ "$n" =~ ^[0-9]+$ ]] || n=0
n=$(( n + 1 )); echo "$n" > "$count_file"

ip=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for (i = 1; i <= NF; i++) if ($i == "src") print $(i + 1)}')
up=$(uptime -p 2>/dev/null | sed 's/^up //')

field() { printf '%s%s %s%s%s' "$M" "$1" "$W" "$2" "$N"; }
sep="${D}  ::  ${N}"
printf -v l1 '[ DESCENT #%03d ]' "$n"
l2='[ ECHO ]'
printf -v gap '%*s' $(( ${#l1} - ${#l2} > 0 ? ${#l1} - ${#l2} : 0 )) ''

printf '  %s%s%s%s  ' "$B" "$P" "$l1" "$N"
printf '%s%s%s%s%s\n' "$(field soul "${USER:-$(id -un)}")" "$sep" "$(field vessel "$(uname -n)")" "$sep" "$(field kernel "$(uname -r)")"
printf '  %s%s%s%s%s  ' "$B" "$L" "$l2" "$N" "$gap"
if [[ -n "$ip" ]]; then
  printf '%s%s%s\n' "$(field whisper "$ip")" "$sep" "$(field 'lost for' "${up:-?}")"
else
  printf '%s%s%s\n' "${P}no echo — nothing hears you down here${N}" "$sep" "$(field 'lost for' "${up:-?}")"
fi
rep '━' 60
printf '  %s%s%s\n\n' "$D" "$REP" "$N"

# ── system info ────────────────────────────────
command -v fastfetch >/dev/null && fastfetch
