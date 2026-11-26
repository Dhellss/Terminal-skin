#!/usr/bin/env bash
# ascend-sh-boot — ASCEND//SH opening sequence
# A stairway builds itself toward the light, the banner rises,
# then a briefing with REAL info about your machine and session count.
#
#   ASCEND_BOOT=full   → full sequence (default)
#   ASCEND_BOOT=quick  → fastfetch only
#   ASCEND_BOOT=off    → nothing
# Press ctrl+c at any time to skip.

mode="${ASCEND_BOOT:-full}"
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
P=$'\e[38;2;200;128;255m'; S=$'\e[38;2;242;200;255m'; A=$'\e[38;2;255;210;122m'
W=$'\e[38;2;236;228;255m'; M=$'\e[38;2;138;122;171m'; D=$'\e[38;2;35;26;51m'; L=$'\e[38;2;255;210;122m'
OK=$'\e[1;38;2;200;128;255m'; EDGE=$'\e[1;38;2;255;255;255m'
B=$'\e[1m'; N=$'\e[0m'
ROWC=($'\e[1;38;2;200;128;255m' $'\e[1;38;2;204;134;255m' $'\e[1;38;2;207;140;255m' $'\e[1;38;2;211;146;255m' $'\e[1;38;2;214;152;255m' $'\e[1;38;2;218;159;255m' $'\e[1;38;2;221;165;255m' $'\e[1;38;2;225;171;255m' $'\e[1;38;2;229;177;255m' $'\e[1;38;2;232;183;255m' $'\e[1;38;2;236;189;255m')
NOISE=('·' '∘' '°' '˙' '▴' '▵')
NN=${#NOISE[@]}
NOISE_P=15                 # % of hidden cells that flicker with noise
NAME='ASCEND//SH'
RULE6='──────'
LETTERS='S H'
SUBW=23

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

intro() {                                      # rise: a stairway builds toward the light
  local f h=$(( ROWS - 2 < 14 ? ROWS - 2 : 14 )) x0=$(( COLS / 2 - 18 )) x y
  printf '\e[H\e[2J'
  for ((f = 0; f < 6; f++)); do
    x=$(( x0 + f * 6 )); y=$(( h - f * 2 ))
    (( x < 1 )) && x=1
    printf '\e[%d;%dH%s▄▄▄▄▄▄%s' "$y" "$x" "$A" "$N"
    printf '\e[%d;%dH%s██████' $(( y + 1 )) "$x" "$P"
    sleep 0.06
  done
  printf '\e[%d;%dH%s◯' $(( h - 13 > 1 ? h - 13 : 1 )) $(( x0 + 40 )) "$W"
  sleep 0.2
  printf '\e[H\e[2J%s' "$N"
}

# ── banner reveal ──────────────────────────────
FRAMES=14
reveal_state() {                               # sets st: 0 hidden · 1 edge · 2 shown
  local d=$(( H - 1 - $3 )) e=$(( $1 * (H + 2) / FRAMES ))
  if (( d < e - 1 )); then st=2; elif (( d <= e )); then st=1; else st=0; fi
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
  printf '%s%s▴%s ' "$pad" "$M" "$W"
  for ((i = 0; i < ${#msg}; i += 5)); do printf '%s' "${msg:i:5}"; sleep 0.008; done
  dots=$(( BW - ${#msg} - 14 )); (( dots < 3 )) && dots=3
  rep '·' "$dots"
  printf ' %s%s %s⟨ %sUP%s ⟩%s\n' "$D" "$REP" "$M" "$OK" "$M" "$N"
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

step "taking the first step"
step "leaving gravity behind"
step "breaking through the clouds"

# tall window keeps the whole show; otherwise clear before the briefing
if (( ROWS < H + 34 )); then sleep 0.25; printf '\e[H\e[2J'; else printf '\n'; fi

# ── briefing with real data ────────────────────
count_file="$HOME/.cache/ascend-sh_sessions"
mkdir -p "${count_file%/*}"
n=$(cat "$count_file" 2>/dev/null); [[ "$n" =~ ^[0-9]+$ ]] || n=0
n=$(( n + 1 )); echo "$n" > "$count_file"

ip=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for (i = 1; i <= NF; i++) if ($i == "src") print $(i + 1)}')
up=$(uptime -p 2>/dev/null | sed 's/^up //')

field() { printf '%s%s %s%s%s' "$M" "$1" "$W" "$2" "$N"; }
sep="${D}  ::  ${N}"
printf -v l1 '⟨ ASCENT #%03d ⟩' "$n"
l2='⟨ ZENITH ⟩'
printf -v gap '%*s' $(( ${#l1} - ${#l2} > 0 ? ${#l1} - ${#l2} : 0 )) ''

printf '  %s%s%s%s  ' "$B" "$P" "$l1" "$N"
printf '%s%s%s%s%s\n' "$(field climber "${USER:-$(id -un)}")" "$sep" "$(field summit "$(uname -n)")" "$sep" "$(field kernel "$(uname -r)")"
printf '  %s%s%s%s%s  ' "$B" "$L" "$l2" "$N" "$gap"
if [[ -n "$ip" ]]; then
  printf '%s%s%s\n' "$(field link "$ip")" "$sep" "$(field 'rising' "${up:-?}")"
else
  printf '%s%s%s\n' "${P}no link — climbing alone${N}" "$sep" "$(field 'rising' "${up:-?}")"
fi
rep '─' 60
printf '  %s%s%s\n\n' "$D" "$REP" "$N"

# ── system info ────────────────────────────────
command -v fastfetch >/dev/null && fastfetch
