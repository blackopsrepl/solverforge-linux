#!/bin/bash
set -euo pipefail

# SolverForge Linux — installer orchestrator

export SOLVERFORGE_PATH="${SOLVERFORGE_PATH:-$HOME/.local/share/solverforge}"

# Source helpers
for helper in "$SOLVERFORGE_PATH"/install/helpers/*.sh; do
  # shellcheck source=/dev/null
  source "$helper"
done

# Detect fresh install vs update
if [[ -f "$HOME/.config/sway/config.d/solverforge.conf" ]]; then
  export SOLVERFORGE_FRESH=0
  sf_info "Updating SolverForge Linux..."
else
  export SOLVERFORGE_FRESH=1
  sf_info "Installing SolverForge Linux..."
fi

# Run numbered phases
for script in "$SOLVERFORGE_PATH"/install/0*.sh; do
  # shellcheck source=/dev/null
  source "$script"
done
