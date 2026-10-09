# shellcheck shell=bash
# SolverForge — retire the trexbar Waybar companion.
# Session management moved into the Hermes desktop application, so the trexbar
# chip, its Waybar shim, and its daemon supervision are dead weight.
# Idempotent: a tree that never had trexbar, or has already been migrated,
# no-ops.

_trexbar_shim="$SOLVERFORGE_PATH/bin/solverforge-waybar-trexbar"

if [[ -f "$_trexbar_shim" ]]; then
  rm -f "$_trexbar_shim"
  sf_info "Removed the retired trexbar Waybar shim"
fi

# The framework supervised this daemon; stop the stray copy if one survives.
if pgrep -u "$(id -u)" -f "trexbar daemon" >/dev/null 2>&1; then
  pkill -f "trexbar daemon" 2>/dev/null || true
  sf_info "Stopped the retired trexbar daemon"
fi

unset _trexbar_shim
