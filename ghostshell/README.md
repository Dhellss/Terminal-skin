# GHOST//SHELL — hacker terminal theme for Arch Linux

Green-on-black, Matrix-style terminal setup.

| Part | Tool | File |
|---|---|---|
| Terminal + colors | kitty (Alacritty optional) | `kitty/kitty.conf`, `alacritty/alacritty.toml` |
| Prompt | starship | `starship/starship.toml` |
| System info screen | fastfetch | `fastfetch/config.jsonc` |
| Shell, aliases, syntax colors | zsh | `zsh/ghostshell.zsh` |
| Fake boot sequence | bash script | `zsh/ghost-boot.sh` |

## Install

```bash
cd ghostshell
chmod +x install.sh
./install.sh
```

The installer:
1. installs the packages with `pacman` (kitty, zsh, starship, fastfetch, eza, bat, cmatrix, JetBrainsMono Nerd Font, zsh plugins)
2. copies the configs, **backing up** any existing ones as `*.bak-<date>`
3. adds one `source` line to `~/.zshrc` (your current zshrc is kept)
4. asks if you want zsh as your default shell

Then open a new **kitty** window.

## Palette

| Role | Hex |
|---|---|
| Background | `#050a07` |
| Main green | `#00ff9c` |
| Cyan (paths, host) | `#00e5ff` |
| Red (errors, root) | `#ff2e63` |
| Purple (git) | `#b026ff` |
| Yellow (strings, timers) | `#e6ff00` |
| Dim green (comments, hints) | `#1f4d36` |

## Commands you get

| Command | What it does |
|---|---|
| `hack` / `matrix` | Matrix rain (cmatrix) |
| `boot` | Replay the boot sequence |
| `ll` | Detailed list with icons and git status |
| `tree` | Folder tree with icons |
| `cat file` | Syntax-highlighted file view (bat) |
| `ports` | Open ports |
| `myip` | Your public IP |
| `update` | `sudo pacman -Syu` |
| `Ctrl+Shift+M` | Matrix rain in a new kitty tab |
| `Ctrl+Shift+A` then ↑/↓ | More/less transparency |

## Tweaks

- **Boot animation too long?** Add one of these to `~/.zshrc` *above* the GHOST//SHELL line:
  ```bash
  export GHOST_BOOT=quick   # fastfetch only
  export GHOST_BOOT=off     # nothing
  ```
- **Change the main color:** search-and-replace `#00ff9c` in all files (e.g. `#ff2e63` for a red "Mr. Robot" look).
- **Blur behind the window:** depends on your compositor (Hyprland: `decoration:blur`, KDE: works out of the box, picom: `blur-method = "dual_kawase"`).

## Uninstall

Delete `~/.config/ghostshell`, remove the GHOST//SHELL line in `~/.zshrc`, and restore the `.bak-*` files.
