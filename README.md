<div align="center">

# 🖥️ Terminal-skin

**Terminal themes for Arch Linux — hacker, galaxy, heaven and hell.**

Each theme is a complete kit: **kitty** + **zsh** + **starship** + **fastfetch** + an animated boot sequence.<br>
One installer per theme. Your old configs are always backed up first.

![themes](https://img.shields.io/badge/themes-12-8a70b8?style=flat-square)
![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=flat-square&logo=archlinux&logoColor=white)
![kitty](https://img.shields.io/badge/kitty-terminal-2b1645?style=flat-square)
![starship](https://img.shields.io/badge/starship-prompt-dd0b78?style=flat-square&logo=starship&logoColor=white)
![fastfetch](https://img.shields.io/badge/fastfetch-system_info-0d2a36?style=flat-square)

</div>

---

## Themes

| # | Theme | Series | Vibe | Boot animation | Colors |
|---|-------|--------|------|----------------|--------|
| 01 | [GHOST//SHELL](./ghostshell/) | Originals | Green matrix / cyber | Typed "hacker" boot log | `#00ff9c` `#00e5ff` `#ff2e63` |
| 02 | [RED//OPS](./redops/) | Originals | Red tactical HUD | Banner decrypts from noise | `#ff1f3d` `#ffb000` `#2de2e6` |
| 03 | [NEBULA//DRIFT](./nebula-drift/) | Galaxy | Violet nebula, deep space | Warp streaks → stardust | `#c850ff` `#e040fb` `#3a86ff` |
| 04 | [VOID//SIGNAL](./void-signal/) | Galaxy | Black hole, cyan signal | Flatline → signal scan | `#00f5ff` `#b0e0e8` `#7c6cff` |
| 05 | [PULSAR//WAVE](./pulsar-wave/) | Galaxy | Neutron star, gold beams | Rotating pulsar beam | `#ffb300` `#ff7a00` `#3de0ff` |
| 06 | [SERAPH//OS](./seraph-os/) | Heaven | Six wings, gold & sapphire | Light falls from above | `#d8b13a` `#6f8fd8` `#f0e6c8` |
| 07 | [CLOUD//9](./cloud9/) | Heaven | Sky blue, cloud white, dawn | Dawn sparkles drift up | `#60b8ff` `#d6ebff` `#ffb3d1` |
| 08 | [EDEN//ROOT](./eden-root/) | Heaven | Garden mint, ivory, fruit | A vine grows and bears fruit | `#50d890` `#e8f0d0` `#ff6b6b` |
| 09 | [ASCEND//SH](./ascend-sh/) | Heaven | Lavender twilight, dawn gold | A stairway builds to the light | `#c880ff` `#f2c8ff` `#ffd27a` |
| 10 | [HALO//CTL](./halo-ctl/) | Heaven | Platinum light, halo gold | Light falls from above | `#e8f4ff` `#a0c8e0` `#f5d77a` |
| 11 | [INFERNO//SH](./inferno-sh/) | Hell | Lava, ember, hellfire | DOOM-style fire | `#ff4500` `#ffb020` `#ff2a00` |
| 12 | [ABYSS//CTL](./abyss-ctl/) | Hell | Blood red on void black | Screen tears, eyes open | `#e01010` `#f0e6d8` `#7a0000` |

---

## Gallery

### Originals

<table>
<tr>
<td align="center" width="50%"><a href="./ghostshell/"><img src="./previews/01-ghostshell.png" alt="GHOST//SHELL"><br><b>01 · GHOST//SHELL</b></a></td>
<td align="center" width="50%"><a href="./redops/"><img src="./previews/02-redops.png" alt="RED//OPS"><br><b>02 · RED//OPS</b></a></td>
</tr>
</table>

### 🌌 Galaxy — deep space, stars and signals

<table>
<tr>
<td align="center" width="50%"><a href="./nebula-drift/"><img src="./previews/03-nebula-drift.png" alt="NEBULA//DRIFT"><br><b>03 · NEBULA//DRIFT</b></a></td>
<td align="center" width="50%"><a href="./void-signal/"><img src="./previews/04-void-signal.png" alt="VOID//SIGNAL"><br><b>04 · VOID//SIGNAL</b></a></td>
</tr>
<tr>
<td align="center" width="50%"><a href="./pulsar-wave/"><img src="./previews/05-pulsar-wave.png" alt="PULSAR//WAVE"><br><b>05 · PULSAR//WAVE</b></a></td>
<td></td>
</tr>
</table>

### ☁️ Heaven — light, gold and air

<table>
<tr>
<td align="center" width="50%"><a href="./seraph-os/"><img src="./previews/06-seraph-os.png" alt="SERAPH//OS"><br><b>06 · SERAPH//OS</b></a></td>
<td align="center" width="50%"><a href="./cloud9/"><img src="./previews/07-cloud9.png" alt="CLOUD//9"><br><b>07 · CLOUD//9</b></a></td>
</tr>
<tr>
<td align="center" width="50%"><a href="./eden-root/"><img src="./previews/08-eden-root.png" alt="EDEN//ROOT"><br><b>08 · EDEN//ROOT</b></a></td>
<td align="center" width="50%"><a href="./ascend-sh/"><img src="./previews/09-ascend-sh.png" alt="ASCEND//SH"><br><b>09 · ASCEND//SH</b></a></td>
</tr>
<tr>
<td align="center" width="50%"><a href="./halo-ctl/"><img src="./previews/10-halo-ctl.png" alt="HALO//CTL"><br><b>10 · HALO//CTL</b></a></td>
<td></td>
</tr>
</table>

### 🔥 Hell — fire, blood and the void

<table>
<tr>
<td align="center" width="50%"><a href="./inferno-sh/"><img src="./previews/11-inferno-sh.png" alt="INFERNO//SH"><br><b>11 · INFERNO//SH</b></a></td>
<td align="center" width="50%"><a href="./abyss-ctl/"><img src="./previews/12-abyss-ctl.png" alt="ABYSS//CTL"><br><b>12 · ABYSS//CTL</b></a></td>
</tr>
</table>

---

## Quick Install

```bash
# Clone the repo
git clone https://github.com/Dhellss/Terminal-skin
cd Terminal-skin

# Pick a theme and run its installer
cd nebula-drift
chmod +x install.sh
./install.sh
```

Then open a new kitty window.

**Switching themes:** just run another theme's `install.sh`. It switches off whichever Terminal-skin theme was active (commented out in `~/.zshrc`, never deleted) and backs up your configs before replacing them.

**Uninstalling (themes 03–12):** run `./uninstall.sh` inside the theme folder. It restores your previous configs from the newest `.bak-*` files.

---

## What every theme includes

| Layer | What you get |
|-------|--------------|
| **Boot sequence** | An animated intro unique to the theme, the theme banner, a short launch log, then a briefing with your real user, host, kernel, IP and session number, followed by fastfetch. Runs once per new window; `ctrl+c` skips it, and every theme has a quick/off switch. |
| **Prompt** (starship) | Two-line HUD: theme tag, user@host, path, git branch and status, language versions, plus command time, memory, IP, battery and clock on the right. |
| **System info** (fastfetch) | Custom ASCII logo, themed section headers and usage bars. |
| **Terminal** (kitty) | Full 16-color palette, cursor trail, faint corner watermark, themed tabs and shortcuts. |
| **Shell** (zsh) | Syntax highlighting and autosuggestions in theme colors, `eza`/`bat` colors, handy aliases. |

---

## Requirements

All themes are built for **Arch Linux** (and Arch-based distros) and use these packages:

```
kitty  zsh  starship  fastfetch  eza  bat  cmatrix  iproute2
ttf-jetbrains-mono-nerd  zsh-autosuggestions  zsh-syntax-highlighting
```

The `install.sh` in each theme installs them for you with pacman.
Every symbol used by themes 03–12 exists in **JetBrainsMono Nerd Font**, so nothing renders as an empty box.

---

## Structure

```
Terminal-skin/
├── ghostshell/          01 · GHOST//SHELL
├── redops/              02 · RED//OPS
├── nebula-drift/        03 · NEBULA//DRIFT
├── void-signal/         04 · VOID//SIGNAL
├── pulsar-wave/         05 · PULSAR//WAVE
├── seraph-os/           06 · SERAPH//OS
├── cloud9/              07 · CLOUD//9
├── eden-root/           08 · EDEN//ROOT
├── ascend-sh/           09 · ASCEND//SH
├── halo-ctl/            10 · HALO//CTL
├── inferno-sh/          11 · INFERNO//SH
├── abyss-ctl/           12 · ABYSS//CTL
├── previews/            screenshots used in this README
└── README.md
```

Inside every theme folder:

```
<theme>/
├── install.sh           one-command installer (backs up first)
├── uninstall.sh         restores your previous configs (03–12)
├── kitty/               kitty.conf + watermark
├── starship/            starship.toml
├── fastfetch/           config.jsonc + logo
├── zsh/                 zsh layer, boot script, banner
└── README.md
```

---

## Contributing / Issues

Found a bug or have a theme idea? Open an issue.
Screenshots of your setup are always welcome.

---

<div align="center">
  <sub>Built for Arch Linux · Made by <a href="https://github.com/Dhellss">Dhellss</a></sub>
</div>
