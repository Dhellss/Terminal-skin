# 🖥️ Terminal-skin

> A collection of hacker-aesthetic terminal themes for Arch Linux.  
> Each theme includes kitty, zsh, starship, and fastfetch configs — one installer, plug and play.

---

## Themes

| # | Name | Style | Colors | Status |
|---|------|-------|--------|--------|
| 01 | [GHOST//SHELL](./ghost-shell/) | Green matrix / cyber | `#00ff9c` `#00e5ff` `#ff2e63` | ✅ Ready |
| 02 | [RED//OPS](./red-ops/) | Red tactical HUD | `#ff1f3d` `#ffb000` `#2de2e6` | ✅ Ready |

> More themes coming. Star the repo to follow updates.

---

## Quick Install

```bash
# Clone the repo
git clone https://github.com/Dhellss/Terminal-skin
cd Terminal-skin

# Pick a theme and run its installer
cd red-ops
chmod +x install.sh
./install.sh
```

Each theme backs up your existing configs before making any changes.

---

## Requirements

All themes are built for **Arch Linux** and require these base packages:

```
kitty  zsh  starship  fastfetch  eza  bat  cmatrix
ttf-jetbrains-mono-nerd  zsh-autosuggestions  zsh-syntax-highlighting
```

The `install.sh` in each theme handles this automatically via pacman.

---

## Theme Details

### 01 — GHOST//SHELL
Green-on-black matrix aesthetic. Decrypt boot animation, glitch prompt, neon fastfetch logo.  
→ [View theme](./ghost-shell/README.md)

### 02 — RED//OPS
Red-and-amber tactical HUD. Ops boot sequence, crosshair fastfetch logo, live stats in prompt.  
→ [View theme](./red-ops/README.md)

---

## Structure

```
Terminal-skin/
├── ghost-shell/
│   ├── install.sh
│   ├── kitty/
│   ├── starship/
│   ├── fastfetch/
│   └── zsh/
├── red-ops/
│   ├── install.sh
│   ├── kitty/
│   ├── starship/
│   ├── fastfetch/
│   └── zsh/
└── README.md
```

---

## Contributing / Issues

Found a bug or want to suggest a theme idea? Open an issue.  
Screenshots of your setup are always welcome.

---

<div align="center">
  <sub>Built for Arch Linux · Made by <a href="https://github.com/Dhellss">Dhellss</a></sub>
</div>
