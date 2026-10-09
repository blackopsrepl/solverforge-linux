# shellcheck shell=bash
# SolverForge — retire the Yazi file manager.
# Thunar replaced Yazi as the desktop file manager; the theme engine no longer
# wires a Yazi theme, so the old symlink and the config dir it lived in are dead
# weight. The generated theme goes too — nothing consumes it. Idempotent: a tree
# that never had Yazi, or has already been migrated, no-ops.

_yazi_theme="$HOME/.config/yazi/theme.toml"
_yazi_dir="$HOME/.config/yazi"

if [[ -L "$_yazi_theme" && "$(readlink "$_yazi_theme")" == *"/solverforge/"* ]]; then
  rm -f "$_yazi_theme"
  sf_info "Removed the SolverForge Yazi theme symlink"
fi

# Only removes the directory when it is empty, i.e. nothing but our symlink lived there.
if [[ -d "$_yazi_dir" ]]; then
  rmdir "$_yazi_dir" 2>/dev/null &&
    sf_info "Removed the empty ~/.config/yazi"
fi

rm -f "$SOLVERFORGE_PATH/default/theme/generated/yazi-theme.toml"

unset _yazi_theme _yazi_dir
