# AGENTS.md

SolverForge Linux is a personal openSUSE + Sway desktop framework: shell config,
dotfiles, an installer, and runtime `solverforge-*` commands. The domain playbook
for any desktop, theme, shell, or menu change is the bundled skill at
`skills/solverforge-linux/SKILL.md` — read it before editing config.

## Layout and entrypoints

- `install.sh` orchestrates setup. It detects fresh vs update by the presence of
  `~/.config/sway/config.d/solverforge.conf`, then **sources** `install/0*.sh` in
  lexical order.
- `install/NN-*.sh` are phases sourced into one `set -euo pipefail` shell:
  `return 0` skips a phase, `exit 1` aborts the whole install.
  `sf_info|sf_warn|sf_error|sf_success` come from `install/helpers/log.sh` and
  `sf_guard_*` from `install/helpers/guard.sh`. Add a phase as `install/0N-*.sh`.
- `boot.sh` (distributed as `curl | bash`) clones or fast-forwards
  `~/.local/share/solverforge`, then execs `install.sh`.
- `bin/solverforge-*` are the runtime commands (extensionless; mostly bash, with
  Python `solverforge-computer-use`, `solverforge-autotile`, and
  `solverforge-outlook-send`). Commands that need the framework root resolve
  `SOLVERFORGE_PATH`, defaulting to `$HOME/.local/share/solverforge`.
- `default/` is the immutable shared layer wired into `~/.config`.
  `default/theme/` pipelines `colors.toml` (single source of truth) →
  `templates/*.tpl` → `generated/` → symlinks.
- `scripts/install-skill` plus `skills/` package the bundled agent skill.

## Gotchas

- This checkout is not the live install. Run any `bin/*` command or installer
  with `SOLVERFORGE_PATH="$PWD"` to exercise your working tree; the running
  desktop changes only after an install/update.
- Never edit `default/theme/generated/*` or any generated dotfile — it is
  gitignored and overwritten. Edit `colors.toml` or the `.tpl`, then run
  `bin/solverforge-theme-apply` (`--reload` also restarts kitty/sway/btop/
  opencode/swaync).
- `install.sh` refuses to run as root and requires openSUSE's `zypper`; never
  substitute apt or pacman.
- Doom Emacs is not installed by `install.sh`. It is on demand via
  `bin/solverforge-doom-install` (menu → Install), and
  `solverforge-theme-apply` only wires the Doom theme when `~/.config/doom`
  exists.
- `install/03-config.sh` sets `OPENCODE_DISABLE_CLAUDE_CODE=1`, which disables
  opencode's `~/.claude/skills` scan. Factor that into a skill install layout.
- Gitignored local state includes `*.db`, `.claude/`, `mail/`, and
  `default/theme/generated/`; do not commit it.

## Verification

- There is no unit-test suite. The automated gate is pre-commit (end-of-file,
  trailing whitespace, merge conflict, large files, gitleaks). It runs as a git
  hook, but the CLI is off PATH: `python3 -m pre_commit run --all-files`.
- SECURITY.md publication hygiene: run a secret scan, run `shellcheck` on the
  bootstrap/install scripts and `bin/*`, keep username-specific paths out of
  shared defaults, and test on a clean openSUSE environment when the installer
  changes.
- For a desktop change, run the affected command with `SOLVERFORGE_PATH="$PWD"`
  and confirm the generated or symlinked result.

## Releases

- Conventional commits; only `feat` and `fix` reach the changelog.
  `.versionrc.js` bumps `version` and the `skills/solverforge-linux/SKILL.md`
  prose version.
- Release with `commit-and-tag-version --release-as vX.Y.Z`; never hand-edit
  `CHANGELOG.md`, the version surfaces, the release commit, or the tag.
- Remotes are `origin` (GitHub `blackopsrepl/solverforge-linux`) and `vigilance`
  (local Forgejo). "Push to all remotes" means both, and tags must be pushed
  explicitly.

## Bundled agent skill

- `skills/solverforge-linux/SKILL.md` is the desktop domain authority; keep it
  aligned with the live framework surface.
- `scripts/install-skill` installs it per harness (opencode/claude/codex) with
  `.solverforge-skill` ownership markers; `install/05-skill.sh` runs it during
  setup (default opencode; `SOLVERFORGE_SKILL_AGENTS`,
  `SOLVERFORGE_SKILL_LAYOUT`). It adopts a byte-identical hand-placed copy and
  leaves foreign copies untouched.
