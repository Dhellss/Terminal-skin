#!/usr/bin/env bash
# void-signal-boot — VOID//SIGNAL opening sequence
# A flatline that finds a signal, the banner scans in from the void,
# then a briefing with REAL info about your machine and session count.
#
#   VOID_BOOT=full   → full sequence (default)
#   VOID_BOOT=quick  → fastfetch only
#   VOID_BOOT=off    → nothing
# Press ctrl+c at any time to skip.

mode="${VOID_BOOT:-full}"
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
P=$'\e[38;2;0;245;255m'; S=$'\e[38;2;176;224;232m'; A=$'\e[38;2;124;108;255m'
W=$'\e[38;2;207;238;244m'; M=$'\e[38;2;95;139;153m'; D=$'\e[38;2;13;42;54m'; L=$'\e[38;2;176;224;232m'
OK=$'\e[1;38;2;0;245;255m'; EDGE=$'\e[1;38;2;255;255;255m'
B=$'\e[1m'; N=$'\e[0m'
ROWC=($'\e[1;38;2;0;245;255m' $'\e[1;38;2;25;242;252m' $'\e[1;38;2;50;239;248m' $'\e[1;38;2;75;236;245m' $'\e[1;38;2;100;233;242m' $'\e[1;38;2;125;230;239m' $'\e[1;38;2;150;227;235m')
NOISE=('0' '1' '·' '▪' '▫' '◦')
NN=${#NOISE[@]}
NOISE_P=100                 # % of hidden cells that flicker with noise
NAME='VOID//SIGNAL'
RULE6='──────'
LETTERS='S I G N A L'
SUBW=31

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

intro() {                                      # pulse: a flatline finds a signal
  local f y=$(( ROWS / 3 )) w=$(( COLS - 6 )) pos
  for ((f = 0; f <= 10; f++)); do
    pos=$(( f * (w - 2) / 10 ))
    rep '─' "$pos"
    printf '\e[H\e[2J\e[%d;3H%s%s%s╱╲%s◈%s' "$y" "$M" "$REP" "$P" "$W" "$N"
    printf '\e[%d;3H%slistening%s' $(( y + 2 )) "$M" "$(rep '.' $(( f % 4 )); printf '%s' "$REP")"
    sleep 0.045
  done
  printf '\e[H\e[2J%s' "$N"
}

# ── banner reveal ──────────────────────────────
FRAMES=14
reveal_state() {                               # sets st: 0 hidden · 1 edge · 2 shown
  local e=$(( $1 * (BW + 8) / FRAMES ))
  if (( $2 < e - 3 )); then st=2; elif (( $2 <= e )); then st=1; else st=0; fi
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
  printf '%s%s▹%s ' "$pad" "$M" "$W"
  for ((i = 0; i < ${#msg}; i += 5)); do printf '%s' "${msg:i:5}"; sleep 0.008; done
  dots=$(( BW - ${#msg} - 14 )); (( dots < 3 )) && dots=3
  rep '·' "$dots"
  printf ' %s%s %s⟦ %sRECV%s ⟧%s\n' "$D" "$REP" "$M" "$OK" "$M" "$N"
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

step "listening past the event horizon"
step "locking carrier frequency"
step "decoding the signal"

# tall window keeps the whole show; otherwise clear before the briefing
if (( ROWS < H + 34 )); then sleep 0.25; printf '\e[H\e[2J'; else printf '\n'; fi

# ── briefing with real data ────────────────────
count_file="$HOME/.cache/void-signal_sessions"
mkdir -p "${count_file%/*}"
n=$(cat "$count_file" 2>/dev/null); [[ "$n" =~ ^[0-9]+$ ]] || n=0
n=$(( n + 1 )); echo "$n" > "$count_file"

ip=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for (i = 1; i <= NF; i++) if ($i == "src") print $(i + 1)}')
up=$(uptime -p 2>/dev/null | sed 's/^up //')

field() { printf '%s%s %s%s%s' "$M" "$1" "$W" "$2" "$N"; }
sep="${D}  ::  ${N}"
printf -v l1 '⟦ SIGNAL #%03d ⟧' "$n"
l2='⟦ CARRIER ⟧'
printf -v gap '%*s' $(( ${#l1} - ${#l2} > 0 ? ${#l1} - ${#l2} : 0 )) ''

printf '  %s%s%s%s  ' "$B" "$P" "$l1" "$N"
printf '%s%s%s%s%s\n' "$(field receiver "${USER:-$(id -un)}")" "$sep" "$(field station "$(uname -n)")" "$sep" "$(field kernel "$(uname -r)")"
printf '  %s%s%s%s%s  ' "$B" "$L" "$l2" "$N" "$gap"
if [[ -n "$ip" ]]; then
  printf '%s%s%s\n' "$(field freq "$ip")" "$sep" "$(field 'uptime' "${up:-?}")"
else
  printf '%s%s%s\n' "${P}no carrier — pure silence${N}" "$sep" "$(field 'uptime' "${up:-?}")"
fi
rep '─' 60
printf '  %s%s%s\n\n' "$D" "$REP" "$N"

# ── system info ────────────────────────────────
command -v fastfetch >/dev/null && fastfetch
