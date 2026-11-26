#!/usr/bin/env bash
# pulsar-wave-boot — PULSAR//WAVE opening sequence
# A rotating pulsar beam, the banner sweeps in, a launch log,
# then a briefing with REAL info about your machine and session count.
#
#   PULSAR_BOOT=full   → full sequence (default)
#   PULSAR_BOOT=quick  → fastfetch only
#   PULSAR_BOOT=off    → nothing
# Press ctrl+c at any time to skip.

mode="${PULSAR_BOOT:-full}"
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
P=$'\e[38;2;255;179;0m'; S=$'\e[38;2;255;122;0m'; A=$'\e[38;2;61;224;255m'
W=$'\e[38;2;245;230;200m'; M=$'\e[38;2;138;128;104m'; D=$'\e[38;2;23;32;58m'; L=$'\e[38;2;61;224;255m'
OK=$'\e[1;38;2;255;179;0m'; EDGE=$'\e[1;38;2;255;255;255m'
B=$'\e[1m'; N=$'\e[0m'
ROWC=($'\e[1;38;2;255;179;0m' $'\e[1;38;2;255;167;0m' $'\e[1;38;2;255;155;0m' $'\e[1;38;2;255;143;0m' $'\e[1;38;2;255;131;0m')
NOISE=('∾' '≈' '∙' '·' '∘' '°')
NN=${#NOISE[@]}
NOISE_P=70                 # % of hidden cells that flicker with noise
NAME='PULSAR//WAVE'
RULE6='──────'
LETTERS='W A V E'
SUBW=27

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

intro() {                                      # beam: a pulsar sweeping its two beams
  local f k i cx=$(( COLS / 2 )) cy=$(( (ROWS < 20 ? ROWS : 20) / 2 )) x y R=7
  local -a DX=(0 1 2 1) DY=(-1 -1 0 1) CH=('│' '╱' '─' '╲')
  for ((f = 0; f < 10; f++)); do
    k=$(( f % 4 ))
    printf '\e[H\e[2J'
    for ((i = 1; i <= R; i++)); do
      for s in 1 -1; do
        x=$(( cx + s * i * DX[k] )); y=$(( cy + s * i * DY[k] ))
        (( x < 1 || y < 1 || x >= COLS )) && continue
        if (( i < 3 )); then c=$W; elif (( i < 5 )); then c=$P; else c=$S; fi
        printf '\e[%d;%dH%s%s' "$y" "$x" "$c" "${CH[k]}"
      done
    done
    printf '\e[%d;%dH%s◉' "$cy" "$cx" "$W"
    sleep 0.05
  done
  printf '\e[H\e[2J%s' "$N"
}

# ── banner reveal ──────────────────────────────
FRAMES=14
reveal_state() {                               # sets st: 0 hidden · 1 edge · 2 shown
  local d=$(( $2 + 3 * $3 )) e=$(( $1 * (BW + 3 * H + 8) / FRAMES ))
  if (( d < e - 3 )); then st=2; elif (( d <= e )); then st=1; else st=0; fi
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
  printf '%s%s∙%s ' "$pad" "$M" "$W"
  for ((i = 0; i < ${#msg}; i += 5)); do printf '%s' "${msg:i:5}"; sleep 0.008; done
  dots=$(( BW - ${#msg} - 14 )); (( dots < 3 )) && dots=3
  rep '·' "$dots"
  printf ' %s%s %s⟦ %sSYNC%s ⟧%s\n' "$D" "$REP" "$M" "$OK" "$M" "$N"
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

step "spinning up the neutron core"
step "aligning magnetic poles"
step "sweeping the beam"

# tall window keeps the whole show; otherwise clear before the briefing
if (( ROWS < H + 34 )); then sleep 0.25; printf '\e[H\e[2J'; else printf '\n'; fi

# ── briefing with real data ────────────────────
count_file="$HOME/.cache/pulsar-wave_sessions"
mkdir -p "${count_file%/*}"
n=$(cat "$count_file" 2>/dev/null); [[ "$n" =~ ^[0-9]+$ ]] || n=0
n=$(( n + 1 )); echo "$n" > "$count_file"

ip=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for (i = 1; i <= NF; i++) if ($i == "src") print $(i + 1)}')
up=$(uptime -p 2>/dev/null | sed 's/^up //')

field() { printf '%s%s %s%s%s' "$M" "$1" "$W" "$2" "$N"; }
sep="${D}  ::  ${N}"
printf -v l1 '⟦ PULSE #%03d ⟧' "$n"
l2='⟦ BEAM ⟧'
printf -v gap '%*s' $(( ${#l1} - ${#l2} > 0 ? ${#l1} - ${#l2} : 0 )) ''

printf '  %s%s%s%s  ' "$B" "$P" "$l1" "$N"
printf '%s%s%s%s%s\n' "$(field observer "${USER:-$(id -un)}")" "$sep" "$(field observatory "$(uname -n)")" "$sep" "$(field kernel "$(uname -r)")"
printf '  %s%s%s%s%s  ' "$B" "$L" "$l2" "$N" "$gap"
if [[ -n "$ip" ]]; then
  printf '%s%s%s\n' "$(field lock "$ip")" "$sep" "$(field 'uptime' "${up:-?}")"
else
  printf '%s%s%s\n' "${P}no lock — beam lost in the dark${N}" "$sep" "$(field 'uptime' "${up:-?}")"
fi
rep '─' 60
printf '  %s%s%s\n\n' "$D" "$REP" "$N"

# ── system info ────────────────────────────────
command -v fastfetch >/dev/null && fastfetch
