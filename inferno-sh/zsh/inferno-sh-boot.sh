#!/usr/bin/env bash
# inferno-sh-boot — INFERNO//SH opening sequence
# A DOOM-style fire burns across the screen, the banner burns in,
# then a briefing with REAL info about your machine and session count.
#
#   INFERNO_BOOT=full   → full sequence (default)
#   INFERNO_BOOT=quick  → fastfetch only
#   INFERNO_BOOT=off    → nothing
# Press ctrl+c at any time to skip.

mode="${INFERNO_BOOT:-full}"
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
P=$'\e[38;2;255;69;0m'; S=$'\e[38;2;255;176;32m'; A=$'\e[38;2;255;42;0m'
W=$'\e[38;2;255;217;179m'; M=$'\e[38;2;168;104;63m'; D=$'\e[38;2;46;13;2m'; L=$'\e[38;2;255;176;32m'
OK=$'\e[1;38;2;255;176;32m'; EDGE=$'\e[1;38;2;255;176;32m'
B=$'\e[1m'; N=$'\e[0m'
ROWC=($'\e[1;38;2;255;69;0m' $'\e[1;38;2;255;80;3m' $'\e[1;38;2;255;92;7m' $'\e[1;38;2;255;103;10m' $'\e[1;38;2;255;114;14m' $'\e[1;38;2;255;126;17m' $'\e[1;38;2;255;137;20m' $'\e[1;38;2;255;149;24m' $'\e[1;38;2;255;160;27m')
NOISE=('░' '▒' '▓' '·' '∙' '█')
NN=${#NOISE[@]}
NOISE_P=85                 # % of hidden cells that flicker with noise
NAME='INFERNO//SH'
RULE6='━━━━━━'
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

intro() {                                      # fire: the classic DOOM fire
  local w=$(( COLS - 4 < 56 ? COLS - 4 : 56 )) h=8 f x y i src r dst line
  local left=$(( (COLS - w) / 2 + 1 )) top=$(( ROWS / 2 - 4 ))
  local -a heat CH=(' ' '·' '░' '░' '▒' '▒' '▓' '▓' '█')
  local -a CO=("$N" "$D" "$D" "$A" "$A" "$P" "$P" "$S" "$W")
  for ((i = 0; i < w * h; i++)); do heat[i]=0; done
  printf '\e[H\e[2J'
  for ((f = 0; f < 15; f++)); do
    for ((x = 0; x < w; x++)); do heat[(h - 1) * w + x]=$(( f < 11 ? 8 : 0 )); done
    for ((y = 0; y < h - 1; y++)); do
      for ((x = 0; x < w; x++)); do
        src=${heat[(y + 1) * w + x]}; r=$(( RANDOM % 3 ))
        dst=$(( x - r + 1 )); (( dst < 0 )) && dst=0; (( dst >= w )) && dst=$(( w - 1 ))
        src=$(( src - (r & 1) - (RANDOM % 4 == 0) )); (( src < 0 )) && src=0
        heat[y * w + dst]=$src
      done
    done
    for ((y = 0; y < h; y++)); do
      line=""
      for ((x = 0; x < w; x++)); do i=${heat[y * w + x]}; line+="${CO[i]}${CH[i]}"; done
      printf '\e[%d;%dH%s' $(( top + y )) "$left" "$line"
    done
    sleep 0.025
  done
  printf '\e[H\e[2J%s' "$N"
}

# ── banner reveal ──────────────────────────────
FRAMES=14
reveal_state() {                               # sets st: 0 hidden · 1 edge · 2 shown
  local d=$(( H - 1 - $3 )) e=$(( $1 * (H + 3) / FRAMES ))
  if (( d < e - 2 )); then st=2; elif (( d <= e )); then st=1; else st=0; fi
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
  printf '%s%s▸%s ' "$pad" "$M" "$W"
  for ((i = 0; i < ${#msg}; i += 5)); do printf '%s' "${msg:i:5}"; sleep 0.008; done
  dots=$(( BW - ${#msg} - 14 )); (( dots < 3 )) && dots=3
  rep '·' "$dots"
  printf ' %s%s %s[ %sBURN%s ]%s\n' "$D" "$REP" "$M" "$OK" "$M" "$N"
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

step "stoking the furnace"
step "melting the bedrock"
step "opening the hellgate"

# tall window keeps the whole show; otherwise clear before the briefing
if (( ROWS < H + 34 )); then sleep 0.25; printf '\e[H\e[2J'; else printf '\n'; fi

# ── briefing with real data ────────────────────
count_file="$HOME/.cache/inferno-sh_sessions"
mkdir -p "${count_file%/*}"
n=$(cat "$count_file" 2>/dev/null); [[ "$n" =~ ^[0-9]+$ ]] || n=0
n=$(( n + 1 )); echo "$n" > "$count_file"

ip=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for (i = 1; i <= NF; i++) if ($i == "src") print $(i + 1)}')
up=$(uptime -p 2>/dev/null | sed 's/^up //')

field() { printf '%s%s %s%s%s' "$M" "$1" "$W" "$2" "$N"; }
sep="${D}  ::  ${N}"
printf -v l1 '[ SOUL #%03d ]' "$n"
l2='[ HELLGATE ]'
printf -v gap '%*s' $(( ${#l1} - ${#l2} > 0 ? ${#l1} - ${#l2} : 0 )) ''

printf '  %s%s%s%s  ' "$B" "$P" "$l1" "$N"
printf '%s%s%s%s%s\n' "$(field sinner "${USER:-$(id -un)}")" "$sep" "$(field circle "$(uname -n)")" "$sep" "$(field kernel "$(uname -r)")"
printf '  %s%s%s%s%s  ' "$B" "$L" "$l2" "$N" "$gap"
if [[ -n "$ip" ]]; then
  printf '%s%s%s\n' "$(field portal "$ip")" "$sep" "$(field 'burning' "${up:-?}")"
else
  printf '%s%s%s\n' "${P}no portal — sealed in the furnace${N}" "$sep" "$(field 'burning' "${up:-?}")"
fi
rep '━' 60
printf '  %s%s%s\n\n' "$D" "$REP" "$N"

# ── system info ────────────────────────────────
command -v fastfetch >/dev/null && fastfetch
