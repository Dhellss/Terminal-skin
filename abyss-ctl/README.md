# ABYSS//CTL

> **Hell series · Theme 12** — Blood red on void black. The pit that stares back.

![ABYSS//CTL preview](../previews/12-abyss-ctl.png)

---

## What you get

| Layer | Details |
|-------|---------|
| **Boot sequence** | The screen tears and glitches, two eyes open → the banner decodes out of static → a 3-step launch log → a briefing with your real user, host, kernel, IP and session number → fastfetch |
| **Prompt** (starship) | Two-line HUD, one solid bar — the tag melts into your path through pixels that dissolve into the void. User@host, path, git branch/status and language versions on the left; command time, MEM, IP, battery and clock on the right |
| **System info** (fastfetch) | Logo: a pit of nested frames with two eyes staring up. Sections: `SOUL` · `FLESH` · `ECHOES`, with themed usage bars |
| **Terminal** (kitty) | Full 16-color palette, beam cursor with a trail, faint inverted pentagram watermark, themed tabs |
| **Shell** (zsh) | Syntax highlighting + autosuggestions in theme colors, `eza`/`bat` colors, handy aliases |

---

## Palette

| Role       | Color |
|------------|-------|
| Background | `#030000` |
| Foreground | `#e8cccc` |
| Primary    | `#e01010` |
| Secondary  | `#f0e6d8` |
| Accent     | `#7a0000` |
| Muted      | `#8f5a5a` |
| Dim        | `#2a0606` |

---

## Install

```bash
git clone https://github.com/Dhellss/Terminal-skin
cd Terminal-skin/abyss-ctl
chmod +x install.sh
./install.sh
```

The installer will:
- Install the required packages via pacman
- Back up your existing configs (`.bak-TIMESTAMP`) before replacing them
- Copy the configs into `~/.config/`
- Add one source line to `~/.zshrc` (and switch off any other Terminal-skin theme so they never stack)
- Offer to make zsh your default shell

Then open a new kitty window.

## Uninstall

```bash
cd Terminal-skin/abyss-ctl
./uninstall.sh
```

Puts your previous configs back from the newest `.bak-*` files and disables the theme in `~/.zshrc`.

---

## Kitty shortcuts

| Shortcut | Action |
|----------|--------|
| `ctrl+shift+m` | Open a `bleed` tab (cmatrix in red) |
| `ctrl+shift+i` | Show fastfetch in an overlay (any key closes it) |
| `ctrl+shift+enter` | Vertical split in the current folder |
| `ctrl+shift+a` then `↑` / `↓` | Window opacity up / down |

## Aliases

| Alias | Does |
|-------|------|
| `boot` / `descend` | Replay the full opening sequence |
| `info` / `gaze` | fastfetch |
| `rain` / `bleed` | cmatrix in theme color |
| `ls`, `ll`, `tree` | eza with icons |
| `cat` | bat, no paging |
| `update` / `install` | `sudo pacman -Syu` / `sudo pacman -S` |
| `scan` / `myip` | open ports / public IP |

---

## Tweaks

**Quick boot (skip the animation, fastfetch only)** or **no boot at all** — edit the line near the top of `~/.config/abyss-ctl/abyss-ctl.zsh`:

```bash
sed -i 's/ABYSS_BOOT:-full/ABYSS_BOOT:-quick/' ~/.config/abyss-ctl/abyss-ctl.zsh   # or :-off
```

Press `ctrl+c` during the boot to skip it once.

---

## Notes

- Every symbol in this theme exists in **JetBrainsMono Nerd Font** (installed by the installer), so nothing shows up as an empty box.
- The boot banner needs a window at least 51 columns wide; smaller windows get a one-line title instead.
- `percent.type: 3` in fastfetch shows a bar + number. On a very old fastfetch, change it to `1`.
- The battery and Wi-Fi lines only appear on machines that have them.
