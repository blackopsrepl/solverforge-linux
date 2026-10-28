# Waybar module diagnostics and styling

## Diagnose a missing module

1. Resolve `~/.config/waybar/config` and `style.css` with `readlink -f`; compare those targets and the installed framework version with the checked-out `default/waybar/` files. The running bar consumes the installed framework, not an arbitrary working tree.
2. Trace the module from `modules-left`/`modules-center`/`modules-right` to its custom `exec` helper. Confirm that the helper exists and is executable in the active framework root.
3. Inspect Waybar's own `PATH` and only relevant module-specific variables, for example:
   ```bash
   pid=$(pgrep -xo waybar)
   path=$(tr '\0' '\n' < "/proc/$pid/environ" | command grep '^PATH=' | cut -d= -f2-)
   ```
   Do not dump the full process environment. An interactive shell's `command -v` is not evidence that Waybar can resolve the same binary.
4. Reproduce the helper with the effective Waybar environment. Parse its JSON and require non-empty `text` and no `missing` class. Do not assert a fixed status such as `idle`: recording/transcribing states may change during the probe.
5. If the module delegates to a user-local executable, use its configured path or implement a deliberate fallback in the helper; do not rely on a shell rc file that Waybar never sources.
6. Keep the code change in `default/waybar/` or `bin/`. If the live installed framework is stale, prefer its normal update path; for a narrowly scoped missing tracked helper, a targeted deployment may be used, but verify the deployed file matches the checked-out source and do not imply that this updated the full framework.

## Apply and verify styling

1. Inspect the shared module-base selector and the later module-specific selector in `default/waybar/style.css`; check recent history before changing shared styles.
2. Encode the requested geometry explicitly on the module selector. For square-corner badges, use `border-radius: 0` so the shared chip radius cannot override the intended shape.
3. Deploy the source edit to the active framework. Use `swaymsg reload` when the deployed Sway autostart uses `exec_always` to restart Waybar; verify the Waybar PID changed, the active stylesheet contains the intended rule, and the module still emits valid JSON.

## Retire a companion

- Remove only the retired module from the source module lists, its custom block, and its CSS selectors; preserve the other companions.
- Add an idempotent migration that removes the retired custom block and module-list entries from installed configs. The earlier config merge only overwrites current source keys and does not delete retired keys.
- Remove only the retired shim and disable only its companion service; never alter the cron scheduler or scheduled jobs when retiring a cron inspector.
- Put the retirement notice at the top of the companion README, push its final commit to every configured remote, then archive each hosted repository. Read back archive state and the final branch SHA.
- Move the profile entry to Legacy without changing maintained siblings. Preserve unrelated untracked directories in the profile checkout.

Keep visual and functional diagnosis separate: a missing module is resolved through the config→helper→dependency path, while shape is resolved through CSS selectors and the live reload path.
