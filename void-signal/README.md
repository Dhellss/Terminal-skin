# VOID//SIGNAL

> **Galaxy series · Theme 04** — A black hole's silence, broken by one cyan signal.

![VOID//SIGNAL preview](../previews/04-void-signal.png)

---

## What you get

| Layer | Details |
|-------|---------|
| **Boot sequence** | A flatline finds a signal → the banner scans in left to right → a 3-step launch log → a briefing with your real user, host, kernel, IP and session number → fastfetch |
| **Prompt** (starship) | Two-line HUD, solid tag with a powerline arrow. User@host, path, git branch/status and language versions on the left; command time, MEM, IP, battery and clock on the right |
| **System info** (fastfetch) | Logo: a black hole with its accretion disk, leaking a signal. Sections: `ORIGIN` · `TRANSMISSION` · `CARRIER`, with themed usage bars |
| **Terminal** (kitty) | Full 16-color palette, beam cursor with a trail, faint black hole + signal watermark, themed tabs |
| **Shell** (zsh) | Syntax highlighting + autosuggestions in theme colors, `eza`/`bat` colors, handy aliases |

---

## Palette

| Role       | Color |
|------------|-------|
| Background | `#01070d` |
| Foreground | `#cfeef4` |
| Primary    | `#00f5ff` |
| Secondary  | `#b0e0e8` |
| Accent     | `#7c6cff` |
| Muted      | `#5f8b99` |
| Dim        | `#0d2a36` |

---

## Install

```bash
git clone https://github.com/Dhellss/Terminal-skin
cd Terminal-skin/void-signal
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
cd Terminal-skin/void-signal
./uninstall.sh
```

Puts your previous configs back from the newest `.bak-*` files and disables the theme in `~/.zshrc`.

---

## Kitty shortcuts

| Shortcut | Action |
|----------|--------|
| `ctrl+shift+m` | Open a `static` tab (cmatrix in cyan) |
| `ctrl+shift+i` | Show fastfetch in an overlay (any key closes it) |
| `ctrl+shift+enter` | Vertical split in the current folder |
| `ctrl+shift+a` then `↑` / `↓` | Window opacity up / down |

## Aliases

| Alias | Does |
|-------|------|
| `boot` / `signal` | Replay the full opening sequence |
| `info` / `trace` | fastfetch |
| `rain` / `static` | cmatrix in theme color |
| `ls`, `ll`, `tree` | eza with icons |
| `cat` | bat, no paging |
| `update` / `install` | `sudo pacman -Syu` / `sudo pacman -S` |
| `scan` / `myip` | open ports / public IP |

---

## Tweaks

**Quick boot (skip the animation, fastfetch only)** or **no boot at all** — edit the line near the top of `~/.config/void-signal/void-signal.zsh`:

```bash
sed -i 's/VOID_BOOT:-full/VOID_BOOT:-quick/' ~/.config/void-signal/void-signal.zsh   # or :-off
```

Press `ctrl+c` during the boot to skip it once.

---

## Notes

- Every symbol in this theme exists in **JetBrainsMono Nerd Font** (installed by the installer), so nothing shows up as an empty box.
- The boot banner needs a window at least 46 columns wide; smaller windows get a one-line title instead.
- `percent.type: 3` in fastfetch shows a bar + number. On a very old fastfetch, change it to `1`.
- The battery and Wi-Fi lines only appear on machines that have them.
