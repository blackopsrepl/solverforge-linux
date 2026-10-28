# shellcheck shell=bash
# SolverForge — retire CronBar without changing scheduled jobs or Backupbar.

_cronbar_live_root="${XDG_DATA_HOME:-$HOME/.local/share}/solverforge"
_cronbar_live_config="$_cronbar_live_root/default/waybar/config"

if [[ -f "$_cronbar_live_config" ]]; then
  python3 - "$_cronbar_live_config" <<'PY'
import json
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
original = path.read_text()
config = json.loads(original)
changed = "custom/cronbar" in config
config.pop("custom/cronbar", None)
for key in ("modules-left", "modules-center", "modules-right"):
    modules = config.get(key, [])
    if "custom/cronbar" in modules:
        config[key] = [module for module in modules if module != "custom/cronbar"]
        changed = True
if changed:
    path.write_text(json.dumps(config, indent=2, ensure_ascii=False) + "\n")
PY
fi

for _cronbar_root in "$SOLVERFORGE_PATH" "$_cronbar_live_root"; do
  _cronbar_shim="$_cronbar_root/bin/solverforge-waybar-cronbar"
  if [[ -f "$_cronbar_shim" || -L "$_cronbar_shim" ]]; then
    rm -f -- "$_cronbar_shim"
    sf_info "Removed the retired CronBar Waybar shim"
  fi
done

if systemctl --user is-active --quiet cronbar.service ||
   systemctl --user is-enabled --quiet cronbar.service; then
  systemctl --user disable --now cronbar.service
  sf_info "Disabled the retired CronBar companion service"
fi

unset _cronbar_live_root _cronbar_live_config _cronbar_root _cronbar_shim
