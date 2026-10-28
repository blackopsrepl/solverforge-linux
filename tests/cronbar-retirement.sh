#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
python3 - "$repo_root" <<'PY'
import json
import os
import pathlib
import subprocess
import sys
import tempfile

repo = pathlib.Path(sys.argv[1])
config = json.loads((repo / "default/waybar/config").read_text())
assert "custom/cronbar" not in config
assert "custom/backupbar" in config["modules-left"]
assert "custom/backupbar" in config
assert "cronbar" not in (repo / "default/waybar/style.css").read_text()

with tempfile.TemporaryDirectory(prefix="cronbar-retirement-", dir=os.environ["TMPDIR"]) as tmp:
    root = pathlib.Path(tmp)
    live = root / "data/solverforge"
    config_path = live / "default/waybar/config"
    config_path.parent.mkdir(parents=True)
    original = dict(config)
    original["custom/cronbar"] = {"exec": "solverforge-waybar-cronbar"}
    for key in ("modules-left", "modules-center", "modules-right"):
        original[key] = [*config[key], "custom/cronbar"]
    original["machine-local"] = {"preserve": True}
    config_path.write_text(json.dumps(original) + "\n")
    shim = live / "bin/solverforge-waybar-cronbar"
    shim.parent.mkdir()
    shim.write_text("retired shim\n")
    backup_shim = live / "bin/solverforge-waybar-backupbar"
    backup_shim.write_text("preserve backupbar\n")
    script = r'''
set -euo pipefail
sf_info() { printf '%s\n' "$*"; }
systemctl() {
  case "$*" in
    '--user is-active --quiet cronbar.service'|'--user is-enabled --quiet cronbar.service')
      [[ ! -e "$HOME/disabled" ]] ;;
    '--user disable --now cronbar.service') touch "$HOME/disabled" ;;
    *) return 2 ;;
  esac
}
source "$MIGRATION"
'''
    env = dict(os.environ, HOME=str(root), XDG_DATA_HOME=str(root / "data"),
               SOLVERFORGE_PATH=str(live), MIGRATION=str(repo / "migrations/004-retire-cronbar.sh"))
    subprocess.run(["bash", "-c", script], env=env, check=True)
    migrated = json.loads(config_path.read_text())
    assert "custom/cronbar" not in migrated
    for key in ("modules-left", "modules-center", "modules-right"):
        assert migrated[key] == config[key]
    assert migrated["custom/backupbar"] == original["custom/backupbar"]
    assert migrated["machine-local"] == original["machine-local"]
    assert not shim.exists()
    assert backup_shim.read_text() == "preserve backupbar\n"
    assert (root / "disabled").exists()
    stamp = config_path.stat().st_mtime_ns
    result = subprocess.run(["bash", "-c", script], env=env, check=True, capture_output=True, text=True)
    assert result.stdout == ""
    assert config_path.stat().st_mtime_ns == stamp
print("CronBar retirement: Backupbar preserved; migration is idempotent")
PY
