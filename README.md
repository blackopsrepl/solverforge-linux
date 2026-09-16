# SolverForge Linux

SolverForge Linux is my personal openSUSE + Sway desktop framework. It is a real working setup, not a generic dotfiles starter kit: it installs packages, writes desktop configuration under `~/.config`, wires shell startup, and assumes the openSUSE package ecosystem.

Read the scripts before running them if you do not already trust this repo.

## Install

Recommended path:

```bash
git clone https://github.com/blackopsrepl/solverforge-linux.git ~/hack/solverforge-linux
cd ~/hack/solverforge-linux
less boot.sh install.sh install/03-config.sh
SOLVERFORGE_PATH="$PWD" bash ./install.sh
```

Convenience path:

```bash
curl -sL https://raw.githubusercontent.com/blackopsrepl/solverforge-linux/main/boot.sh | bash
```

The bootstrap path installs into `~/.local/share/solverforge`. The manual path can run from another checkout by setting `SOLVERFORGE_PATH`.

## Architecture

SolverForge Linux uses a two-layer model:

```text
~/.local/share/solverforge/ or $SOLVERFORGE_PATH
  bin/                       solverforge-* commands
  default/                   shared default config layer
    sway/                    compositor config
    waybar/                  bar config and style
    wofi/                    launcher styling
    zsh/                     shell modules
    bash/                    bash modules
    nvim/                    LazyVim defaults
    systemd/                 user-service overrides
    theme/                   color source and app themes, including Doom Emacs

~/.config/solverforge/
  backup.conf                local backup config
  extensions/menu.sh         local menu entries
  local-env.sh               local environment overrides
  local-init.zsh             local shell bootstrap
  tui-apps/                  user-installed TUI launchers
```

Fresh installs generate:

- `~/.config/sway/config.d/solverforge.conf`, which includes the default Sway layer.
- `~/.config/environment.d/solverforge.conf`, which exports `SOLVERFORGE_PATH`, PATH, `SWAYLOCK_CONFIG`, and Qt theme settings.
- `~/.config/waybar/config` and `style.css` symlinks into the default layer.
- The bundled Doom Emacs configuration at `~/.config/doom` and its generated `themes/solverforge-hackerman-theme.el`.
- Optional `voxtype.service` and Codex MCP registration when those tools are installed.

Generated theme files under `default/theme/generated/` are not tracked. Run `solverforge-theme-apply` to materialize them from `default/theme/colors.toml`, templates, and overrides.

## Desktop Surface

The default desktop is openSUSE + Sway + Waybar + Wofi, with Kitty and Fira Code as the terminal baseline. Doom Emacs is the preferred editor; the LazyVim/Neovim path remains available.

Main pieces:

- `solverforge-menu`: Wofi-based hierarchical menu for apps, TUI tools, capture, setup, install/remove flows, power profiles, and system actions.
- `default/sway/bindings.conf`: keybindings for launchers, copy/paste, scratchpad, layouts, key guide, browser launch, Wayscriber, and keyboard layout cycling.
- `default/sway/autostart.conf`: tray bridge, Waybar launcher, companion Waybar daemons, status-notifier waits, and idle/screensaver integration.
- `default/waybar/config`: floating Waybar island with workspaces, scratchpad, voxtype, cava, Codexbar, Repobar, Trexbar, system metrics, Podman, Ollama, Virsh, updates, tray, power profile, and power menu.
- `default/waybar/style.css`: Hackerman Waybar styling used by the running setup.

## Scripts

All executable commands live in `bin/` and use the `solverforge-` prefix.

Core desktop and launcher scripts:

- `solverforge-menu`
- `solverforge-keys`
- `solverforge-icon-picker`
- `solverforge-launch-or-focus`
- `solverforge-launch-webapp`
- `solverforge-webapp-install`
- `solverforge-webapp-remove`
- `solverforge-tui-install`
- `solverforge-tui-remove`
- `solverforge-disk-install`
- `solverforge-disk-remove`
- `solverforge-pkg-install`
- `solverforge-pkg-remove`
- `solverforge-theme-apply`
- `solverforge-doom-install`
- `solverforge-lazyvim-install`

Running desktop helpers:

- `solverforge-browser`
- `solverforge-swayidle`
- `solverforge-screensaver`
- `solverforge-tray-start`
- `solverforge-wait-statusnotifier`
- `solverforge-voxtype-daemon`
- `solverforge-iphone-cam`
- `solverforge-showkeys`
- `solverforge-autotile`

Waybar modules and companions:

- `solverforge-waybar-start`
- `solverforge-waybar-companions-start`
- `solverforge-waybar-cava`
- `solverforge-waybar-codexbar`
- `solverforge-waybar-repobar`
- `solverforge-waybar-trexbar`
- `solverforge-waybar-power-profile`
- `solverforge-waybar-notifications`
- `solverforge-waybar-ollama`
- `solverforge-waybar-podman`
- `solverforge-waybar-updates`
- `solverforge-waybar-virsh`
- `solverforge-waybar-voxtype`

System and application helpers:

- `solverforge-backup`
- `solverforge-backup-prune`
- `solverforge-cargo-sweep`
- `solverforge-podman-overview`
- `solverforge-virsh-overview`
- `solverforge-calendar` local wrapper
- `solverforge-mail` local wrapper
- `solverforge-outlook-send`
- `solverforge-computer-use`

## Agent Skill

The repository ships a portable, harness-agnostic Agent Skill at
`skills/solverforge-linux/` that teaches an agent to operate and extend a
SolverForge Linux desktop: the layered framework, Sway/Waybar/Wofi config, the
`colors.toml` → template → generated → symlink theme pipeline, zsh modules, the
Wofi menu system, GTK/Qt/KDE theming, and the `solverforge-*` commands. The same
folder is discovered by opencode, Claude Code, Codex, and other Agent Skills
harnesses.

`install.sh` installs the skill automatically during setup and update. opencode
is the default harness; choose others with a comma or space separated
`SOLVERFORGE_SKILL_AGENTS` list:

```bash
SOLVERFORGE_SKILL_AGENTS="opencode codex" bash ./install.sh
```

With more than one harness selected, setup uses the duplicate-free `covering`
placement automatically; set `SOLVERFORGE_SKILL_LAYOUT=per-harness` to accept
the duplicate discovery the installer otherwise refuses.

The bundled `scripts/install-skill` gives the same control as the
`solverforge-cli` flow. It resolves each harness's own skills directory, never
installs into a directory you did not ask for, and updates or removes only the
copies it owns (tracked by the `.solverforge-skill` marker it writes).

```bash
./scripts/install-skill --agent opencode                          # one copy, opencode
./scripts/install-skill --agent opencode --agent claude --layout covering
./scripts/install-skill --agent opencode --link                   # symlink instead of copy
./scripts/install-skill --agent opencode --project <dir>          # project scope
./scripts/install-skill --agent opencode --list
./scripts/install-skill --agent opencode --uninstall
```

Because opencode scans the opencode, Claude, and Agent Skills directories,
`{opencode, claude, codex}` has no duplicate-free placement; the installer
reports that instead of silently duplicating, and `--layout per-harness --force`
installs all three copies while accepting the duplicate discovery. See
`skills/README.md` for the harness directory table and ownership rules. Restart
the agent after installing so it rescans skill directories.

## Doom Emacs

SolverForge installs both openSUSE Emacs packages and runs one X11-backed `emacs.service` user daemon. Terminal and graphical frames are clients of that same daemon. Doom itself lives at the XDG path `~/.config/emacs`, with a bundled SolverForge configuration seeded at `~/.config/doom` on first install. It includes the Hackerman theme, Fira Code display settings, Eglot, Treemacs, Harpoon, and the side-tree `SPC e` show/hide command.

Install with the stock Doom config:

```bash
solverforge-doom-install
```

Or restore an existing config repository during installation:

```bash
solverforge-doom-install https://forge.example/user/doom-config.git
```

The installer preserves legacy Emacs init paths as timestamped backups, seeds the bundled config only when no Doom config exists (or clones the supplied config repository), runs `doom sync` and `doom doctor`, wires the X11 service override, enables and restarts the distro `emacs.service` user unit, and never modifies or removes Neovim. The `SUPER + Shift+M` binding opens a graphical client frame, while `em` opens a terminal client frame. Neither command falls back to a separate Emacs process, and there is no shell alias for `emacs-x11`.

## SolverForge Linux Computer Use

`solverforge-computer-use` is a local MCP server for operating the current Sway session from Codex. It provides screen info, screenshots, focus/window inspection, pointer actions, typing, key chords, and clipboard access through Sway and Wayland tools.

Register it:

```bash
solverforge-computer-use --install-codex-mcp
```

Verify it:

```bash
solverforge-computer-use --self-test
codex mcp list
```

Fresh installs attempt registration automatically when `codex` is available.

## Local Overrides

Keep machine-specific settings outside the shared repo:

- Copy `examples/local-env.sh.example` to `~/.config/solverforge/local-env.sh` for PATH, browser, voxtype, cargo sweep, and screensaver overrides.
- Copy `examples/local-init.zsh.example` to `~/.config/solverforge/local-init.zsh` for host-specific shell initialization.
- Add custom menu entries in `~/.config/solverforge/extensions/menu.sh`.

The publish tree should not contain username-specific paths, local DBs, generated theme history, mailbox state, or private app configuration.

## Dependencies

Required packages are listed in `packages.txt` and installed by `install/02-packages.sh`.

Optional packages are listed in `packages-optional.txt`. Optional integrations should degrade cleanly when their commands are absent. Notable optional integrations include `emacs-nox`, `emacs-x11`, `cava`, `podman`, `virsh`, `ollama`, `voxtype`, `plasma6-workspace`, `python313-python-xlib`, `tmux`, `yazi`, `mc`, and `lazygit`.

Manual dependencies:

- Fira Code Nerd Font for the terminal and UI font baseline.
- Zen browser if you want the default browser command to resolve to `zen`.
- `voxtype` if you want push-to-talk transcription.
- A screensaver binary if you want `solverforge-screensaver` to launch anything besides `$HOME/.cargo/bin/solverforge-screensaver`.
- Mail and calendar binaries if you want the optional `solverforge-mail` and `solverforge-calendar` wrappers to launch local applications.

## License

MIT. See `LICENSE`.

## Publication Notes

This repository intentionally ships the current running desktop behavior with local state removed. The mail and calendar launchers are shell wrappers only; the application binaries are not shipped in this repository.
