# shellcheck shell=bash
# SolverForge — consolidate the machine-local waybar chip overlay into the
# framework default, and refresh the installed waybar layer from the repo.
# The cronbar/benchbar/backupbar chip rules now live in default/waybar/style.css,
# so a tree carrying the old appended block would shadow the framework values.
# Idempotent: identical files are left untouched, so the second run no-ops.

_live_style="${XDG_DATA_HOME:-$HOME/.local/share}/solverforge/default/waybar/style.css"
_live_config="${XDG_DATA_HOME:-$HOME/.local/share}/solverforge/default/waybar/config"
_repo_style="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/default/waybar/style.css"
_repo_config="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/default/waybar/config"

if [[ -f "$_live_style" && -f "$_repo_style" ]] && ! cmp -s "$_live_style" "$_repo_style"; then
  cp "$_repo_style" "$_live_style"
  sf_info "Refreshed default/waybar/style.css from the framework default (chip family consolidated)"
fi

if [[ -f "$_live_config" && -f "$_repo_config" ]] && ! cmp -s "$_live_config" "$_repo_config"; then
  # The live config carries machine-local values (voxtype exec path, glyph
  # encodings); only the module lists and custom/* blocks the framework owns
  # are merged in, everything machine-local is preserved.
  if command -v python3 >/dev/null 2>&1; then
    python3 - "$_repo_config" "$_live_config" <<'PY'
import json, collections, sys

repo = json.load(open(sys.argv[1]), object_pairs_hook=collections.OrderedDict)
live = json.load(open(sys.argv[2]), object_pairs_hook=collections.OrderedDict)

live["modules-left"] = repo["modules-left"]
for key, value in repo.items():
    if key.startswith("custom/"):
        live[key] = collections.OrderedDict(value) if isinstance(value, dict) else value

open(sys.argv[2], "w").write(json.dumps(live, indent=2, ensure_ascii=False) + "\n")
PY
    sf_info "Merged the framework waybar module set into default/waybar/config"
  else
    sf_warn "python3 unavailable; default/waybar/config not merged — run the framework update again"
  fi
fi

# Waybar re-reads its CSS on SIGHUP; the config needs a restart, which the
# theme engine's `swaymsg reload` (phase 4 runs right after this) performs
# through Sway's own exec_always with the session environment intact.
if pgrep -x waybar >/dev/null 2>&1; then
  pkill -HUP -x waybar 2>/dev/null || true
  sf_info "Signalled waybar to reload its stylesheet"
fi

unset _live_style _live_config _repo_style _repo_config
