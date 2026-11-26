# RED//OPS

A tactical-HUD terminal theme for Arch Linux.  
Red-and-amber palette, decrypt boot animation, crosshair fastfetch logo, and a live ops prompt.

---

## Preview

```
╔══════════════════════════════════════════════════╗
║  [ ⌖ OPS ] dhell@archbox  ~/projects  main ⟫    ║
║  MEM 42%  IP 192.168.1.5  22:14  ◉               ║
╚══════════════════════════════════════════════════╝
```

Boot animation: decrypt-style character reveal → fastfetch system info  
Prompt: two-line HUD with git, memory, IP, time  

---

## Palette

| Role       | Color     |
|------------|-----------|
| Background | `#0a0506` |
| Foreground | `#e8d6d6` |
| Red        | `#ff1f3d` |
| Amber      | `#ffb000` |
| Cyan       | `#2de2e6` |
| Green      | `#9cff57` |
| Dim        | `#3d1419` |

---

## Tools Used

| Tool | Purpose |
|------|---------|
| kitty | Terminal emulator (beam cursor, tab bar, watermark) |
| zsh | Shell |
| starship | Prompt (ops HUD with git + live stats) |
| fastfetch | System info with crosshair logo |
| eza | `ls` replacement with colors |
| bat | `cat` replacement (ansi theme) |
| cmatrix | Rain effect (`ctrl+shift+m`) |
| JetBrains Mono Nerd | Font |

---

## Install

```bash
git clone https://github.com/Dhellss/Terminal-skin
cd Terminal-skin/red-ops
chmod +x install.sh
./install.sh
```

The installer will:
- Install required packages via pacman
- Back up your existing configs (`.bak-TIMESTAMP`)
- Copy configs to `~/.config/`
- Add a source line to `~/.zshrc`
- Offer to switch your default shell to zsh

---

## Kitty Shortcuts

| Shortcut | Action |
|----------|--------|
| `ctrl+shift+m` | Open red cmatrix rain |
| `ctrl+shift+i` | Show fastfetch system info |
| `ctrl+shift+enter` | Vertical split |
| `ctrl+shift+a` then `↑/↓` | Adjust window opacity |

---

## Tweaks

**Disable boot animation:**
```bash
echo 'export OPS_BOOT=off' >> ~/.config/redops/redops.zsh
```

**Quick boot (skip decrypt frames):**
```bash
echo 'export OPS_BOOT=quick' >> ~/.config/redops/redops.zsh
```

**Uninstall:**
```bash
rm -rf ~/.config/kitty ~/.config/starship.toml ~/.config/fastfetch ~/.config/redops
# Then remove the source line from ~/.zshrc
```

---

## Notes

- `percent.type: 3` in fastfetch shows bar + number. If your version doesn't support it, change to `1`.
- Battery module only shows if a battery is detected.
- `localip` in starship shows your LAN IP. On desktop (no wifi), `wifi` module in fastfetch may show empty.
