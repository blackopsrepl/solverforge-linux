# shellcheck shell=bash
# SolverForge — retire solverforge-autotile; swaytiles manages layouts now.
# The old exec_always line matched with `pkill -x`, which never matches a name
# longer than 15 characters, so a live session can hold one daemon per reload.

if pgrep -u "$UID" -f '/bin/solverforge-autotile$' >/dev/null; then
  pkill -u "$UID" -f '/bin/solverforge-autotile$'
  sf_info "Stopped the retired solverforge-autotile daemon"
fi
