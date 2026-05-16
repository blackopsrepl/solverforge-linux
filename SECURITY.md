# Security Notes

SolverForge Linux is a personal desktop configuration repo, not a security-hardened product or supported release.

## Scope

- Primary target: openSUSE + Sway
- Shared publicly as-is, with best-effort cleanup of obvious hazards
- No warranty, no promise of safety, and no guarantee that the installer or scripts are suitable for your machine

## Trust Model

- The convenience bootstrap executes remote code
- The installer installs packages with `sudo`
- The install flow writes files under `~/.config` and updates shell startup
- Some optional scripts invoke system tools, local services, and host-specific integrations

If you care about reviewability, clone the repo, inspect `boot.sh`, `install.sh`, and `install/`, then run locally.

## Reporting

If you notice a credential leak, command-injection bug, or another obvious security issue, open an issue or contact the maintainer directly. Response is best-effort only.

## Publication Hygiene

Before publishing notable changes:

- run a secret scan
- run `shellcheck` on bootstrap/install scripts and `bin/*`
- verify no username-specific paths remain in shared defaults
- test on a clean openSUSE environment if the installer changed
