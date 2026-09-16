# SolverForge Linux agent skill

This repository bundles one portable, harness-agnostic Agent Skill:

- `solverforge-linux/` — operate and extend a SolverForge Linux desktop: the
  layered `~/.local/share/solverforge` framework, Sway/Waybar/Wofi config,
  the `colors.toml` → template → generated → symlink theme pipeline, zsh
  modules, the Wofi menu system, GTK/Qt/KDE theming, and the `solverforge-*`
  commands.

It is a plain directory tree (`SKILL.md`, plus any `references/` and bundled
`scripts/`). The same folder is discovered by opencode, Claude Code, Codex, and
other Agent Skills harnesses.

## Install

`install.sh` installs the skill automatically (for opencode by default); the
standalone installer gives the same control as the `solverforge-cli` flow.

The installer is agent-centric: you name the harnesses you use and it resolves
each harness's own skills directory. It never installs into a directory you did
not ask for, never assumes `~/.agents`, and refuses to create duplicate
discovery.

```sh
# One copy per harness you use (the default)
./scripts/install-skill --agent opencode
./scripts/install-skill --agent claude
./scripts/install-skill --agent codex

# Two harnesses that overlap: a duplicate-free shared placement
./scripts/install-skill --agent opencode --agent claude --layout covering

# Symlink the skill instead of copying it
./scripts/install-skill --agent opencode --link

# A project instead of user scope
./scripts/install-skill --agent opencode --project ../my-app

# Any explicit skills directory
./scripts/install-skill --dir ~/.config/some-harness/skills

# Inspect or remove
./scripts/install-skill --agent opencode --list
./scripts/install-skill --agent opencode --uninstall
```

Harness directories:

| Harness | User scope | Project scope (`--project <dir>`) | Scanned by |
| --- | --- | --- | --- |
| opencode | `~/.config/opencode/skills` | `<dir>/.opencode/skills` | opencode |
| Claude Code | `~/.claude/skills` | `<dir>/.claude/skills` | opencode, Claude Code |
| Codex / Agent Skills | `~/.agents/skills` | `<dir>/.agents/skills` | opencode, Codex |

Because opencode scans all three directories, per-harness copies for
`{opencode, claude}`, `{opencode, codex}`, or `{opencode, claude, codex}` would
make opencode discover the same skill more than once. Use `--layout covering`
for the two-harness selections; it places one shared copy where possible. The
`{opencode, claude, codex}` combination has no duplicate-free placement, so the
installer reports it and asks you to choose two, or to pass
`--layout per-harness --force` and accept duplicate discovery.

Installed copies carry a `.solverforge-skill` marker that the installer writes;
symlinked installs carry a sidecar receipt, and the link is treated as
installer-owned only while it still points at the receipt's recorded target. A
skill copied by hand has no marker, so the installer treats it as foreign: it
updates or removes only entries it owns, and leaves foreign files, directories,
and symlinks untouched.

`install/05-skill.sh` runs the installer during setup with opencode as the
default. Override the harnesses it installs for with a comma or space separated
`SOLVERFORGE_SKILL_AGENTS` list, for example
`SOLVERFORGE_SKILL_AGENTS="opencode codex" bash ./install.sh`. With more than
one harness it uses the duplicate-free `covering` placement automatically; set
`SOLVERFORGE_SKILL_LAYOUT=per-harness` to accept the duplicate discovery the
installer otherwise refuses.

Restart the agent after installing so it rescans skill directories.
