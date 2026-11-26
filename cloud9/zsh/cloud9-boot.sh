#!/usr/bin/env bash
# cloud9-boot — CLOUD//9 opening sequence
# Dawn sparkles drift upward, the banner blooms from the center,
# then a briefing with REAL info about your machine and session count.
#
#   CLOUD9_BOOT=full   → full sequence (default)
#   CLOUD9_BOOT=quick  → fastfetch only
#   CLOUD9_BOOT=off    → nothing
# Press ctrl+c at any time to skip.

mode="${CLOUD9_BOOT:-full}"
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
P=$'\e[38;2;96;184;255m'; S=$'\e[38;2;214;235;255m'; A=$'\e[38;2;255;179;209m'
W=$'\e[38;2;227;241;255m'; M=$'\e[38;2;117;144;173m'; D=$'\e[38;2;21;38;58m'; L=$'\e[38;2;255;179;209m'
OK=$'\e[1;38;2;96;184;255m'; EDGE=$'\e[1;38;2;255;255;255m'
B=$'\e[1m'; N=$'\e[0m'
ROWC=($'\e[1;38;2;96;184;255m' $'\e[1;38;2;106;188;255m' $'\e[1;38;2;116;193;255m' $'\e[1;38;2;126;197;255m' $'\e[1;38;2;136;201;255m' $'\e[1;38;2;146;206;255m' $'\e[1;38;2;156;210;255m' $'\e[1;38;2;166;214;255m' $'\e[1;38;2;176;219;255m' $'\e[1;38;2;186;223;255m' $'\e[1;38;2;196;227;255m')
NOISE=('·' '∘' '°' '˙' '◦' '‿')
NN=${#NOISE[@]}
NOISE_P=18                 # % of hidden cells that flicker with noise
NAME='CLOUD//9'
RULE6='──────'
LETTERS='9'
SUBW=21

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

intro() {                                      # drift: dawn sparkles float upward
  local f i n=30 h=$(( ROWS - 2 < 16 ? ROWS - 2 : 16 )) x y
  local -a px py pc G=('·' '∘' '°' '˙')
  for ((i = 0; i < n; i++)); do px[i]=$(( RANDOM % (COLS - 4) + 1 )); py[i]=$(( h - RANDOM % 4 )); pc[i]=$(( RANDOM % 4 )); done
  for ((f = 0; f < 10; f++)); do
    printf '\e[H\e[2J'
    for ((i = 0; i < n; i++)); do
      y=$(( py[i] - f * (1 + i % 2) )); x=$(( px[i] + f * (i % 3) / 2 ))
      (( y < 1 || x >= COLS )) && continue
      if (( i % 5 == 0 )); then c=$A; elif (( i % 2 )); then c=$S; else c=$P; fi
      printf '\e[%d;%dH%s%s' "$y" "$x" "$c" "${G[pc[i]]}"
    done
    sleep 0.045
  done
  printf '\e[H\e[2J%s' "$N"
}

# ── banner reveal ──────────────────────────────
FRAMES=14
reveal_state() {                               # sets st: 0 hidden · 1 edge · 2 shown
  local c=$(( BW / 2 )) d e
  d=$(( $2 > c ? $2 - c : c - $2 )); e=$(( $1 * (c + 6) / FRAMES ))
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
  printf '%s%s◦%s ' "$pad" "$M" "$W"
  for ((i = 0; i < ${#msg}; i += 5)); do printf '%s' "${msg:i:5}"; sleep 0.008; done
  dots=$(( BW - ${#msg} - 14 )); (( dots < 3 )) && dots=3
  rep '·' "$dots"
  printf ' %s%s %s⟨ %sLIFT%s ⟩%s\n' "$D" "$REP" "$M" "$OK" "$M" "$N"
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

step "gathering the clouds"
step "warming the dawn"
step "lifting to cloud nine"

# tall window keeps the whole show; otherwise clear before the briefing
if (( ROWS < H + 34 )); then sleep 0.25; printf '\e[H\e[2J'; else printf '\n'; fi

# ── briefing with real data ────────────────────
count_file="$HOME/.cache/cloud9_sessions"
mkdir -p "${count_file%/*}"
n=$(cat "$count_file" 2>/dev/null); [[ "$n" =~ ^[0-9]+$ ]] || n=0
n=$(( n + 1 )); echo "$n" > "$count_file"

ip=$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for (i = 1; i <= NF; i++) if ($i == "src") print $(i + 1)}')
up=$(uptime -p 2>/dev/null | sed 's/^up //')

field() { printf '%s%s %s%s%s' "$M" "$1" "$W" "$2" "$N"; }
sep="${D}  ::  ${N}"
printf -v l1 '⟨ FLIGHT #%03d ⟩' "$n"
l2='⟨ BREEZE ⟩'
printf -v gap '%*s' $(( ${#l1} - ${#l2} > 0 ? ${#l1} - ${#l2} : 0 )) ''

printf '  %s%s%s%s  ' "$B" "$P" "$l1" "$N"
printf '%s%s%s%s%s\n' "$(field dreamer "${USER:-$(id -un)}")" "$sep" "$(field sky "$(uname -n)")" "$sep" "$(field kernel "$(uname -r)")"
printf '  %s%s%s%s%s  ' "$B" "$L" "$l2" "$N" "$gap"
if [[ -n "$ip" ]]; then
  printf '%s%s%s\n' "$(field link "$ip")" "$sep" "$(field 'floating' "${up:-?}")"
else
  printf '%s%s%s\n' "${P}no breeze — becalmed${N}" "$sep" "$(field 'floating' "${up:-?}")"
fi
rep '─' 60
printf '  %s%s%s\n\n' "$D" "$REP" "$N"

# ── system info ────────────────────────────────
command -v fastfetch >/dev/null && fastfetch
