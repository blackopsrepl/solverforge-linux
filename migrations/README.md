# SolverForge — migrations

One-off, idempotent fixups for trees that predate a framework change. The
installer **sources** each `*.sh` here in lexical order (see `install/`), so a
migration runs on every update and must do nothing on the second run.

Rules:

- Idempotent: guard on the artifact you are removing or creating.
- Never recreate a file from memory — `mv`, `cp` or nothing.
- `sf_info` / `sf_warn` from `install/helpers/log.sh` are available.
